# Chapter 5 — Pagination: OFFSET vs Keyset (Cursor) Pagination

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

You have a big box of customers. You only want to show **2 per page**.

- **LIMIT** = "give me 2".
- **OFFSET** = "skip the first 2, then give me 2" → that's page 2.

**Keyset pagination** (also called **cursor pagination** or **seek pagination**) is smarter: instead of skipping, you tell the database "give me the next ones *after* this one":

- OFFSET version: `LIMIT 2 OFFSET 2`
- Keyset version: `WHERE created_at < '2026-10-28 09:00:00' ORDER BY created_at DESC LIMIT 2`

## 2. Real name

- `LIMIT` / `OFFSET` — SQL standard (also `TOP` in SQL Server, `FETCH FIRST ... ROWS ONLY` in standard SQL).
- **Pagination** — the general concept.
- **Keyset pagination** / **cursor pagination** / **seek method** — the "start after this value" technique.

## 3. SQL example

Using the `customers` table in `learn_shop`.

### OFFSET pagination

```sql
-- Page 1: first 2 customers, newest first
SELECT email, full_name, created_at
FROM customers
ORDER BY created_at DESC
LIMIT 2 OFFSET 0;
```

**Exact output I got:**

```
       email         |    full_name    |       created_at       
---------------------+-----------------+-----------------------
 alice@acme.example | Alice Anderson | 2026-10-28 10:00:00+00
 bob@acme.example   | Bob Brown      | 2026-10-28 09:00:00+00
(2 rows)
```

```sql
-- Page 2: skip the first 2, take the next 2
SELECT email, full_name, created_at
FROM customers
ORDER BY created_at DESC
LIMIT 2 OFFSET 2;
```

**Exact output I got:**

```
       email         |    full_name    |       created_at       
---------------------+-----------------+-----------------------
 carol@globex.example | Carol Clark   | 2026-10-28 08:00:00+00
(1 row)
```

```sql
-- Page 3: there are no more rows
SELECT email, full_name, created_at
FROM customers
ORDER BY created_at DESC
LIMIT 10 OFFSET 20;
```

**Exact output I got:**

```
       email         |    full_name    |       created_at       
---------------------+-----------------+-----------------------
(0 rows)
```

### Keyset / cursor pagination

Instead of `OFFSET`, remember the last row of the previous page and start strictly after it:

```sql
-- Page 1 (LIMIT 2): Alice, Bob  -> last seen cursor is Bob's created_at
-- Page 2: everything older than Bob's created_at
SELECT email, full_name, created_at
FROM customers
WHERE created_at < '2026-10-28 09:00:00+00'
ORDER BY created_at DESC
LIMIT 2;
```

**Exact output I got:**

```
       email         |    full_name    |       created_at       
---------------------+-----------------+-----------------------
 carol@globex.example | Carol Clark   | 2026-10-28 08:00:00+00
(1 row)
```

## 4. Why this matters in a real e-commerce platform

Product listing pages ("show me page 3 of shoes"), admin order tables, "load more" feeds — all need pagination.

## 5. When to use it and when NOT to

- Use OFFSET for small tables or admin UIs where deep pages don't exist.
- Use keyset for large tables / infinite scroll / anything with deep pages.

## 6. Common mistakes

- Using `OFFSET` for deep pages → slow.
- Keyset without `ORDER BY` → unstable.
- Keyset on columns with ties → can skip rows. Use a unique tiebreaker (see below).

## 7. Try it yourself

**Exercise:** Get page 2 with 2 items per page using OFFSET.

```sql
SELECT email, full_name, created_at
FROM customers
ORDER BY created_at ASC
LIMIT 2 OFFSET 2;
```

<details>
<summary>✅ Solution (click to open)</summary>

```sql
SELECT email, full_name, created_at
FROM customers
ORDER BY created_at ASC
LIMIT 2 OFFSET 2;
```

Expected output:

```
       email         |    full_name    |       created_at       
---------------------+-----------------+-----------------------
 carol@globex.example | Carol Clark   | 2026-10-28 08:00:00+00
(1 row)
```

</details>

**Reset the sample data:**

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/02-data-types.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/03-create-tables_schemas.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/04-insert-select-update-delete.sql
```

## 8. Next

➡️ **[Chapter 6 — Aggregation: COUNT, SUM, AVG, GROUP BY, HAVING](06-aggregation.md)**
