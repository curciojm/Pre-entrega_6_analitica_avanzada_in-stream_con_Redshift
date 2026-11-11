
-- PRE-ENTREGA 6 - Paso 6: monitoreo.
-- Consultas sobre las vistas SYS de Amazon Redshift.

-- 6.1 Salud de los refresh de las vistas materializadas.
SELECT
    mv_name,
    refresh_type,
    status,
    start_time,
    end_time,
    duration
FROM sys_mv_refresh_history
ORDER BY start_time DESC
LIMIT 20;


-- 6.2 Estado de lectura del stream por shard.
-- El lag se estima comparando el momento del lote
-- con la llegada del ultimo registro leido.

SELECT
    partition_id,
    MAX(record_time) AS ultimo_lote,
    SUM(scanned_rows) AS filas,
    DATEDIFF(
        second,
        MAX(stream_record_time_max),
        MAX(record_time)
    ) AS lag_aprox_seg
FROM sys_stream_scan_states
WHERE mv_name = 'stock_quotes_raw'
  AND record_time > DATEADD(hour, -1, GETDATE())
GROUP BY partition_id
ORDER BY partition_id;


-- 6.3 Registros con errores de ingesta.
-- SYS_STREAM_SCAN_ERRORS registra, entre otros casos,
-- errores por exceder el tamano maximo permitido.

SELECT *
FROM sys_stream_scan_errors
WHERE mv_name = 'stock_quotes_raw'
ORDER BY record_time DESC
LIMIT 20;


-- 6.4 Frescura de punta a punta:
-- segundos transcurridos desde la llegada del ultimo registro.

SELECT
    DATEDIFF(
        second,
        MAX(approximate_arrival_timestamp),
        GETDATE()
    ) AS segundos_desde_ultimo_registro
FROM raw_streaming.stock_quotes_raw;
