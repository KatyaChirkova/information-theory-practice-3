-- Суммарный размер файлов трёх таблиц в байтах.
SELECT 'PARQUET / ZSTD' AS variant, sum(file_size_in_bytes) AS size_bytes
FROM (
  SELECT file_size_in_bytes FROM iceberg.bench_parquet_zstd."customer$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_parquet_zstd."orders$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_parquet_zstd."lineitem$files"
) files
UNION ALL
SELECT 'PARQUET / GZIP' AS variant, sum(file_size_in_bytes) AS size_bytes
FROM (
  SELECT file_size_in_bytes FROM iceberg.bench_parquet_gzip."customer$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_parquet_gzip."orders$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_parquet_gzip."lineitem$files"
) files
UNION ALL
SELECT 'ORC / ZSTD' AS variant, sum(file_size_in_bytes) AS size_bytes
FROM (
  SELECT file_size_in_bytes FROM iceberg.bench_orc_zstd."customer$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_orc_zstd."orders$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_orc_zstd."lineitem$files"
) files
UNION ALL
SELECT 'ORC / GZIP' AS variant, sum(file_size_in_bytes) AS size_bytes
FROM (
  SELECT file_size_in_bytes FROM iceberg.bench_orc_gzip."customer$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_orc_gzip."orders$files"
  UNION ALL
  SELECT file_size_in_bytes FROM iceberg.bench_orc_gzip."lineitem$files"
) files;
