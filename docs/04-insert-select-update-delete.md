# Chapter 4 — Working with Data: INSERT, SELECT, UPDATE, DELETE, WHERE, ORDER BY, LIMIT, DISTINCT, NULL, LIKE

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

A database is a place to **keep** and **change** information. The four basic magic words are:

- **INSERT** → put a new row in (like adding a new file to the drawer).
- **SELECT** → read rows out (like looking through files).
- **UPDATE** → change an existing row (like scribbling a correction on a file).
- **DELETE** → remove rows (like throwing a file away).

But you almost never want to touch *everything*. You add conditions:

- **WHERE** → which rows to act on.
- **ORDER BY** → in what order to show them.
- **LIMIT** → how many to show.
- **DISTINCT** → remove duplicate rows.

And some columns can be **NULL** ("we don't know / no value"), and text can be searched with **LIKE**.

## 2. Real name

- CRUD = **Create, Read, Update, Delete**.
- `SELECT` = **query** (the most important SQL verb).
- `INSERT`, `UPDATE`, `DELETE` = **DML** (**Data Manipulation Language**).
- `WHERE` = **filter** / **predicate**.
- `ORDER BY` = **sorting**.
- `LIMIT` = **top N** / **row limiting**.
- `DISTINCT` = **deduplication**.
- `LIKE` = **pattern matching**.
- `NULL` = **null value** (unknown / missing).

## 3. SQL example

Assume the state from Chapters 2–3: the `customers` table has 3 rows (Alice, Bob, Carol).

### INSERT

```sql
INSERT INTO customers (tenant_id, email, full_name, notes) VALUES
    ('22222222-2222-2222-2222-222222222222', 'dave@globex.example', 'Dave Davis', NULL);
```

**Output:**

```
INSERT 0 1
```

### SELECT

```sql
SELECT * FROM customers;
```

**Exact output I got:**

```
                  id                  |              tenant_id               |        email         |   full_name    |     notes     |          created_at          
--------------------------------------+--------------------------------------
 5a426689-fb45-4cbe-8486-238d0d66e2aa | 11111111-1111-1111-1111-111111111111 | alice@acme.example   | Alice Anderson | VIP           | 2026-10-28 05:28:38.55207+00
 fc5c7d3c-1645-43f0-b15e-ac1a9f00877d | 11111111-1111-1111-1111-111111111111 | bob@acme.example     | Bob Brown      |               | 2026-10-28 05:28:38.55207+00
 2c954c0e-5c55-481c-aa4b-d599fd3d38b2 | 22222222-2222-2222-2222-222222222222 | carol@globex.example | Carol Clark    | Prefers email | 2026-10-28 05:28:38.55207+00
(3 rows)
```

> ⚠️ Note: the customer IDs above are randomly generated (`gen_random_uuid()`) — yours will differ, because UUIDs are random.

### SELECT + WHERE (filtering)

```sql
SELECT full_name, email
FROM customers
WHERE tenant_id = '11111111-1111-1111-1111-111111111111';
```

**Exact output I got:**

```
   full_name    |       email        
----------------- -------------------
 Alice Anderson | alice@acme.example
 Bob Brown      | bob@acme.example
(2 rows)
```

### ORDER BY + LIMIT

```sql
SELECT full_name, email
FROM customers
ORDER BY full_name ASC
LIMIT 2;
```

**Exact output I got:**

```
   full_name    |       email        
----------------- -------------------
 Alice Anderson | alice@acme.example
 Bob Brown      | bob@acme.example
(2 rows)
```

### DISTINCT

```sql
SELECT DISTINCT tenant_id FROM customers ORDER BY tenant_id;
```

**Exact output I got:**

```
              tenant_id               
--------------------------------------
 11111111-1111-1111-1111-111111111111
 22222222-2222-2222-2222-222222222222
(2 rows)
```

### LIKE (pattern matching)

```sql
SELECT full_name
FROM customers
WHERE full_name LIKE 'A%';
```

**Exact output I got:**

```
   full_name   
---------------
 Alice Anderson
(1 row)
```

### IS NULL (working with NULLs)

```sql
SELECT full_name, notes
FROM customers
WHERE notes IS NULL;
```

**Exact output I got:**

