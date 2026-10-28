-- ============================================================================
-- Chapter 20: Real-world pattern — place an order safely in one transaction
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/20-real-world-order.sql

BEGIN;

INSERT INTO orders (tenant_id, customer_id, status) VALUES ('11111111-1111-1111-1111-111111111111', '546592e4-5a3b-4d06-a3c5-aabbfcfe848d', 'pending');
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.id, p.id, 1, p.price
FROM orders o
JOIN products p ON p.tenant_id = o.tenant_id
WHERE o.status = 'pending';

UPDATE products
SET stock = stock - 1
WHERE id = (SELECT id FROM products WHERE name = 'Acme Racer Bike');

COMMIT;

SELECT id, customer_id, status FROM orders ORDER BY created_at DESC LIMIT 2;
SELECT * FROM order_items;
SELECT name, stock FROM products;
