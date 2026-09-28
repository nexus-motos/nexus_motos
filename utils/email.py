import base64
import logging
import threading
import time
from email.message import EmailMessage
from email.utils import formatdate, make_msgid
from typing import List, Optional, Dict, Any

import requests
from django.conf import settings

logger = logging.getLogger(__name__)

BREVO_API_URL = "https://api.brevo.com/v3/smtp/email"


def _to_b64(data: bytes) -> str:
    return base64.b64encode(data).decode("utf-8")


def _build_mime(
    to_emails: List[str],
    subject: str,
    sender_email: str,
    sender_name: Optional[str] = None,
    html_content: Optional[str] = None,
    text_content: Optional[str] = None,
    attachments: Optional[List[Dict[str, Any]]] = None,
    brevo_message_id: Optional[str] = None,
) -> bytes:
    """Reconstruye el mensaje enviado por Brevo como MIME para guardarlo en Enviados."""
    msg = EmailMessage()
    msg["From"] = (
        f"{sender_name} <{sender_email}>" if sender_name else sender_email
    )
    msg["To"] = ", ".join(to_emails)
    msg["Subject"] = subject
    msg["Date"] = formatdate(localtime=True)
    msg["Message-ID"] = make_msgid(domain=sender_email.split("@")[-1])
    if brevo_message_id:
        msg["X-Brevo-Message-Id"] = brevo_message_id

    body = text_content or html_content or ""
    msg.set_content(body)
    if html_content and text_content:
        msg.add_alternative(html_content, subtype="html")

    for att in attachments or []:
        raw = base64.b64decode(att["content"])
        content_type = att.get("contentType", "application/octet-stream")
        maintype, _, subtype = content_type.partition("/")
        msg.add_attachment(
            raw,
            maintype=maintype or "application",
            subtype=subtype or "octet-stream",
            filename=att.get("name", "archivo"),
        )

    return msg.as_bytes()


def _append_worker(mime_bytes: bytes) -> None:
    """Ejecuta el IMAP APPEND. Corre en un hilo: nunca debe propagar errores."""
    import imaplib

    try:
        imap = imaplib.IMAP4_SSL(
            settings.IMAP_HOST,
            settings.IMAP_PORT,
            timeout=settings.IMAP_TIMEOUT,
        )
    except Exception as exc:
        logger.warning("IMAP append: no se pudo conectar a %s (%s)", settings.IMAP_HOST, exc)
        return

    try:
        imap.login(settings.IMAP_USER, settings.IMAP_PASSWORD)
        status, data = imap.append(
            f'"{settings.IMAP_SENT_FOLDER}"',
            "\\Seen",
            imaplib.Time2Internaldate(time.time()),
            mime_bytes,
        )
        if status == "OK":
            logger.info("IMAP append: copia guardada en %s", settings.IMAP_SENT_FOLDER)
        else:
            logger.warning(
                "IMAP append en %s devolvio %s: %s",
                settings.IMAP_SENT_FOLDER,
                status,
                data,
            )
    except Exception as exc:
        logger.warning("IMAP append fallo (no afecta al envio): %s", exc)
    finally:
        try:
            imap.logout()
        except Exception:
            pass


def copy_to_sent(mime_bytes: bytes) -> bool:
    """Lanza la copia a la bandeja Enviados en segundo plano. No bloquea ni lanza."""
    if not getattr(settings, "IMAP_COPY_TO_SENT", False):
        return False
    if not getattr(settings, "IMAP_USER", "") or not getattr(settings, "IMAP_PASSWORD", ""):
        logger.warning("IMAP append: IMAP_USER o IMAP_PASSWORD no configurados")
        return False
    threading.Thread(target=_append_worker, args=(mime_bytes,), daemon=True).start()
    return True


def send_email_brevo(
    to_emails: List[str],
    subject: str,
    html_content: Optional[str] = None,
    text_content: Optional[str] = None,
    attachments: Optional[List[Dict[str, Any]]] = None,
    sender_email: Optional[str] = None,
    sender_name: Optional[str] = None,
    timeout: int = 15,
) -> Dict[str, Any]:
    """
    Envía email mediante la API de Brevo (HTTPS).
    - to_emails: lista de destinatarios
    - subject: asunto
    - html_content: contenido HTML (recomendado)
    - text_content: contenido plano (opcional)
    - attachments: lista [{ "name": "file.pdf", "content": "<base64>", "contentType": "application/pdf" }]
    """

    if not settings.BREVO_API_KEY:
        raise RuntimeError("BREVO_API_KEY no está configurada.")

    headers = {
        "accept": "application/json",
        "api-key": settings.BREVO_API_KEY,
        "content-type": "application/json",
    }

    sender_email = sender_email or getattr(settings, "DEFAULT_FROM_EMAIL", None)
    sender_name = sender_name or getattr(settings, "SENDER_NAME", None)

    if not sender_email:
        raise ValueError("DEFAULT_FROM_EMAIL no está configurado.")

    payload: Dict[str, Any] = {
        "sender": {"email": sender_email},
        "to": [{"email": e} for e in to_emails],
        "subject": subject,
    }
    if sender_name:
        payload["sender"]["name"] = sender_name
    if html_content:
        payload["htmlContent"] = html_content
    if text_content:
        payload["textContent"] = text_content
    if attachments:
        payload["attachment"] = attachments

    resp = requests.post(BREVO_API_URL, headers=headers, json=payload, timeout=timeout)

    # Brevo normalmente devuelve 201 Created al enviar
    try:
        data = resp.json()
    except Exception:
        data = {"raw": resp.text}

    if resp.status_code >= 400:
        # Log detallado para depurar
        logger.error("Brevo API error %s: %s", resp.status_code, data)
        raise RuntimeError(f"Error Brevo API ({resp.status_code}): {data}")

    # Copia en la bandeja "Enviados" del buzon (solo si el envio fue aceptado)
    try:
        copy_to_sent(
            _build_mime(
                to_emails=to_emails,
                subject=subject,
                sender_email=sender_email,
                sender_name=sender_name,
                html_content=html_content,
                text_content=text_content,
                attachments=attachments,
                brevo_message_id=data.get("messageId"),
            )
        )
    except Exception as exc:
        logger.warning("No se pudo preparar la copia en Enviados: %s", exc)

    return data


def make_pdf_attachment(filename: str, pdf_bytes: bytes) -> Dict[str, str]:
    """Crea el dict de adjunto en el formato que espera Brevo."""
    return {
        "name": filename,
        "content": _to_b64(pdf_bytes),
        "contentType": "application/pdf",
    }


def send_mail_api(
    subject: str,
    message: str,
    recipient_list: List[str],
    *,
    html_message: Optional[str] = None,
    attachments: Optional[List[Dict[str, Any]]] = None,
) -> Dict[str, Any]:
    """
    Reemplazo sencillo para django.core.mail.send_mail usando Brevo API.
    - message → textContent
    - html_message → htmlContent
    """
    return send_email_brevo(
        to_emails=recipient_list,
        subject=subject,
        html_content=html_message,
        text_content=message,
        attachments=attachments,
    )
