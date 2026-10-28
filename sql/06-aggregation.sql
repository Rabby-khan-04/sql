-- ============================================================================
-- Chapter 6: Aggregation — COUNT, SUM, AVG, GROUP BY, HAVING
-- ============================================================================
SELECT tenant_id, COUNT(*) AS customers_per_tenant
FROM customers
GROUP BY tenant_id;

SELECT tenant_id, COUNT(*) AS n
FROM customers
GROUP BY tenant_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS customers,
       MAX(created_at) AS latest,
       MIN(created_at) AS earliest
FROM customers;

SELECT COUNT(*) AS customers,
       SUM(LENGTH(full_name)) AS total_name_chars,
       AVG(LENGTH(full_name)) AS avg_name_len
FROM customers;
