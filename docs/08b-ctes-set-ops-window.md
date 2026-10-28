# Chapter 8b — CTEs, Set Operations, and Window Functions

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

Three advanced superpowers:

1. **CTEs (WITH)** — "first, make a temporary small table with a name, then use it."
2. **Set operations** — combine results of two queries with UNION / INTERSECT / EXCEPT.
3. **Window functions** — do math over a *group of rows* while still returning every row.

## 2. Real name

- **CTE** = **Common Table Expression**, syntax `WITH name AS (SELECT ...) SELECT ...`.
- **UNION / UNION ALL** — set operations; `INTERSECT`, `EXCEPT` (SQL) / `MINUS` (Oracle).
- **Window function** — e.g. `ROW_NUMBER() OVER (...)`, `RANK() OVER (...)`, `SUM() OVER (...)`.

## 3. SQL example — CTE

```sql
WITH acme_customers AS (
    SELECT full_name, email
    FROM customers
    WHERE tenant_id = '11111111-1111-1111-1111-111111111111'
)
SELECT * FROM acme_customers;
```

**Exact output I got:**

```
   full_name    |       email        
----------------+---------------------
 Alice Anderson | alice@acme.example
 Bob Brown      | bob@acme.example
(2 rows)
```

## 4. SQL example — set operations

```sql
SELECT name AS name FROM tenants
UNION
SELECT full_name AS name FROM customers;
```

**Exact output I got:**

```
      name      
-----------------
 Alice Anderson
 Acme Toys
 Globex Gifts
 Bob Brown
 Carol Clark
(5 rows)
```

```sql
SELECT tenant_id FROM customers
INTERSECT
SELECT tenant_id FROM orders;
```

**Exact output I got:**

```
              tenant_id               
--------------------------------------
 11111111-1111-1111-1111-111111111111
 22222222-2222-2222-2222-222222222222
(2 rows)
```

## 5. SQL example — window functions

```sql
SELECT full_name, ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rn
FROM customers;
```

**Exact output I got:**

```
   full_name    | rn 
----------------+-----
 Alice Anderson |  1
 Bob Brown      |  2
 Carol Clark    |  3
(3 rows)
```

Running total with window:

```sql
SELECT full_name, SUM(LENGTH(full_name)) OVER (ORDER BY created_at DESC) AS running_total
FROM customers;
```

**Exact output I got:**

```
   full_name    | running_total 
----------------+---------------
 Alice Anderson |            14
 Bob Brown      |            23
 Carol Clark    |            34
(3 rows)
```

Ranking products by price:

```sql
SELECT name, price, RANK() OVER (ORDER BY price DESC) AS rnk
FROM products
ORDER BY price DESC;
```

**Exact output I got:**

```
      name       |  price  | rnk 
-----------------+--------+-----
 Acme Racer Bike | 499.99 |   1
 Globex Rocket   | 199.99 |   2
 Acme Helmet     |  49.99 |   3
(3 rows)
```

## 6. Why this matters in a real e-commerce platform

- CTEs: nice for readability of complex queries.
- Window functions: "top N per group" (e.g., top 5 customers per tenant), running totals (e.g., revenue running total), rank (leaderboards).

## 7. When to use it and when NOT to

- Window functions are not indexes-friendly in old PG; PG 17 supports them well.

## 8. Common mistakes

- Forgetting `OVER`.

## 9. Try it yourself

**Exercise:** Use a CTE to list only Globex customers.

<details>
<summary>✅ Solution (click to open)</summary>

```sql
WITH globex_customers AS (
    SELECT full_name, email FROM customers WHERE tenant_id = '22222222-2222-2222-2222-222222222222'
)
SELECT * FROM globex_customers;
```

**Expected output:**

```
   full_name    |        email         
----------------+---------------------
 Carol Clark   | carol@globex.example
(1 row)
```

</details>

## 10. Next

➡️ **[Chapter 9 — Constraints](09-constraints.md)**
