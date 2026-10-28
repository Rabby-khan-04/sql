# Chapter 17 — Multi-tenancy: tenant_id, Composite Keys, RLS

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

If your app sells to many shops ("tenants") at once, every table gets a `tenant_id` so rows from different shops never mix.

- Same shop → same tenant_id.
- Different shop → different tenant_id.

## 2. Real name

- `tenant_id`, **composite index**, **composite unique constraint**, **composite foreign key**, **Row-Level Security (RLS)**.

## 3. SQL example — composite unique (unique per tenant, not globally)

```sql
ALTER TABLE customers ADD CONSTRAINT uq_customers_tenant_email UNIQUE (tenant_id, email);
```

**Output I got:**

```
ALTER TABLE
```

A duplicate (tenant + email) is then rejected:

```
ERROR:  duplicate key value violates unique constraint "uq_customers_tenant_email"
DETAIL:  Key (tenant_id, email)=(11111111-1111-1111-1111-111111111111, alice@acme.example) already exists.
```

## 4. SQL example — composite foreign key prevents cross-tenant links

```sql
ALTER TABLE orders ADD CONSTRAINT fk_orders_tenant_customer FOREIGN KEY (tenant_id, customer_id) REFERENCES customers (tenant_id, id);
```

**Output I got:**

```
ALTER TABLE
```

Then a Globex order pointing at an Acme customer is rejected:

```
ERROR:  insert or update on table "orders" violates foreign key constraint "fk_orders_tenant_customer"
DETAIL:  Key (tenant_id, customer_id)=(22222222-2222-2222-2222-222222222222, 546592e4-5a3b-4d06-a3c5-aabbfcfe848d) is not present in table "customers".
```

## 5. SQL example — composite index

```sql
CREATE INDEX idx_orders_tenant_created ON orders (tenant_id, created_at);
```

**Output:**

```
CREATE INDEX
```

## 6. SQL example — Row-Level Security (RLS)

```sql
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS customers_tenant_isolation ON customers;
CREATE POLICY customers_tenant_isolation ON customers USING (tenant_id = current_setting('app.tenant_id')::uuid);
ALTER TABLE customers FORCE ROW LEVEL SECURITY;
SET app.tenant_id = '11111111-1111-1111-1111-111111111111';
SELECT email, full_name FROM customers WHERE tenant_id = current_setting('app.tenant_id')::uuid;
RESET app.tenant_id;
SET app.tenant_id = '22222222-2222-2222-2222-222222222222';
SELECT email, full_name FROM customers WHERE tenant_id = current_setting('app.tenant_id')::uuid;
RESET app.tenant_id;
ALTER TABLE customers DISABLE ROW LEVEL SECURITY;
```

**Outputs I got:**

```
ALTER TABLE
DROP POLICY
CREATE POLICY
ALTER TABLE
SET
        email         |    full_name    
----------------------+-----------------
 alice@acme.example | Alice Anderson
 bob@acme.example   | Bob Brown
(2 rows)
RESET
SET
        email         |    full_name  
----------------------+---------------
 carol@globex.example | Carol Clark
(1 row)
RESET
ALTER TABLE
```

## 7. Why this matters in a real e-commerce platform

Without tenant filters, a query for tenant A can read tenant B's orders. App-level + DB-level safety.

## 8. When to use it and when NOT to

- Use tenant_id + composite keys for multi-tenant. RLS as a safety net.

## 9. Common mistakes

- Unique (email) globally → cross-tenant clash. Use (tenant_id, email).
- Forgetting tenant_id in queries.

## 10. Try it yourself

**Exercise:** List customers of tenant 'Globex Gifts' via RLS.

## 11. Next

➡️ **[Chapter 18 — Migrations](18-migrations.md)**