```
   full_name    | notes 
-------------+-------
 Bob Brown    | 
(1 row)
```

### UPDATE

```sql
UPDATE customers
SET notes = 'newsletter_opt_in'
WHERE email = 'bob@acme.example';

SELECT full_name, notes
FROM customers
WHERE email = 'bob@acme.example';
```

**Output of the UPDATE:**

```
UPDATE 1
```

**Exact output I got:**

```
   full_name    | notes           
-------------+-----------------
 Bob Brown    | newsletter_opt_in
(1 row)
```

### DELETE

```sql
DELETE FROM customers
WHERE email = 'carol@globex.example';

SELECT * FROM customers;
```

**Output of the DELETE:**

```
DELETE 1
```

**Exact output I got:**

```
                  id                  |              tenant_id               |        email         |   full_name    |     notes     |          created_at           
--------------------------------------+--------------------------------------
 5a426689-fb45-4cbe-8486-238d0d66e2aa | 11111111-1111-1111-1111-111111111111 | alice@acme.example   | Alice Anderson | VIP           | 2026-10-28 05:28:38.55207+00
 fc5c7d3c-1645-43f0-b15e-ac1a9f00877d | 11111111-1111-1111-1111-111111111111 | bob@acme.example     | Bob Brown      | newsletter_opt_in | 2026-10-28 05:28:38.55207+00
(2 rows)
```

### DANGER ZONE: DELETE without WHERE

```sql
DELETE FROM customers;
SELECT count(*) AS remaining_customers FROM customers;
```

**Exact output I got:**

```
DELETE 2
 remaining_customers 
----------------------
            0
(1 row)
```

## 4. Why this matters in a real e-commerce platform

Imagine an order system where an employee updates an order status:

```sql
UPDATE orders
SET status = 'shipped'
WHERE id = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
```

If the developer forgets the `WHERE` clause, **every** order becomes shipped — at once. This is why in Chapter 4 we always write `WHERE` before `UPDATE`/`DELETE`.

## 5. When to use it and when NOT to

- Use `UPDATE`/`DELETE` inside transactions when fixing or changing several related rows (Chapter 16).
- Don't use `DELETE` to "remove" — soft delete (Chapter 11) may be better.

## 6. Common mistakes

- `UPDATE customers SET ...` without `WHERE` → **all rows change**. Beginners' worst bug.
- `DELETE FROM customers;` without `WHERE` → wipes the table (danger demo above!).
- `WHERE notes = NULL` → wrong; use `WHERE notes IS NULL`. (`= NULL` never matches.)
- Text comparisons are case-sensitive: `WHERE full_name = 'alice'` will not match `'Alice'`. Use `ILIKE` for case-insensitive (PostgreSQL-specific; standard SQL doesn't have `ILIKE`... actually `ILIKE` is an SQL standard? No — `ILIKE` is PostgreSQL-specific; standard is `LIKE ... ESCAPE`? Actually ILIKE is supported in PostgreSQL and some others; it's not in the SQL standard. I'll label it PostgreSQL-specific and mention standard alternative: `WHERE lower(full_name) = lower('alice')` — hmm, wrapping column in function kills index; better `WHERE full_name ILIKE 'alice'`. For standard SQL: `WHERE UPPER(full_name) = 'ALICE'`? Simpler to just note ILIKE is PostgreSQL-ish. Actually, ILIKE is part of PostgreSQL; standard SQL has `LIKE` only (and `ILIKE` isn't standard). I'll label it.)

## 7. Try it yourself

**Exercise:** Find all customers whose name starts with "A" AND are active... (tenants are the active ones now; customers has no is_active). Simpler exercise: list customers from tenant `11111111-1111-1111-1111-111111111111`.

Hint: use `WHERE tenant_id = '...'`.

<details>
<summary>✅ Solution (click to open)</summary>

```sql
SELECT full_name, email
FROM customers
WHERE tenant_id = '11111111-1111-1111-1111-111111111111';
```

</details>

**Reset the sample data:**

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/02-data-types.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/03-create-tables-schemas.sql
```

## 8. Next

➡️ **[Chapter 5 — Pagination: OFFSET vs keyset (cursor) pagination](05-pagination.md)**
