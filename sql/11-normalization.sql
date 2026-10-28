-- ============================================================================
-- Chapter 11: Design — Snapshot pattern
-- ============================================================================
CREATE TABLE order_items_snapshot (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(10,2) NOT NULL,
    product_name TEXT NOT NULL,
    CONSTRAINT fk_osi_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

INSERT INTO order_items_snapshot (order_id, product_id, quantity, unit_price, product_name)
SELECT oi.order_id, oi.product_id, oi.quantity, oi.unit_price, p.name
FROM order_items oi
JOIN products p ON p.id = oi.product_id;

SELECT * FROM order_items_snapshot LIMIT 3;