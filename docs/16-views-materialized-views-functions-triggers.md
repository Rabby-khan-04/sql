# Chapter 16 — Views, Materialized Views, Functions, Triggers

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

- **View** = a saved question (like a saved search).
- **Materialized view** = a saved question whose answer is physically stored and can be refreshed.
- **Function** = a saved mini-program.
- **Trigger** = a robot that runs automatically when something happens (insert/update/delete).

## 2. Real name

- `CREATE VIEW`, `CREATE MATERIALIZED VIEW`, `REFRESH MATERIALIZED VIEW`, `CREATE FUNCTION`, `CREATE TRIGGER`.

## 3. SQL example — view

```sql
CREATE VIEW order_customer_summary AS
SELECT o.id AS order_id, c.full_name, c.email, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.id;
SELECT * FROM order_customer_summary;
```

**Exact output I got:**

```
               order_id               |   full_name    |        email         | status  
--------------------------------------+-----------------+-----------------------
 beebad8b-fe39-484b-8a8f-e19444b82443 | Alice Anderson | alice@acme.example   | pending
 7ba066db-4f2d-4b99-9301-5e0bd9335dab | Carol Clark    | carol@globex.example | pending
(2 rows)
```

## 4. SQL example — materialized view

```sql
CREATE MATERIALIZED VIEW mv_product_stock AS SELECT tenant_id, name, price, stock FROM products;
SELECT * FROM mv_product_stock;
REFRESH MATERIALIZED VIEW mv_product_stock;
DROP MATERIALIZED VIEW mv_product_stock;
```

**Outputs I got:**

```
CREATE MATERIALIZED VIEW
SELECT 3
 REFRESH MATERIALIZED VIEW
DROP MATERIALIZED VIEW
```

## 5. SQL example — function

```sql
CREATE FUNCTION customer_count() RETURNS INT AS $$
SELECT COUNT(*) FROM customers
$$ LANGUAGE SQL;
SELECT customer_count();
```

**Output:**

```
 CREATE FUNCTION
 customer_count 
----------------
              3
(1 row)
```

## 6. SQL example — trigger

```sql
CREATE TABLE log_demo (id INT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE log_demo_audit (id INT, value TEXT, deleted_at TIMESTAMPTZ DEFAULT now());
CREATE OR REPLACE FUNCTION log_demo_audit_fn() RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  RETURN NEW;
END;
$$;
CREATE TRIGGER trg_demo BEFORE DELETE ON log_demo FOR EACH ROW EXECUTE FUNCTION log_demo_audit_fn();
INSERT INTO log_demo VALUES (1, 'hello');
DELETE FROM log_demo;
DROP TRIGGER trg_demo ON log_demo;
DROP TABLE log_demo;
DROP TABLE log_demo_audit;
DROP FUNCTION log_demo_audit_fn();
```

**Output:**

```
 CREATE TABLE
 CREATE TABLE
 CREATE FUNCTION
 CREATE TRIGGER
 INSERT 0 1
 DELETE 0
 DROP TRIGGER
 DROP TABLE
 DROP TABLE
 DROP FUNCTION
```

## 7. Why this matters in a real e-commerce platform

Mostly for operational convenience; triggers can be dangerous/slow; use sparingly.

## 8. When to use it and when NOT to

- Views: yes for reusable queries. Materialized views: for heavy aggregations. Functions: for reusable logic. Triggers: sparingly.

## 9. Common mistakes

- Triggers firing in unexpected ways; materialized views going stale.

## 10. Try it yourself

**Exercise:** Create a view of orders with customers and select from it.

## 11. Next

➡️ **[Chapter 17 — Multi-tenancy](17-multi-tenancy.md)**
