-- Повторно создаёт тестовые копии customer, orders и lineitem.

-- После выполнения время записи каждой таблицы смотреть в статистике Trino.

CREATE SCHEMA IF NOT EXISTS iceberg.bench_parquet_zstd;
DROP TABLE IF EXISTS iceberg.bench_parquet_zstd.customer;
CREATE TABLE iceberg.bench_parquet_zstd.customer
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.customer;
DROP TABLE IF EXISTS iceberg.bench_parquet_zstd.orders;
CREATE TABLE iceberg.bench_parquet_zstd.orders
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.orders;
DROP TABLE IF EXISTS iceberg.bench_parquet_zstd.lineitem;
CREATE TABLE iceberg.bench_parquet_zstd.lineitem
WITH (format='PARQUET', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.lineitem;

CREATE SCHEMA IF NOT EXISTS iceberg.bench_parquet_gzip;
DROP TABLE IF EXISTS iceberg.bench_parquet_gzip.customer;
CREATE TABLE iceberg.bench_parquet_gzip.customer
WITH (format='PARQUET', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.customer;
DROP TABLE IF EXISTS iceberg.bench_parquet_gzip.orders;
CREATE TABLE iceberg.bench_parquet_gzip.orders
WITH (format='PARQUET', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.orders;
DROP TABLE IF EXISTS iceberg.bench_parquet_gzip.lineitem;
CREATE TABLE iceberg.bench_parquet_gzip.lineitem
WITH (format='PARQUET', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.lineitem;

CREATE SCHEMA IF NOT EXISTS iceberg.bench_orc_zstd;
DROP TABLE IF EXISTS iceberg.bench_orc_zstd.customer;
CREATE TABLE iceberg.bench_orc_zstd.customer
WITH (format='ORC', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.customer;
DROP TABLE IF EXISTS iceberg.bench_orc_zstd.orders;
CREATE TABLE iceberg.bench_orc_zstd.orders
WITH (format='ORC', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.orders;
DROP TABLE IF EXISTS iceberg.bench_orc_zstd.lineitem;
CREATE TABLE iceberg.bench_orc_zstd.lineitem
WITH (format='ORC', format_version=2, compression_codec='ZSTD') AS
SELECT * FROM tpch.sf1.lineitem;

CREATE SCHEMA IF NOT EXISTS iceberg.bench_orc_gzip;
DROP TABLE IF EXISTS iceberg.bench_orc_gzip.customer;
CREATE TABLE iceberg.bench_orc_gzip.customer
WITH (format='ORC', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.customer;
DROP TABLE IF EXISTS iceberg.bench_orc_gzip.orders;
CREATE TABLE iceberg.bench_orc_gzip.orders
WITH (format='ORC', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.orders;
DROP TABLE IF EXISTS iceberg.bench_orc_gzip.lineitem;
CREATE TABLE iceberg.bench_orc_gzip.lineitem
WITH (format='ORC', format_version=2, compression_codec='GZIP') AS
SELECT * FROM tpch.sf1.lineitem;
