-- ============================================================================
-- Chapter 10: Foreign Keys — ON DELETE / ON UPDATE actions, danger demo
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/10-foreign-key-actions.sql

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE order_items ADD CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;
ALTER TABLE payments ADD CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;

INSERT INTO payments (order_id, amount, status) VALUES ('f4d57e8e-0679-45fe-9ab3-0c78bbb65428', 499.99, 'paid');

SELECT count(*) AS items_for_order FROM order_items WHERE order_id = 'f4d57e8e-0679-45fe-9ab3-0c78bbb65428';
SELECT count(*) AS payments_for_order FROM payments WHERE order_id = 'f4d57e8e-0679-45fe-9ab3-0c78bbb65428';

-- DANGER ZONE: deleting an order now cascades to order_items and payments
DELETE FROM orders WHERE id = 'f4d57e8e-0679-45fe-9ab3-0c78bbb65428';

SELECT 'orders' AS what, count(*) AS n FROM orders
UNION ALL
SELECT 'payments', count(*) FROM payments
UNION ALL
SELECT 'order_items', count(*) FROM order_items;
