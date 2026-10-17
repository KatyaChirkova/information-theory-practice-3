-- Run against the Iceberg catalog using Trino CLI or the web UI.
CREATE SCHEMA IF NOT EXISTS iceberg.bronze;
CREATE SCHEMA IF NOT EXISTS iceberg.silver;
CREATE SCHEMA IF NOT EXISTS iceberg.gold;

-- Bronze contains all columns from the three source tables so it stays raw.
CREATE TABLE iceberg.bronze.customer
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.customer;
CREATE TABLE iceberg.bronze.orders
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.orders;
CREATE TABLE iceberg.bronze.lineitem
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.lineitem;

-- Silver: pre-aggregate line items to large orders, then join dimensions.
CREATE TABLE iceberg.silver.large_orders
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT orderkey, sum(quantity) AS total_quantity
FROM iceberg.bronze.lineitem
GROUP BY orderkey
HAVING sum(quantity) > 300;

CREATE TABLE iceberg.silver.enriched_orders
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT c.name, c.custkey, o.orderkey, o.orderdate, o.totalprice,
       lo.total_quantity
FROM iceberg.silver.large_orders lo
JOIN iceberg.bronze.orders o ON o.orderkey = lo.orderkey
JOIN iceberg.bronze.customer c ON c.custkey = o.custkey;

CREATE TABLE iceberg.gold.q18_top100
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT name, custkey, orderkey, orderdate, totalprice, total_quantity
FROM iceberg.silver.enriched_orders
ORDER BY totalprice DESC, orderdate
LIMIT 100;

-- Inspect the saved result and Iceberg snapshots:
SELECT count(*) FROM iceberg.gold.q18_top100;
SELECT * FROM iceberg.gold.q18_top100 ORDER BY totalprice DESC, orderdate;
SELECT * FROM iceberg.gold."q18_top100$snapshots" ORDER BY committed_at DESC;

-- Example time travel query; replace 1234567890123456789 with the actual
-- snapshot ID returned above:
-- SELECT * FROM iceberg.gold.q18_top100 FOR VERSION AS OF 1234567890123456789;

-- Schema evolution example on Silver (metadata-only addition in Iceberg):
ALTER TABLE iceberg.silver.enriched_orders ADD COLUMN study_note VARCHAR;
DESCRIBE iceberg.silver.enriched_orders;

-- Compression comparison: create a complete second Bronze using GZIP,
-- run sql/q18_bronze.sql against each schema and compare elapsed time and
-- data-file sizes. Both copies must have the same source rows and columns.
CREATE SCHEMA IF NOT EXISTS iceberg.bronze_gzip;
CREATE TABLE iceberg.bronze_gzip.customer
WITH (format='PARQUET', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.customer;
CREATE TABLE iceberg.bronze_gzip.orders
WITH (format='PARQUET', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.orders;
CREATE TABLE iceberg.bronze_gzip.lineitem
WITH (format='PARQUET', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.lineitem;
