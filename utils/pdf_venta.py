from django.conf import settings

from tienda.models import TblProductoSerie

# Alto (en unidades de xhtml2pdf) que ocupa la tabla de productos: ~30% de la página A4.
ALTURA_TABLA_PRODUCTOS = 275
ALTURA_ENCABEZADO_TABLA = 28
ALTURA_LINEA = 15
ALTURA_PADDING_FILA = 10


def ruta_logo_pdf():
    """Ruta absoluta del logo; xhtml2pdf necesita una ruta de archivo, no una URL /static/."""
    return str(settings.BASE_DIR / 'staticfiles' / 'assets' / 'img' / 'logos' / 'Nexus_2.png')


def preparar_detalle_pdf(venta, detalle_venta):
    """
    Adjunta a cada item de la venta sus series (tbl_producto_serie vía salida de la venta)
    y calcula el alto de relleno para que la tabla de productos ocupe ~30% de la página.
    Devuelve (lista_de_items, relleno_altura).
    """
    items = list(detalle_venta)
    ocupado = ALTURA_ENCABEZADO_TABLA

    for item in items:
        series = TblProductoSerie.objects.filter(
            det_salida__salida__venta=venta,
            det_salida__prod=item.prod,
        ).order_by('prod_ser_id').values_list('prod_ser_serie', flat=True)
        item.series_texto = ', '.join(series)

        prod = item.prod
        lineas = 1  # código marca modelo categoría
        lineas += bool(item.series_texto)
        lineas += bool(prod.prod_cilindrada)
        lineas += bool(prod.prod_tono)
        lineas += bool(prod.prod_aniofabricacion)
        ocupado += lineas * ALTURA_LINEA + ALTURA_PADDING_FILA

    return items, max(0, ALTURA_TABLA_PRODUCTOS - ocupado)
