# AGENTS.md

Django 5.2 + MySQL (Railway). Despliegue en Railway vía `Procfile` (`gunicorn ecommerce.wsgi`), `runtime.txt` (`3.13`).

## Entorno local

Ya existe `venv/` con las 55 dependencias instaladas (Python 3.12). **Úsalo siempre**, no el Python del sistema:

```bash
venv/bin/python manage.py check
```

MySQL local corre en `127.0.0.1:3306` (`root`/`admin`). La BD de desarrollo es **`nexus_motos_local`** (con `sp_actualizar_kardex` y 30 tablas). Ojo: existen también `nexus_motos_` y `nexus_motos_db`, que son restos vacíos/viejos — no las uses.

`requirements.txt` estaba en **UTF-16 con CRLF**; ya está convertido a ASCII. Si alguna vez se regenera en UTF-16, conviértelo antes o `pip install -r` falla.

### Arrancar la app (SIEMPRE con `local.env`)

```bash
set -a; source local.env; set +a
venv/bin/python manage.py runserver
```

⚠️ **Sin ese `source local.env` la app se conecta a PRODUCCIÓN.** `local.env` está gitignored y define `DEBUG=True` y `DB_*` → `127.0.0.1`.

`local.env` no se carga solo: `settings.py` lee `DEBUG` con `decouple` (que sí lee `.env`), pero las `DB_*` las lee con `os.environ`, que exige exportar.

No hay `node`, así que los `.js` no se pueden linterizar — revísalos a mano.
No hay suite de tests: `tienda/tests.py`, `catalogo/tests.py` y `app/tests.py` están vacíos. **La verificación real es manual, contra la BD local.**

## Base de datos: Railway (producción)

`ecommerce/settings.py` tiene credenciales **hardcodeadas** (host `centerbeam.proxy.rlwy.net:43371`, user `root`, password en la línea 95). `.env` solo define `DEBUG` y `DATABASE_URL`, que **no se usa** — la conexión real es el dict `DATABASES` literal.

**Los valores de producción son los defaults.** `DATABASES` lee `DB_NAME`/`DB_USER`/`DB_PASSWORD`/`DB_HOST`/`DB_PORT` de `os.environ`, pero cada uno cae a su valor de producción si la variable no existe. En Railway no existen → comportamiento idéntico al anterior. No agregues variables de entorno en Railway sin avisar.

Para consultar datos de forma directa:

```bash
mysql -h centerbeam.proxy.rlwy.net -P 43371 -u root -p nexus_motos
```

### Reglas de la BD

- **Todos los modelos de `tienda/models.py` son `managed = False`** (~30 modelos). `makemigrations` **no** crea ni altera tablas. Cambios de esquema = `ALTER TABLE` manual contra MySQL.
  - Al agregar un campo al model: edita el model **y** ejecuta el `ALTER TABLE` en producción. Los dos, siempre.
- **La lógica de kardex/stock vive en un stored procedure, no en Python**: `sp_actualizar_kardex`. Se invoca con `cursor.callproc("sp_actualizar_kardex", [...])` en 4 sitios:
  `tienda/views.py:1004` (entrada), `tienda/views.py:1424` y `1746` (venta), `catalogo/views.py:1114` (venta online).
  - **Cambiar comportamiento de stock/margen casi siempre significa editar el SP**, no el Python. El SP crea kardex con `kardex_stock_minimo = 5` y `kardex_porcentaje_utilidad = 20` hardcodeados.
  - Al borrar entradas/ventas hay que revertir el kardex a mano; no se recalcula solo.
  - **Restaurar el SP localmente** volcar con `--routines` y cambiar `DEFINER=\`root\`@\`%\`` por `DEFINER=CURRENT_USER`, si no MySQL local lo rechaza con error 1449. Dump de referencia en `backups/nexus_local_*.sql`.
- Timezone: `USE_TZ = True`, `TIME_ZONE = 'America/Lima'`. **La BD guarda UTC** (Django convierte al escribir) y la UI/filtros usan hora de Lima (UTC−5, sin DST). MySQL local corre en −05 y Railway en UTC, así que **no uses `NOW()` en SQL para fechas que Django también lee: usa `UTC_TIMESTAMP()`** (el trigger del historial y `sp_actualizar_kardex` lo hacen; ver `sql/sp_actualizar_kardex_utc.sql`).
  - **No filtres con `__date`**: MySQL no tiene tablas de zonas y `CONVERT_TZ` devuelve NULL. Usa los helpers `inicio_dia()` / `fin_dia_exclusivo()` de `tienda/views.py` con `__gte` / `__lt`.
  - Al formatear con `strftime` un datetime de la BD, pásalo antes por `timezone.localtime()`. Para "hoy" usa `timezone.localdate()`, no `date.today()` (el servidor de Railway está en UTC).
  - Columnas `DateField` (`financia_fecha_registro`, `det_finan_*`) guardan la fecha de Lima, sin conversión.
