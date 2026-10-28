# Chapter 18 — Migrations: Versioned Schema Changes

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

When your app changes its database shape, you write a **migration** — a saved, versioned change — instead of just running `ALTER TABLE` by hand.

## 2. Real name

- Migration, `ALTER TABLE`, `ADD COLUMN`, **backfill**, `CREATE INDEX CONCURRENTLY`, long locks.

## 3. SQL example

```sql
ALTER TABLE customers ADD COLUMN phone TEXT;
UPDATE customers SET phone = 'unknown' WHERE phone IS NULL;
CREATE INDEX CONCURRENTLY idx_customers_tenant_email ON customers (tenant_id, email);
```

**Outputs I got:**

```
ALTER TABLE
UPDATE 3
CREATE INDEX
```

`CREATE INDEX CONCURRENTLY` cannot run inside a transaction block:

```sql
BEGIN;
CREATE INDEX CONCURRENTLY idx_customers_tenant_email ON customers (tenant_id, email);
COMMIT;
```

**Output I got:**

```
ERROR:  CREATE INDEX CONCURRENTLY cannot run inside a transaction block
```

## 4. Why this matters in a real e-commerce platform

Zero-downtime deploys: adding an index with `CONCURRENTLY` doesn't lock the table.

## 5. When to use it and when NOT to

Use migrations for every schema change in production.

## 6. Common mistakes

- Running `CREATE INDEX` (non-concurrent) on a big live table → long lock.

## 7. Try it yourself

**Exercise:** Add a column and backfill it.

## 8. Next

➡️ **[Chapter 19 — Security and Operations](19-security-operations.md)**
