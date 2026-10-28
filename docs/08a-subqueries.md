# Chapter 8a — Subqueries

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

A subquery is a **question inside a question**.

- Outer query: "Give me customers of the tenant named 'Acme Toys'."
- Inner query: "Which tenant is named 'Acme Toys'?"

The inner query runs first and hands the answer to the outer one.

## 2. Real name

- **Subquery** / **inner query** / **nested query**.
- Forms: scalar subquery, `IN (SELECT ...)`, `EXISTS (SELECT ...)`.

## 3. SQL example

```sql
SELECT full_name, email
FROM customers
WHERE tenant_id = (SELECT id FROM tenants WHERE name = 'Acme Toys');
```

**Exact output I got:**

```
   full_name    |       email        
----------------+---------------------
 Alice Anderson | alice@acme.example
 Bob Brown      | bob@acme.example
(2 rows)
```

### Subquery with IN

```sql
SELECT full_name, email
FROM customers
WHERE tenant_id IN (SELECT id FROM tenants);
```

**Exact output I got:**

```
   full_name    |        email         
----------------+---------------------
 Alice Anderson | alice@acme.example
 Bob Brown      | bob@acme.example
 Carol Clark    | carol@globex.example
(3 rows)
```

### Subquery with EXISTS

```sql
SELECT c.full_name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
```

**Exact output I got:**

```
   full_name    
----------------
 Alice Anderson
 Bob Brown
 Carol Clark
(3 rows)
```

## 4. Why this matters in a real e-commerce platform

"Get me all products of the tenant that runs the 'Acme' shop" — the tenant id is often looked up by name.

## 5. When to use it and when NOT to

- Use subqueries for simple nesting; use JOINs for most real-world "related rows" needs (Chapter 7).
- `EXISTS` is often faster than `IN` for large sets.

## 6. Common mistakes

- Forgetting that the inner query must return exactly one value for a scalar subquery.

## 7. Try it yourself

**Exercise:** Use a subquery to find the customers of the tenant named 'Globex Gifts'.

<details>
<summary>✅ Solution (click to open)</summary>

```sql
SELECT full_name, email
FROM customers
WHERE tenant_id IN (SELECT id FROM tenants WHERE name = 'Globex Gifts');
```

**Expected output:**

```
   full_name    |        email         
----------------+---------------------
 Carol Clark    | carol@globex.example
(1 row)
```

</details>

## 8. Next

➡️ **[Chapter 8b — CTEs, set operations, window functions](08b-ctes-set-ops-window.md)**
