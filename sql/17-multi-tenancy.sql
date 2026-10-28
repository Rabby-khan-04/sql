-- ============================================================================
-- Chapter 17: Multi-tenancy — tenant_id, composite indexes/unique/FKs, RLS
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/17-multi-tenancy.sql

-- Composite unique: same customer email allowed in DIFFERENT tenants, but only once per tenant
ALTER TABLE customers ADD CONSTRAINT uq_customers_tenant_id UNIQUE (tenant_id, id);

-- Composite foreign key: an order's (tenant_id, customer_id) must match a real customer in that tenant
ALTER TABLE orders ADD CONSTRAINT fk_orders_tenant_customer FOREIGN KEY (tenant_id, customer_id) REFERENCES customers (tenant_id, id);

-- Cross-tenant link attempt: Globex order pointing at Acme's customer -> should FAIL
INSERT INTO orders (tenant_id, customer_id, status) VALUES ('22222222-2222-2222-2222-222222222222', '546592e4-5a3b-4d06-a3c5-aabbfcfe848d', 'pending');

-- Row-Level Security: only rows for the current app tenant are visible
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
CREATE POLICY customers_tenant_isolation ON customers USING (tenant_id = current_setting('app.tenant_id')::uuid);
SET app.tenant_id = '11111111-1111-1111-1111-111111111111';
SELECT email, full_name FROM customers;
RESET app.tenant_id;
