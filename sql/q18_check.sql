WITH reference AS (
    SELECT
        c.name,
        c.custkey,
        o.orderkey,
        o.orderdate,
        o.totalprice,
        sum(l.quantity) AS total_quantity
    FROM tpch.sf1.customer AS c
    JOIN tpch.sf1.orders AS o ON c.custkey = o.custkey
    JOIN tpch.sf1.lineitem AS l ON o.orderkey = l.orderkey
    WHERE o.orderkey IN (
        SELECT orderkey
        FROM tpch.sf1.lineitem
        GROUP BY orderkey
        HAVING sum(quantity) > 300
    )
    GROUP BY c.name, c.custkey, o.orderkey, o.orderdate, o.totalprice
    ORDER BY o.totalprice DESC, o.orderdate
    LIMIT 100
),
gold AS (
    SELECT name, custkey, orderkey, orderdate, totalprice, total_quantity
    FROM iceberg.gold.q18_top100
)
SELECT
    (SELECT count(*) FROM reference) AS reference_rows,
    (SELECT count(*) FROM gold) AS gold_rows,
    (SELECT count(*) FROM (SELECT * FROM reference EXCEPT SELECT * FROM gold)) AS missing_in_gold,
    (SELECT count(*) FROM (SELECT * FROM gold EXCEPT SELECT * FROM reference)) AS extra_in_gold;
