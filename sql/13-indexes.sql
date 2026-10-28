-- ============================================================================
-- Chapter 13: Indexes — B-tree, unique, composite, partial, covering
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/13-indexes.sql

CREATE INDEX idx_orders_customer ON orders (customer_id);
CREATE INDEX idx_orders_tenant_created ON orders (tenant_id, created_at);
CREATE INDEX idx_products_tenant_name ON products (tenant_id, name);
CREATE INDEX idx_products_stock ON products (stock) WHERE stock > 0;
CREATE INDEX idx_orders_customer_status_amount ON orders (customer_id, status) INCLUDE (amount);

\d+ orders
\d products
\d customers
