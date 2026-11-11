
-- ============================================================
-- PRE-ENTREGA 6 - REDSHIFT STREAMING INGESTION
-- Paso 1: Kinesis -> Streaming Materialized View
-- Región: us-east-2
-- ============================================================

-- 1.1 Esquema externo conectado a Kinesis
-- Reemplazar el ARN por el output real de Terraform.

CREATE EXTERNAL SCHEMA IF NOT EXISTS kds
FROM KINESIS
REGION 'us-east-2'
IAM_ROLE 'arn:aws:iam::286123979983:role/stock-lakehouse-redshift-dev';

-- 1.2 Esquemas por capa

CREATE SCHEMA IF NOT EXISTS raw_streaming;

CREATE SCHEMA IF NOT EXISTS analytics_clean;

CREATE SCHEMA IF NOT EXISTS analytics_consumption;

-- 1.3 Materialized View de ingesta
-- Conserva el JSON completo en formato SUPER.
-- Los registros que no sean JSON válido se descartan.

CREATE MATERIALIZED VIEW raw_streaming.stock_quotes_raw
AUTO REFRESH YES
AS
SELECT
    approximate_arrival_timestamp,
    partition_key,
    shard_id,
    sequence_number,
    refresh_time,
    JSON_PARSE(kinesis_data) AS payload
FROM kds."dev-kinesis-lakehouse-stream"
WHERE CAN_JSON_PARSE(kinesis_data);

-- 1.4 Primer refresh manual

REFRESH MATERIALIZED VIEW raw_streaming.stock_quotes_raw;

-- 1.5 Verificación de ingesta

SELECT
    COUNT(*) AS registros,
    MIN(approximate_arrival_timestamp) AS desde,
    MAX(approximate_arrival_timestamp) AS hasta
FROM raw_streaming.stock_quotes_raw;

-- 1.6 Inspección de registros

SELECT *
FROM raw_streaming.stock_quotes_raw
LIMIT 10;
