-- ============================================================================
-- Chapter 8b: CTEs, set operations, window functions
-- ============================================================================
WITH acme_customers AS (
    SELECT full_name, email
    FROM customers
    WHERE tenant_id = '11111111-1111-1111-1111-111111111111'
)
SELECT * FROM acme_customers;

SELECT name AS name FROM tenants
UNION
SELECT full_name AS name FROM customers;

SELECT tenant_id FROM customers
INTERSECT
SELECT tenant_id FROM orders;

SELECT tenant_id FROM orders
EXCEPT
SELECT tenant_id FROM customers;

SELECT full_name, ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rn
FROM customers;

SELECT full_name, SUM(LENGTH(full_name)) OVER (ORDER BY created_at DESC) AS running_total
FROM customers;

SELECT name, price, RANK() OVER (ORDER BY price DESC) AS rnk
FROM products
ORDER BY price DESC;
