"""
Diagnostico IMAP para la copia de correos en la bandeja "Enviados".

Solo biblioteca estandar (imaplib/os/sys/time). No requiere Django ni installs.

Uso:
    IMAP_USER=contacto@nexusmotos.store \
    IMAP_PASSWORD='****' \
    python3 scripts/imap_probe.py

Opciones:
    --no-append     Solo lista carpetas (no escribe nada)
    --folder NAME   Fuerza la carpeta de enviados
    --send          Envia un correo real via API de Brevo antes del APPEND
"""

import imaplib
import os
import sys
import time
from email.message import EmailMessage
from email.utils import formatdate, make_msgid

HOST = os.getenv("IMAP_HOST", "mail.privateemail.com")
PORT = int(os.getenv("IMAP_PORT", "993"))
USER = os.getenv("IMAP_USER", "")
PASSWORD = os.getenv("IMAP_PASSWORD", "")
FORCED_FOLDER = None
DO_APPEND = True
DO_SEND = False

for arg in sys.argv[1:]:
    if arg == "--no-append":
        DO_APPEND = False
    elif arg == "--send":
        DO_SEND = True
    elif arg == "--folder":
        continue
    elif arg.startswith("--folder="):
        FORCED_FOLDER = arg.split("=", 1)[1]

if "--folder" in sys.argv:
    FORCED_FOLDER = sys.argv[sys.argv.index("--folder") + 1]

CANDIDATES = ["Sent", "INBOX.Sent", "Enviados", "INBOX.Enviados", "Sent Items", "Sent Messages"]


def build_probe_message() -> bytes:
    msg = EmailMessage()
    msg["From"] = USER
    msg["To"] = USER
    msg["Subject"] = "Prueba de copia en Enviados - Nexus Motos"
    msg["Date"] = formatdate(localtime=True)
    msg["Message-ID"] = make_msgid(domain="nexusmotos.store")
    msg.set_content(
        "Este es un mensaje de prueba generado por scripts/imap_probe.py.\n"
        "Si lo lees en la carpeta Enviados, la copia IMAP funciona.\n"
        "Puedes borrarlo con seguridad.\n"
    )
    return msg.as_bytes()


def list_folders(imap: imaplib.IMAP4_SSL) -> list:
    status, data = imap.list()
    folders = []
    if status != "OK":
        return folders
    for raw in data:
        if not raw:
            continue
        line = raw.decode("utf-8", errors="replace")
        # Formato: (\HasNoChildren) "/" "Sent"
        name = line.split(' "/" ')[-1].strip().strip('"')
        flags = line.split(" ")[0]
        folders.append((name, flags))
    return folders


def pick_sent_folder(folders: list) -> str:
    if FORCED_FOLDER:
        return FORCED_FOLDER
    lowered = {name.lower(): name for name, _ in folders}
    for cand in CANDIDATES:
        if cand.lower() in lowered:
            return lowered[cand.lower()]
    for name, _ in folders:
        if "sent" in name.lower() or "enviad" in name.lower():
            return name
    return "Sent"


def main() -> int:
    if not USER or not PASSWORD:
        print("ERROR: faltan IMAP_USER o IMAP_PASSWORD")
        return 2

    print(f"Conectando a {HOST}:{PORT} como {USER} ...")
    try:
        imap = imaplib.IMAP4_SSL(HOST, PORT, timeout=15)
    except Exception as exc:
        print(f"ERROR de conexion: {exc}")
        return 3

    try:
        try:
            imap.login(USER, PASSWORD)
            print("LOGIN: OK")
        except imaplib.IMAP4.error as exc:
            print(f"LOGIN FALLIDO: {exc}")
            return 4
        except Exception as exc:
            print(f"LOGIN ERROR: {exc}")
            return 4

        folders = list_folders(imap)
        print(f"\nCarpetas encontradas ({len(folders)}):")
        for name, flags in folders:
            print(f"  - {name}   {flags}")

        target = pick_sent_folder(folders)
        print(f"\nCarpeta de enviados seleccionada: {target}")

        if not DO_APPEND:
            print("\n(--no-append) No se escribe nada. Fin.")
            return 0

        if DO_SEND:
            send_via_brevo()

        now = imaplib.Time2Internaldate(time.time())
        status, data = imap.append(f'"{target}"', "\\Seen", now, build_probe_message())
        if status == "OK":
            print(f"APPEND en '{target}': OK")
            print("\nRESULTADO: la copia en Enviados FUNCIONA.")
            return 0
        print(f"APPEND en '{target}': FALLO {status} {data}")
        return 5
    finally:
        try:
            imap.logout()
        except Exception:
            pass


def send_via_brevo() -> None:
    """Opcional: envia un correo real por Brevo para probar el hook completo."""
    try:
        import requests
    except ImportError:
        print("\n(--send) requests no disponible, se omite el envio por Brevo")
        return

    key = os.getenv("BREVO_API_KEY", "")
    sender = os.getenv("DEFAULT_FROM_EMAIL", USER)
    name = os.getenv("SENDER_NAME", "Nexus Motos")
    if not key:
        print("\n(--send) BREVO_API_KEY no disponible, se omite")
        return

    payload = {
        "sender": {"email": sender, "name": name},
        "to": [{"email": os.getenv("PROBE_TO", USER)}],
        "subject": "Prueba IMAP APPEND - copia en Enviados",
        "textContent": "Correo de prueba. La copia debe aparecer en la carpeta Enviados.",
    }
    resp = requests.post(
        "https://api.brevo.com/v3/smtp/email",
        headers={"accept": "application/json", "api-key": key, "content-type": "application/json"},
        json=payload,
        timeout=15,
    )
    print(f"\n(--send) Brevo respondio {resp.status_code}: {resp.text[:200]}")


if __name__ == "__main__":
    sys.exit(main())
