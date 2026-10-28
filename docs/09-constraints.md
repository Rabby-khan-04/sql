# Chapter 9 — Constraints: PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

Constraints are **rules** the database enforces. Like a form that refuses to save if fields are empty or wrong.

## 2. Real name

- `PRIMARY KEY` (p), `FOREIGN KEY` (f), `UNIQUE` (u), `NOT NULL` (not null), `CHECK` (c), `DEFAULT` (d), **composite key** (several columns together form a key).

## 3. SQL example

Already seen in earlier chapters (summary):

```sql
CREATE TABLE customers (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    email      TEXT NOT NULL,
    full_name  TEXT NOT NULL,
    notes      TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

New demos:

```sql
ALTER TABLE customers ADD CONSTRAINT uq_customers_tenant_email UNIQUE (tenant_id, email);
ALTER TABLE orders ADD CONSTRAINT orders_status_check CHECK (status IN ('pending','paid','shipped','delivered','cancelled'));
ALTER TABLE orders ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(id);
```

**Outputs:**

```
ALTER TABLE
ALTER TABLE
ERROR:  insert or update on table "orders" violates foreign key constraint "fk_orders_customer"
DETAIL:  Key (customer_id)=(99999999-9999-9999-9999-999999999999) is not present in table "customers".
```

## 4. Why this matters in a real e-commerce platform

App code can have bugs; database constraints cannot be bypassed accidentally (well, superuser can). Unique on (tenant_id, email) = "same customer email allowed in different shops".

## 5. When to use it and when NOT to

Use constraints liberally; but don't put business logic (e.g., "email must be lowercase") in CHECK if avoidable.

## 6. Common mistakes

- `UNIQUE (email)` globally on multi-tenant → cross-tenant clashes. Should be `(tenant_id, email)`.
- Forgetting that FK does not exist yet during early inserts.

## 7. Try it yourself

**Exercise:** Try to insert a duplicate customer for the same tenant — expect an error.

```sql
INSERT INTO customers (tenant_id, email, full_name) VALUES ('11111111-1111-1111-1111-111111111111', 'alice@acme.example', 'Duplicate Alice');
```

<details>
<summary>✅ Solution (click to open)</summary>

The insert fails — that's the constraint protecting you. (Error output shown above.)

</details>

## 8. Next

➡️ **[Chapter 10 — Foreign Keys: ON DELETE / ON UPDATE actions](10-foreign-key-actions.md)**
