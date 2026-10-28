# Chapter 6 — Aggregation: COUNT, SUM, AVG, GROUP BY, HAVING

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

When you have many rows and want **one answer**, you use an aggregator:

- **COUNT** → how many rows?
- **SUM** → add numbers together.
- **AVG** → average (mean).
- **GROUP BY** → split into groups and count/sum/average **inside each group**.

**HAVING** is like `WHERE` but for groups — it filters *after* grouping.

## 2. Real name

- `COUNT(*)` / `COUNT(column)` — aggregate function.
- `SUM()`, `AVG()`, `MAX()`, `MIN()` — aggregate functions.
- `GROUP BY` — grouping.
- `HAVING` — aggregate filter (SQL standard; MySQL also allows `HAVING`; Oracle uses `HAVING`; standard SQL uses `HAVING`).

## 3. SQL example

```sql
SELECT tenant_id, COUNT(*) AS customers_per_tenant
FROM customers
GROUP BY tenant_id;
```

**Exact output I got:**

```
              tenant_id               | customers_per_tenant 
--------------------------------------+----------------------
 11111111-1111-1111-1111-111111111111 |                    2
 22222222-2222-2222-2222-222222222222 |                    1
(2 rows)
```

```sql
SELECT tenant_id, COUNT(*) AS n
FROM customers
GROUP BY tenant_id
HAVING COUNT(*) > 1;
```

**Exact output I got:**

```
              tenant_id               | n 
--------------------------------------+---
 11111111-1111-1111-1111-111111111111 |                    2
(1 row)
```

Other aggregates:

```sql
SELECT COUNT(*) AS customers,
       MAX(created_at) AS latest,
       MIN(created_at) AS earliest
FROM customers;

SELECT COUNT(*) AS customers,
       SUM(LENGTH(full_name)) AS total_name_chars,
       AVG(LENGTH(full_name)) AS avg_name_len
FROM customers;
```

**Exact output I got:**

```
 customers |         latest         |        earliest        
-----------+-----------------------+---------------------+
         3 | 2026-10-28 10:00:00+00 | 2026-10-28 08:00:00+00
(1 row)

 customers |         total_name_chars         |         avg_name_len     
----------+---------------------------------+--------------------------
         3 |                               34 |     11.3333333333333333
(1 row)
```

## 4. Why this matters in a real e-commerce platform

"How many orders did tenant X have last month?" → `SELECT tenant_id, COUNT(*) ... GROUP BY tenant_id`.

## 5. When to use it and when NOT to

Use for reporting. Don't use aggregates to fetch lists of rows (use GROUP BY properly).

## 6. Common mistakes

- Forgetting `GROUP BY` when using aggregates → error.
- Using `WHERE` instead of `HAVING` for group filtering.

## 7. Try it yourself

**Exercise:** How many customers does each tenant have? Use HAVING to show only tenants with more than one customer.

<details>
<summary>✅ Solution (click to open)</summary>

```sql
SELECT tenant_id, COUNT(*) AS n
FROM customers
GROUP BY tenant_id
HAVING COUNT(*) > 1;
```

Expected output:

```
              tenant_id               | n 
--------------------------------------+---
 11111111-1111-1111-1111-111111111111 |                    2
(1 row)
```

</details>

**Reset the sample data:**

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/02-data-types.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/03-create_tables_schemas.sql
```

## 8. Next

➡️ **[Chapter 7 — Joins](07-joins.md)**
