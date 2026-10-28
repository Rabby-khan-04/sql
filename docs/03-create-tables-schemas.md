# Chapter 3 — CREATE / ALTER / DROP TABLE, and Schemas

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

Three magic words to make, change, or remove tables:

- **CREATE TABLE** → "Make a new table." Like adding a new spreadsheet tab.
- **ALTER TABLE** → "Change an existing table." Like adding a new column to a spreadsheet tab.
- **DROP TABLE** → "Delete a table forever." Like throwing the whole spreadsheet tab away.

And a **schema** is like a folder inside the filing cabinet that groups related tables together (e.g., a folder called `shop` for all the e-commerce tables).

## 2. Real name

These belong to **DDL** — **Data Definition Language** — the part of SQL that defines the shape of the data. The real terms:

- `CREATE TABLE` → create a new table (relation).
- `ALTER TABLE` → modify an existing table (add/remove column/constraint).
- `DROP TABLE` → delete a table.
- `CREATE SCHEMA` → create a new schema/folder.

## 3. SQL example

We use the `customers` table of the `learn_shop` e-commerce schema.

```sql
CREATE TABLE customers (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    email      TEXT NOT NULL,
    full_name  TEXT NOT NULL,
    notes      TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO customers (tenant_id, email, full_name, notes) VALUES
    ('11111111-1111-1111-1111-111111111111', 'alice@acme.example',  'Alice Anderson',  'VIP'),
    ('11111111-1111-1111-1111-111111111111', 'bob@acme.example',    'Bob Brown',       NULL),
    ('22222222-2222-2222-2222-222222222222', 'carol@globex.example','Carol Clark',    'Prefers email');

SELECT email, full_name, notes FROM customers ORDER BY email;
```

**Exact output I got** (PostgreSQL 17.11):

```
CREATE TABLE
INSERT 0 3
        email         |   full_name    |     notes     
----------------------+----------------+---------------
 alice@acme.example   | Alice Anderson | VIP
 bob@acme.example     | Bob Brown      | 
 carol@globex.example | Carol Clark    | Prefers email
(3 rows)
```

### ALTER TABLE

```sql
ALTER TABLE customers ADD COLUMN phone TEXT;
SELECT full_name, email, notes, phone FROM customers;
```

**Exact output I got:**

```
ALTER TABLE
   full_name    |        email         |     notes     | phone 
----------------+-----------------------+---------------+-------
 Alice Anderson | alice@acme.example   | VIP           | 
 Bob Brown      | bob@acme.example     |               | 
 Carol Clark    | carol@globex.example | Prefers email | 
(3 rows)
```

### DROP TABLE (DANGER ZONE — throwaway DB only)

```sql
DROP TABLE customers;
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
```

**Exact output I got:**

```
DROP TABLE
  tablename 
-----------
 tenants
(1 row)
```

### Schemas

A schema is a namespace/folder. Tables can live in schemas, written as `schema_name.table_name`.

```sql
CREATE SCHEMA IF NOT EXISTS shop;
CREATE TABLE shop.demo_things (id INT PRIMARY KEY, label TEXT NOT NULL);
INSERT INTO shop.demo_things VALUES (1, 'hello');
SELECT * FROM shop.demo_things;
```

**Exact output I got:**

```
CREATE SCHEMA
CREATE TABLE
INSERT 0 1
 id | label 
----+------
  1 | hello
(1 row)
```

Then it was cleaned up with `DROP SCHEMA shop CASCADE;`.

## 4. Why this matters in a real e-commerce platform

In Prisma, creating tables is done through **migrations**: `prisma migrate dev` generates `CREATE TABLE` statements from your `schema.prisma` models and stores them in versioned migration files. When you later change a model, Prisma generates an `ALTER TABLE` migration. Understanding `CREATE`/`ALTER`/`DROP` means you understand what Prisma migrations do behind the scenes.

## 5. When to use it and when NOT to

- Use `CREATE TABLE` for every new entity (orders, payments...).
- Use `ALTER TABLE` for evolving tables — but prefer **migrations** in production (Chapter 19).
- Don't create tables ad hoc in production code.

## 6. Common mistakes

- `DROP TABLE` without thinking — in production it deletes real data (we did it here on the throwaway DB; Chapter 10/roadmap show the CASCADE danger).
- Using `IF EXISTS` / `IF NOT EXISTS` to hide errors — in production you often *want* the error.

## 7. Try it yourself

**Exercise:** Add a `phone` column to `customers` and look at it.

```sql
ALTER TABLE customers ADD COLUMN phone TEXT;
SELECT full_name, phone FROM customers;
```

<details>
<summary>✅ Solution (click to open)</summary>

```sql
ALTER TABLE customers ADD COLUMN phone TEXT;
SELECT full_name, email, notes, phone FROM customers;
```

**Expected output:**

```
   full_name    |        email         |     notes     | phone 
----------------+-----------------------+---------------+-------
 Alice Anderson | alice@acme.example   | VIP           | 
 Bob Brown      | bob@acme.example     |               | 
 Carol Clark    | carol@globex.example | Prefers email | 
(3 rows)
```

</details>

**Reset the sample data:**

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/02-data-types.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/03-create-tables-schemas.sql
```

> Note: `sql/03-...` now also demonstrates `ALTER` and `DROP`, so running it after a reset will end with only the `tenants` table. To get the full e-commerce sample state, run chapters 02 → 03 (create part) → 04.

## 8. Next

➡️ **[Chapter 4 — Working with Data: INSERT, SELECT, UPDATE, DELETE, WHERE, ORDER BY, LIMIT, DISTINCT, NULL, LIKE](04-insert-select-update-delete.md)**
