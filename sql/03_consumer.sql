
-- PRE-ENTREGA 6 - Paso 3: capa de consumo
-- Agregaciones por minuto y ticker.
-- Actualizacion manual de la vista materializada.

CREATE MATERIALIZED VIEW analytics_consumption.stock_quotes_por_minuto
AS
SELECT
    DATE_TRUNC(
        'minute',
        JSON_EXTRACT_PATH_TEXT(
            JSON_SERIALIZE(payload), 'EVENT_TIME'
        )::TIMESTAMPTZ
    ) AS minuto,

    JSON_EXTRACT_PATH_TEXT(
        JSON_SERIALIZE(payload), 'TICKER'
    ) AS ticker,

    COUNT(*) AS registros,

    SUM(
        JSON_EXTRACT_PATH_TEXT(
            JSON_SERIALIZE(payload), 'PRICE'
        )::DECIMAL(18,6)
    ) AS suma_precios

FROM raw_streaming.stock_quotes_raw
GROUP BY 1, 2;

-- Actualizacion manual
REFRESH MATERIALIZED VIEW
analytics_consumption.stock_quotes_por_minuto;

-- Consulta del tablero: cotizaciones de los ultimos 5 minutos.
SELECT
    minuto,
    ticker,
    registros,
    suma_precios,
    ROUND(suma_precios / NULLIF(registros, 0), 4) AS precio_promedio
FROM analytics_consumption.stock_quotes_por_minuto
WHERE minuto >= DATEADD(minute, -5, GETDATE())
ORDER BY minuto DESC, ticker;
