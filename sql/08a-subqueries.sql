-- ============================================================================
-- Chapter 8a: Subqueries
-- ============================================================================
SELECT full_name, email
FROM customers
WHERE tenant_id = (SELECT id FROM tenants WHERE name = 'Acme Toys');

SELECT full_name, email
FROM customers
WHERE tenant_id IN (SELECT id FROM tenants);

SELECT c.full_name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);

SELECT full_name, email
FROM customers
WHERE tenant_id IN (SELECT id FROM tenants WHERE name = 'Globex Gifts');
