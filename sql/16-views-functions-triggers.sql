-- ============================================================================
-- Chapter 16: Views, Materialized Views, Functions, Triggers
-- ============================================================================
-- View
CREATE VIEW order_customer_summary AS SELECT o.id AS order_id, c.full_name, c.email, o.status FROM orders o JOIN customers c ON o.customer_id = c.id;
SELECT * FROM order_customer_summary;

-- Materialized view
CREATE MATERIALIZED VIEW mv_product_stock AS SELECT tenant_id, name, price, stock FROM products;
SELECT * FROM mv_product_stock;
REFRESH MATERIALIZED VIEW mv_product_stock;

-- Function
CREATE FUNCTION customer_count() RETURNS INT AS $$ SELECT COUNT(*) FROM customers $$ LANGUAGE SQL;
SELECT customer_count();

-- Trigger (setup then teardown)
CREATE TABLE log_demo (id INT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE log_demo_audit (id INT, value TEXT, deleted_at TIMESTAMPTZ DEFAULT now());
CREATE OR REPLACE FUNCTION log_demo_audit_fn() RETURNS TRIGGER LANGUAGE plpgsql AS $$ BEGIN RETURN NEW; END $$;
CREATE TRIGGER trg_demo BEFORE DELETE ON log_demo FOR EACH ROW EXECUTE FUNCTION log_demo_audit_fn();
INSERT INTO log_demo VALUES (1, 'hello');
DELETE FROM log_demo;
DROP TRIGGER trg_demo ON log_demo;
DROP TABLE log_demo;
DROP TABLE log_demo_audit;
DROP FUNCTION log_demo_audit_fn();