- Semántica de IGV: `*_igv` es el **porcentaje** (18), `*_costo_igv` es el **monto**. Hay que respetar ese par en cualquier campo nuevo.

## Fórmulas de precio (no hardcodear)

Margen sobre venta, disponible como `@property TblKardex.precio_venta` (`tienda/models.py:260`):

```
precio_venta = costo / (1 - margen/100)      # margen 20% -> costo / 0.80
```

Devuelve `0.0` si margen >= 100. **Usa la property en templates y vistas; no repitas la aritmética.** Hay que evitar el error clásico de markup vs margen: `costo * 1.2` es markup 20% (equivale a 16.67% de margen), **no** lo mismo.

Utilidad (dashboard, KPIs, reporte de salidas):

```
utilidad = (det_venta_total - det_venta_cantidad * det_venta_precio_costo) / 1.18
```

`det_venta_precio_costo` congela el `kardex_precio_vigente` al momento de vender. **Ambas rutas de venta deben escribirlo** (`tienda/views.py` y `catalogo/views.py`) antes de llamar al SP; si falta queda en `0` y la utilidad sale inflada. No existe backfill: aplica a ventas futuras.

Catálogo online compara `precio_max` contra el precio de venta en Python (no hay columna de precio de venta en BD) y filtra productos sin kardex.

## Static files

- Los assets **viven directo en `staticfiles/`** y están **rastreados en git** (~983 archivos). No existe ningún `*/static` en las apps.
- `staticfiles/` es también `STATIC_ROOT`. En producción los sirve WhiteNoise leyendo ese directorio; `STATICFILES_DIRS` va **vacío** y así debe seguir.
- Con `DEBUG=True` el runserver de Django **no** busca assets dentro de `STATIC_ROOT`, y Django prohíbe (error `staticfiles.E002`) poner `STATIC_ROOT` en `STATICFILES_DIRS`. Por eso `settings.py` mueve `STATIC_ROOT` a `.static_debug/` (carpeta descartable, gitignored) y declara `staticfiles/` como fuente. **Ese bloque sólo aplica con DEBUG: True.**
- **Nunca corras `collectstatic --clear`**: no hay fuentes `*/static`, así que borraría los ~983 assets y no se recuperarían.
- `STATICFILES_STORAGE` (línea ~162) es un ajuste **muerto**: Django lo eliminó en 5.1 y el proyecto usa 5.2. No esperes hashing ni `staticfiles.json`.
- Los `.js` se referencian como `{% static 'tienda/js/agregar_venta.js' %}` → URL `/static/...`.

## Git

- Rama de producción: `main` → `git@github.com:nexus-motos/nexus_motos.git`. El owner hace commit y push localmente por su cuenta; **el agente no debe hacer commit ni push sin que lo pida explícitamente** — es código de producción.
- Convención de mensajes: `<ddmmyyyy>_<descripcion_corta>` (ej. `30092026`, `27092026_mercadoPago`).
- La rama `mis-nuevos-cambios` está fusionada y rezagada; no usarla.
- **`.env` está trackeado en git** (credencial expuesta en el historial). No lo añadas más, y avisa si hay que tocarlo.
- `backups/` **no está en `.gitignore`** y contiene dumps de producción con series/kardex. Antes de cualquier `git add`, stagea rutas explícitas, nunca `git add .`. Ideal: agrega `backups/` a `.gitignore`.

## Cosas que un agente no debe "arreglar" sin preguntar

- `ALLOWED_HOSTS = ['*']` y `CORS_ALLOW_ALL_ORIGINS = True` están puestos a propósito (hay cliente Flutter). Cambiarlos rompe la app móvil.
- El IGV está **fijo en 18** por decisión explícita del owner. No lo parametrizes sin preguntar.
- Los defaults de `sp_actualizar_kardex` (`stock_minimo=5`, margen 20) no coinciden con los datos existentes (`stock_minimo=2` en los kardex previos). Es una inconsistencia conocida, no un error tuyo.
- Los datos de `tbl_kardex` son derivados de entradas y salidas; si borras documentos, actualiza el kardex en la misma operación.

## Antes de borrar datos de producción

1. Dump de las tablas afectadas a `backups/` (timestamps en el nombre).
2. Encapsula en `START TRANSACTION` / `COMMIT`.
3. Respeta el orden de FKs: `tbl_producto_serie.det_entrada_id` → `tbl_det_entrada` → `tbl_entrada`; `det_salida` → `tbl_salida` → `tbl_venta`.
4. `SET FOREIGN_KEY_CHECKS=0` **antes** del `START TRANSACTION`, si hay datos huérfanos.
5. Al terminar verifica que el conteo cuadre contra el estado previo conocido.