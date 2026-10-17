CREATE SCHEMA IF NOT EXISTS iceberg.bronze;
CREATE SCHEMA IF NOT EXISTS iceberg.silver;
CREATE SCHEMA IF NOT EXISTS iceberg.gold;

-- Bronze: исходные таблицы без преобразований.
CREATE TABLE iceberg.bronze.customer
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.customer;
CREATE TABLE iceberg.bronze.orders
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.orders;
CREATE TABLE iceberg.bronze.lineitem
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.lineitem;

-- Silver: отбор заказов по суммарному количеству и соединение с клиентами.
CREATE TABLE iceberg.silver.large_orders
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT orderkey, sum(quantity) AS total_quantity
FROM iceberg.bronze.lineitem
GROUP BY orderkey
HAVING sum(quantity) > 300;

CREATE TABLE iceberg.silver.enriched_orders
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT trim(c.name) AS name, c.custkey, o.orderkey, o.orderdate, o.totalprice,
       lo.total_quantity
FROM iceberg.silver.large_orders lo
JOIN iceberg.bronze.orders o ON o.orderkey = lo.orderkey
JOIN iceberg.bronze.customer c ON c.custkey = o.custkey
WHERE trim(c.name) <> '';

CREATE TABLE iceberg.gold.q18_top100
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT name, custkey, orderkey, orderdate, totalprice, total_quantity
FROM iceberg.silver.enriched_orders
ORDER BY totalprice DESC, orderdate
LIMIT 100;

SELECT count(*) FROM iceberg.gold.q18_top100;
SELECT * FROM iceberg.gold.q18_top100 ORDER BY totalprice DESC, orderdate;
SELECT * FROM iceberg.gold."q18_top100$snapshots" ORDER BY committed_at DESC;

-- Проверка эволюции схемы Iceberg.
ALTER TABLE iceberg.silver.enriched_orders ADD COLUMN study_note VARCHAR;
DESCRIBE iceberg.silver.enriched_orders;

-- Копия Bronze со сжатием GZIP для сравнения с ZSTD.
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
