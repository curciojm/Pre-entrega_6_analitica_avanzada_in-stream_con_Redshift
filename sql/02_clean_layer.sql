
-- PRE-ENTREGA 6 - Paso 2: tipado y deduplicacion

CREATE OR REPLACE VIEW analytics_clean.stock_quotes_unicos AS
WITH datos_extraidos AS (
    SELECT
        JSON_EXTRACT_PATH_TEXT(
            JSON_SERIALIZE(payload), 'TICKER'
        ) AS ticker,

        JSON_EXTRACT_PATH_TEXT(
            JSON_SERIALIZE(payload), 'EVENT_TIME'
        )::TIMESTAMPTZ AS event_time,

        JSON_EXTRACT_PATH_TEXT(
            JSON_SERIALIZE(payload), 'PRICE'
        )::DECIMAL(18,6) AS price,

        approximate_arrival_timestamp,
        sequence_number

    FROM raw_streaming.stock_quotes_raw
),
datos_numerados AS (
    SELECT
        ticker,
        event_time,
        price,
        approximate_arrival_timestamp,

        ROW_NUMBER() OVER (
            PARTITION BY ticker, event_time, price
            ORDER BY approximate_arrival_timestamp, sequence_number
        ) AS rn

    FROM datos_extraidos
)
SELECT
    ticker,
    event_time,
    price,
    approximate_arrival_timestamp
FROM datos_numerados
WHERE rn = 1;

-- Verificacion
SELECT *
FROM analytics_clean.stock_quotes_unicos
LIMIT 20;
