-- PARQUET / ZSTD
SELECT
  c.name,
  c.custkey,
  o.orderkey,
  o.orderdate,
  o.totalprice,
  sum(l.quantity) AS total_quantity
FROM iceberg.bench_parquet_zstd.customer AS c
JOIN iceberg.bench_parquet_zstd.orders AS o ON c.custkey = o.custkey
JOIN iceberg.bench_parquet_zstd.lineitem AS l ON o.orderkey = l.orderkey
WHERE o.orderkey IN (
  SELECT orderkey
  FROM iceberg.bench_parquet_zstd.lineitem
  GROUP BY orderkey
  HAVING sum(quantity) > 300
)
GROUP BY c.name, c.custkey, o.orderkey, o.orderdate, o.totalprice
ORDER BY o.totalprice DESC, o.orderdate
LIMIT 100;

-- PARQUET / GZIP
SELECT
  c.name,
  c.custkey,
  o.orderkey,
  o.orderdate,
  o.totalprice,
  sum(l.quantity) AS total_quantity
FROM iceberg.bench_parquet_gzip.customer AS c
JOIN iceberg.bench_parquet_gzip.orders AS o ON c.custkey = o.custkey
JOIN iceberg.bench_parquet_gzip.lineitem AS l ON o.orderkey = l.orderkey
WHERE o.orderkey IN (
  SELECT orderkey
  FROM iceberg.bench_parquet_gzip.lineitem
  GROUP BY orderkey
  HAVING sum(quantity) > 300
)
GROUP BY c.name, c.custkey, o.orderkey, o.orderdate, o.totalprice
ORDER BY o.totalprice DESC, o.orderdate
LIMIT 100;

-- ORC / ZSTD
SELECT
  c.name,
  c.custkey,
  o.orderkey,
  o.orderdate,
  o.totalprice,
  sum(l.quantity) AS total_quantity
FROM iceberg.bench_orc_zstd.customer AS c
JOIN iceberg.bench_orc_zstd.orders AS o ON c.custkey = o.custkey
JOIN iceberg.bench_orc_zstd.lineitem AS l ON o.orderkey = l.orderkey
WHERE o.orderkey IN (
  SELECT orderkey
  FROM iceberg.bench_orc_zstd.lineitem
  GROUP BY orderkey
  HAVING sum(quantity) > 300
)
GROUP BY c.name, c.custkey, o.orderkey, o.orderdate, o.totalprice
ORDER BY o.totalprice DESC, o.orderdate
LIMIT 100;

-- ORC / GZIP
SELECT
  c.name,
  c.custkey,
  o.orderkey,
  o.orderdate,
  o.totalprice,
  sum(l.quantity) AS total_quantity
FROM iceberg.bench_orc_gzip.customer AS c
JOIN iceberg.bench_orc_gzip.orders AS o ON c.custkey = o.custkey
JOIN iceberg.bench_orc_gzip.lineitem AS l ON o.orderkey = l.orderkey
WHERE o.orderkey IN (
  SELECT orderkey
  FROM iceberg.bench_orc_gzip.lineitem
  GROUP BY orderkey
  HAVING sum(quantity) > 300
)
GROUP BY c.name, c.custkey, o.orderkey, o.orderdate, o.totalprice
ORDER BY o.totalprice DESC, o.orderdate
LIMIT 100;
