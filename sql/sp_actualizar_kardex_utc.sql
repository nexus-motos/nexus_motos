-- sp_actualizar_kardex: kardex_fecha_mov pasa de NOW() a UTC_TIMESTAMP().
-- Unico cambio respecto al SP de produccion (resto del cuerpo identico, incluidos stock_minimo=5 y margen 20).
-- Motivo: Django guarda UTC (USE_TZ=True); NOW() dependia de la zona del servidor MySQL
-- (-05 en local, UTC en Railway). UTC_TIMESTAMP() da el mismo valor en ambos.
-- Sin DEFINER: se crea con el usuario que ejecuta (evita error 1449 en local).
--
-- Aplicar (LOCAL):  mysql -h127.0.0.1 -uroot -p nexus_motos_local < sql/sp_actualizar_kardex_utc.sql
-- PRODUCCION: dump previo en backups/ y confirmar antes de ejecutar.

DROP PROCEDURE IF EXISTS sp_actualizar_kardex;

DELIMITER $$

CREATE PROCEDURE `sp_actualizar_kardex`(
    IN tipoMovimiento VARCHAR(10),
    IN productoId INT,
    IN cantidad_entrada INT,
    IN precio_entrada DECIMAL(7,2),
    IN cantidad_salida INT
)
BEGIN
    DECLARE cant_actual INT DEFAULT 0;
    DECLARE precio_actual DECIMAL(7,2) DEFAULT 0;
    DECLARE costo_total_actual DECIMAL(8,2) DEFAULT 0;

    DECLARE nuevo_cant_actual INT DEFAULT 0;
    DECLARE nuevo_costo_total DECIMAL(8,2) DEFAULT 0;
    DECLARE nuevo_precio_vigente DECIMAL(7,2) DEFAULT 0;

    -- Validacion del tipo de movimiento
    IF tipoMovimiento NOT IN ('ENTRADA', 'SALIDA') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de movimiento debe ser ENTRADA o SALIDA';
    END IF;

    -- Verificar si el producto ya existe en el KARDEX
    IF EXISTS (SELECT 1 FROM tbl_kardex WHERE prod_id = productoId) THEN
        SELECT kardex_stock_actual, kardex_precio_vigente, kardex_costo_total_saldo
        INTO cant_actual, precio_actual, costo_total_actual
        FROM tbl_kardex
        WHERE prod_id = productoId;
    END IF;

    -- Lógica según tipo de movimiento
    IF tipoMovimiento = 'ENTRADA' THEN
        IF cantidad_entrada <> 0 AND precio_entrada <> 0 THEN
            SET nuevo_cant_actual = cant_actual + cantidad_entrada;
            SET nuevo_costo_total = costo_total_actual + (cantidad_entrada * precio_entrada);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad y precio de entrada deben ser distintos de cero';
        END IF;
        SET cantidad_salida = 0;
        SET precio_actual = 0;

    ELSEIF tipoMovimiento = 'SALIDA' THEN
        IF cantidad_salida <> 0 THEN
            SET nuevo_cant_actual = cant_actual - cantidad_salida;
            SET nuevo_costo_total = costo_total_actual - (cantidad_salida * precio_actual);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cantidad de salida debe ser distinta de cero';
        END IF;
        SET cantidad_entrada = 0;
        SET precio_entrada = 0;
    END IF;

    -- Validar stock
    IF nuevo_cant_actual < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para realizar la salida';
    END IF;

    -- Calcular nuevo precio vigente
    IF nuevo_cant_actual <> 0 AND nuevo_costo_total <> 0 THEN
        SET nuevo_precio_vigente = nuevo_costo_total / nuevo_cant_actual;
    ELSE
        SET nuevo_precio_vigente = 0;
    END IF;

    -- Insertar o actualizar KARDEX
    IF EXISTS (SELECT 1 FROM tbl_kardex WHERE prod_id = productoId) THEN
        UPDATE tbl_kardex
        SET
            kardex_fecha_mov = UTC_TIMESTAMP(),
            kardex_cantidad_total_entrada = cantidad_entrada,
            kardex_ultimo_precio_entrada = precio_entrada,
            kardex_cantidad_total_salida = cantidad_salida,
            kardex_ultimo_precio_salida = precio_actual,
            kardex_stock_actual = nuevo_cant_actual,
            kardex_precio_vigente = nuevo_precio_vigente,
            kardex_costo_total_saldo = nuevo_costo_total
        WHERE prod_id = productoId;
    ELSE
        INSERT INTO tbl_kardex (
            kardex_fecha_mov,
            kardex_cantidad_total_entrada,
            kardex_ultimo_precio_entrada,
            kardex_cantidad_total_salida,
            kardex_ultimo_precio_salida,
            kardex_stock_actual,
            kardex_precio_vigente,
            kardex_costo_total_saldo,
            kardex_stock_minimo,
            kardex_porcentaje_utilidad,
            prod_id
        )
        VALUES (
            UTC_TIMESTAMP(),
            cantidad_entrada,
            precio_entrada,
            cantidad_salida,
            precio_actual,
            nuevo_cant_actual,
            nuevo_precio_vigente,
            nuevo_costo_total,
            5,
            20,
            productoId
        );
    END IF;
END$$

DELIMITER ;
