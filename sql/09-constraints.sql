-- ============================================================================
-- Chapter 9: Constraints — UNIQUE, CHECK, FOREIGN KEY
-- ============================================================================
ALTER TABLE customers ADD CONSTRAINT uq_customers_tenant_email UNIQUE (tenant_id, email);
ALTER TABLE orders ADD CONSTRAINT orders_status_check CHECK (status IN ('pending','paid','shipped','delivered','cancelled'));
ALTER TABLE orders ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(id);
ALTER TABLE customers ADD CONSTRAINT uq_customers_tenant_id UNIQUE (tenant_id, id);
ALTER TABLE orders ADD CONSTRAINT fk_orders_tenant_customer FOREIGN KEY (tenant_id, customer_id) REFERENCES customers (tenant_id, id);
