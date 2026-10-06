-- Historial de precios de venta con vigencia (inicio/fin).
-- Requiere MySQL 8 (LEAD). Idempotente: se puede re-ejecutar sin duplicar datos.
-- No toca sp_actualizar_kardex ni tbl_kardex: solo la "escucha" mediante triggers.
--
-- Aplicar (LOCAL):
--   mysql -h127.0.0.1 -uroot -p nexus_motos_local < sql/historial_precios.sql
-- PRODUCCION: dump previo a backups/ y confirmar antes de ejecutar.

-- 1) Tabla de historial. Sin FK a proposito: el historial sobrevive si se borra el kardex.
--    hist_fecha = inicio de vigencia en UTC (UTC_TIMESTAMP(), igual que lo que guarda Django con
--    USE_TZ=True; NOW() dependeria de la zona del servidor MySQL: -05 en local, UTC en Railway).
CREATE TABLE IF NOT EXISTS tbl_kardex_historial (
  hist_id           INT AUTO_INCREMENT PRIMARY KEY,
  prod_id           INT NOT NULL,
  hist_fecha        DATETIME NOT NULL,
  hist_costo        DECIMAL(7,2) NOT NULL,   -- kardex_precio_vigente
  hist_margen       DECIMAL(5,2) NOT NULL,   -- kardex_porcentaje_utilidad
  hist_precio_venta DECIMAL(9,2) NOT NULL,   -- costo / (1 - margen/100); 0 si margen >= 100
  hist_stock        INT NOT NULL,
  KEY ix_hist_prod_fecha (prod_id, hist_fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2) Triggers sobre tbl_kardex
DROP TRIGGER IF EXISTS trg_kardex_hist_ai;
DROP TRIGGER IF EXISTS trg_kardex_hist_au;

DELIMITER $$

-- Kardex nuevo (primer movimiento de un producto): fila inicial.
CREATE DEFINER=CURRENT_USER TRIGGER trg_kardex_hist_ai
AFTER INSERT ON tbl_kardex
FOR EACH ROW
BEGIN
  INSERT INTO tbl_kardex_historial
    (prod_id, hist_fecha, hist_costo, hist_margen, hist_precio_venta, hist_stock)
  VALUES
    (NEW.prod_id, UTC_TIMESTAMP(), NEW.kardex_precio_vigente, NEW.kardex_porcentaje_utilidad,
     IF(NEW.kardex_porcentaje_utilidad >= 100, 0,
        ROUND(NEW.kardex_precio_vigente / (1 - NEW.kardex_porcentaje_utilidad / 100), 2)),
     NEW.kardex_stock_actual);
END$$

-- Solo registra cuando cambia el costo o el margen. Tolerancia de 0.01 en el costo
-- para ignorar el ruido de redondeo del SP en las salidas.
CREATE DEFINER=CURRENT_USER TRIGGER trg_kardex_hist_au
AFTER UPDATE ON tbl_kardex
FOR EACH ROW
BEGIN
  IF ABS(NEW.kardex_precio_vigente - OLD.kardex_precio_vigente) >= 0.01
     OR NEW.kardex_porcentaje_utilidad <> OLD.kardex_porcentaje_utilidad THEN
    INSERT INTO tbl_kardex_historial
      (prod_id, hist_fecha, hist_costo, hist_margen, hist_precio_venta, hist_stock)
    VALUES
      (NEW.prod_id, UTC_TIMESTAMP(), NEW.kardex_precio_vigente, NEW.kardex_porcentaje_utilidad,
       IF(NEW.kardex_porcentaje_utilidad >= 100, 0,
          ROUND(NEW.kardex_precio_vigente / (1 - NEW.kardex_porcentaje_utilidad / 100), 2)),
       NEW.kardex_stock_actual);
  END IF;
END$$

DELIMITER ;

-- 3) Vista con la vigencia: fecha_fin = inicio del siguiente periodo (NULL = vigente).
--    Intervalo semiabierto [fecha_inicio, fecha_fin): sin huecos ni solapes.
CREATE OR REPLACE VIEW vw_precio_venta_vigencia AS
SELECT
  hist_id,
  prod_id,
  hist_costo,
  hist_margen,
  hist_precio_venta,
  hist_stock,
  hist_fecha AS fecha_inicio,
  LEAD(hist_fecha) OVER (PARTITION BY prod_id ORDER BY hist_fecha, hist_id) AS fecha_fin
FROM tbl_kardex_historial;

-- 4) Semilla "desde hoy": estado actual de cada producto con kardex.
--    Solo si el historial esta vacio (no duplica al re-ejecutar).
INSERT INTO tbl_kardex_historial
  (prod_id, hist_fecha, hist_costo, hist_margen, hist_precio_venta, hist_stock)
SELECT
  k.prod_id, UTC_TIMESTAMP(), k.kardex_precio_vigente, k.kardex_porcentaje_utilidad,
  IF(k.kardex_porcentaje_utilidad >= 100, 0,
     ROUND(k.kardex_precio_vigente / (1 - k.kardex_porcentaje_utilidad / 100), 2)),
  k.kardex_stock_actual
FROM tbl_kardex k
WHERE NOT EXISTS (SELECT 1 FROM tbl_kardex_historial);
