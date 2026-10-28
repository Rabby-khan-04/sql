# Chapter 2 — Data Types

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

Every column in a table has a **type**, which is just a rule saying what kind of data is allowed in it.

- `TEXT` → words, like a name or an email.
- `INTEGER` → whole numbers, like stock quantity.
- `BOOLEAN` → true or false, like "is this product in stock?".
- `TIMESTAMPTZ` → date **and** time **and** time zone, like "2026-10-28 14:33:00 +02:00".
- `UUID` → a super-long unique ID, like `11111111-1111-1111-1111-111111111111`.
- `NUMERIC` → a very precise number, like money.
- `JSON` → flexible extra info, like a product attribute bag.

The database will **not** allow you to put a word into a number column, and it will not allow you to put `TRUE` into a date column. The type is the rule.

## 2. Real name

The proper term is **data type**. PostgreSQL calls these **SQL data types**, and each one belongs to a **data type category** (text, numeric, boolean, date/time, uuid, json, ...).

| Category | PostgreSQL types | What it means | Prisma equivalent |
|---|---|---|---|
| Text | `TEXT`, `VARCHAR(n)` | variable-length text | `String` |
| Integer | `SMALLINT`, `INTEGER` / `INT`, `BIGINT` | whole numbers | `Int` |
| Boolean | `BOOLEAN` | true / false / NULL | `Boolean` |
| Date/time | `TIMESTAMP`, `TIMESTAMPTZ` (**TIMESTAMP WITH TIME ZONE**) | date + time, with/without zone | `DateTime` |
| Identifier | `UUID`, `TEXT`, `SERIAL`, `IDENTITY` | unique ID | `String` (`@db.Uuid`) or `Int` |
| Money | `NUMERIC(p, s)`, `DECIMAL`, `FLOAT`, `REAL`, `DOUBLE PRECISION` | numbers with precision | `Int` (cents) or `Decimal` |
| Flexible | `JSON`, `JSONB` | nested JSON documents | `Json` |

## 3. SQL example

This is the first sample table of the `learn_shop` e-commerce schema — the `tenants` table — created in this chapter:

```sql
CREATE TABLE tenants (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO tenants (id, name, is_active) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Acme Toys', TRUE),
    ('22222222-2222-2222-2222-222222222222', 'Globex Gifts', TRUE);

SELECT * FROM tenants;
```

**Exact output I got** (PostgreSQL 17.11):

```
CREATE TABLE
INSERT 0 2
                  id                  |     name     | is_active |          created_at          
--------------------------------------+--------------+------------+-------------------------------
 11111111-1111-1111-1111-111111111111 | Acme Toys    | t          | 2026-10-28 05:30:23.804613+00
 22222222-2222-2222-2222-222222222222 | Globex Gifts | t          | 2026-10-28 05:30:23.804613+00
(2 rows)
```

### Line-by-line explanation

- `CREATE TABLE tenants (...)` — creates the table with these columns:
  - `id UUID PRIMARY KEY DEFAULT gen_random_uuid()` — an `UUID` (random unique identifier) that must be unique (`PRIMARY KEY`) and gets a freshly generated value automatically (`DEFAULT gen_random_uuid()`). In PostgreSQL **13 and newer**, `gen_random_uuid()` is built in (before that you needed the `pgcrypto` extension). **PostgreSQL-specific** here; the SQL standard calls it `UUID` generation, and other databases have their own version (e.g., MySQL `UUID()`).
  - `name TEXT NOT NULL` — a text column that must not be empty/null.
  - `is_active BOOLEAN NOT NULL DEFAULT TRUE` — true/false, defaults to true.
  - `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` — date+time with timezone, defaults to right now.
- `INSERT INTO tenants (id, name, is_active) VALUES (...)` — inserts rows; columns we did not list get their defaults.
- `SELECT * FROM tenants;` — `*` means "all columns", a shortcut beginners love and experts sometimes avoid (Chapter 4).

### UUID vs SERIAL / IDENTITY

- **`UUID`** (`uuid` type): a random unique value like `11111111-1111-1111-1111-111111111111`. Great for multi-tenant systems where IDs must never collide across databases. Prisma: `@default(uuid()) @db.Uuid`.
- **`SERIAL`** (or `IDENTITY`): an integer that auto-increments (`1, 2, 3, ...`). Great for simple single-database apps. Prisma: `@default(autoincrement()) @db.Int`.

**PostgreSQL-specific note:** `SERIAL` is actually a `CREATE SEQUENCE` + `DEFAULT nextval(...)` behind the scenes; the SQL standard prefers `GENERATED ... AS IDENTITY`. Both exist in PostgreSQL 17.

### `NUMERIC` vs `FLOAT`

- `NUMERIC(10,2)` / `DECIMAL(10,2)` — exact decimal numbers (e.g., `19.99`). **This is what money should use** (Chapter 13).
- `FLOAT`, `REAL`, `DOUBLE PRECISION` — approximate binary floating point. Rounding surprises ahead (e.g., `0.1 + 0.2 != 0.3` exactly). Never use for money.

## 4. Why this matters in a real e-commerce platform

- The **`orders`** table needs an `order_number` — often a `BIGINT` (for `1, 2, 3...`) or a UUID.
- **`products.price`** should be `NUMERIC(10,2)`, not `FLOAT` — because `FLOAT` gave us rounding errors with money (Chapter 13 will show real examples).
- **`orders.created_at`** should be `TIMESTAMPTZ`, not `TIMESTAMP` without time zone — because orders from customers in different countries must not be confused.

## 5. When to use it and when NOT to

- Use `VARCHAR(n)` when you have a real maximum length (e.g., email ≤ 254 chars); use `TEXT` when length is unbounded.
- Use `UUID` for multi-tenant apps; use `SERIAL` for simple single-database apps.
- Use `NUMERIC` for money; use `FLOAT` only for non-money measurements (and know about rounding).

## 6. Common mistakes

- Using `FLOAT` for prices (rounding errors → angry customers and wrong reports).
- Using `TIMESTAMP` instead of `TIMESTAMPTZ` → times get silently shifted when time zones change.
- Forgetting `NOT NULL` / `DEFAULT` and then being surprised by nulls.

## 7. Try it yourself

**Exercise:** Which tenants are active?

```sql
SELECT name FROM tenants WHERE is_active = TRUE;
```

<details>
<summary>✅ Solution (click to open)</summary>

```sql
SELECT name FROM tenants WHERE is_active = TRUE;
```

**Expected output:**

```
     name
-----------
 Acme Toys
 Globex Gifts
(2 rows)
```
```

</details>

**Reset the sample data:**

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/02-data-types.sql
```

## 8. Next

➡️ **[Chapter 3 — CREATE / ALTER / DROP TABLE, and Schemas](03-create-tables-schemas.md)**
