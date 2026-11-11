
-- PRE-ENTREGA 6 - Integracion con el Lakehouse.
-- Vista late-binding para consultar la tabla externa Iceberg.

CREATE EXTERNAL SCHEMA IF NOT EXISTS lake
FROM DATA CATALOG
DATABASE 'stock_lakehouse_dev'
REGION 'us-east-2'
IAM_ROLE 'arn:aws:iam::286123979983:role/stock-lakehouse-redshift-dev';

CREATE OR REPLACE VIEW analytics_consumption.stock_quotes_vs_historico AS
SELECT
    c.ticker,
    c.minuto,
    c.registros,
    c.precio_promedio,
    h.precio_promedio_historico,
    h.max_price_historico,
    h.min_price_historico,
    c.precio_promedio - h.precio_promedio_historico AS desvio
FROM (
    SELECT
        ticker,
        minuto,
        registros,
        suma_precios / NULLIF(registros, 0) AS precio_promedio
    FROM analytics_consumption.stock_quotes_por_minuto
) c
JOIN (
    SELECT
        ticker,
        AVG(avg_price) AS precio_promedio_historico,
        MAX(max_price) AS max_price_historico,
        MIN(min_price) AS min_price_historico
    FROM lake.stock_aggregations
    GROUP BY ticker
) h
    ON h.ticker = c.ticker
WITH NO SCHEMA BINDING;

-- Verificacion de la integracion.
SELECT *
FROM analytics_consumption.stock_quotes_vs_historico
ORDER BY minuto DESC, ticker
LIMIT 20;
