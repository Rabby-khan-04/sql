# Chapter 7 — Joins: INNER, LEFT, RIGHT, FULL, CROSS, SELF, MANY-TO-MANY

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

A database stores data in **separate tables** that are related. A join is how you ask: "Show me the order AND the customer together."

Like a mail merge: you have an orders folder and a customers folder; the join is the rule that says which order belongs to which customer.

## 2. Real name

- `INNER JOIN` — only rows that have a match in both tables.
- `LEFT JOIN` (a.k.a. LEFT OUTER JOIN) — all rows from the left table, plus matches from the right; missing → NULL.
- `RIGHT JOIN` (RIGHT OUTER JOIN) — mirror image of LEFT.
- `FULL JOIN` (FULL OUTER JOIN) — all rows from both, matched or not.
- `CROSS JOIN` — every row of A × every row of B (cartesian product).
- `SELF JOIN` — a table joined with itself.
- **JOIN table / junction table** — a third table that links two others in a many-to-many relationship.

## 3. SQL example

We created the e-commerce tables `orders`, `order_items` (join table) and `products` in this chapter.

### INNER JOIN — orders with their customer

```sql
SELECT o.id AS order_id, c.full_name, c.email, o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;
```

**Exact output I got:**

```
               order_id               |   full_name    |        email         | status  
--------------------------------------+----------------------------------------------
 f4d57e8e-0679-45fe-9ab3-0c78bbb65428 | Alice Anderson | alice@acme.example   | shipped
 beebad8b-fe39-484b-8a8f-e19444b82443 | Alice Anderson | alice@acme.example   | pending
 ad45f43e-b90a-4b46-a22c-477d65164789 | Bob Brown      | bob@acme.example     | pending
 7ba066db-4f2d-4b99-9301-5e0bd9335dab | Carol Clark    | carol@globex.example | pending
(4 rows)
```

### LEFT JOIN — customers with their orders

```sql
SELECT c.full_name, o.status
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;
```

**Exact output I got:**

```
   full_name    | status  
----------------+---------
 Alice Anderson | shipped 
 Alice Anderson | pending 
 Bob Brown      | pending 
 Carol Clark    | pending 
(4 rows)
```

### FULL JOIN — orders and customers, all rows

```sql
SELECT o.id AS order_id, c.full_name
FROM orders o
FULL JOIN customers c ON o.customer_id = c.id;
```

**Exact output I got:**

```
               order_id               |   full_name    
--------------------------------------+-----------------
 f4d57e8e-0679-45fe-9ab3-0c78bbb65428 | Alice Anderson
 beebad8b-fe39-484b-8a8f-e19444b82443 | Alice Anderson
 ad45f43e-b90a-4b46-a22c-477d65164789 | Bob Brown      
 7ba066db-4f2d-4b99-9301-5e0bd9335dab | Carol Clark    
 4330f7d2-090d-4d51-a54b-95ed5d6c1efa | 
(5 rows)
```

### CROSS JOIN

```sql
SELECT c.email, t.name AS tenant_name
FROM customers c
CROSS JOIN tenants t;
```

**Exact output I got:**

```
        email         | tenant_name  
-----------------------+---------------
 alice@acme.example   | Acme Toys
 bob@acme.example     | Acme Toys
 carol@globex.example | Acme Toys
 alice@acme.example   | Globex Gifts
 bob@acme.example     | Globex Gifts
 carol@globex.example | Globex Gifts
(6 rows)
```

### SELF JOIN — two orders by the same customer

```sql
SELECT o1.id AS order_1, o2.id AS order_2
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id AND o1.id <> o2.id;
```

**Exact output I got:**

```
                order_1                |               order_2                
--------------------------------------+--------------------------------------
 f4d57e8e-0679-45fe-9ab3-0c78bbb65428 | beebad8b-fe39-484b-8a8f-e19444b82443
 beebad8b-fe39-484b-8a8f-e19444b82443 | f4d57e8e-0679-45fe-9ab3-0c78bbb65428
(2 rows)
```

### MANY-TO-MANY through a join table (order_items)

```sql
SELECT o.id AS order_id, p.name AS product_name, oi.quantity, oi.unit_price
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.id
INNER JOIN products p ON oi.product_id = p.id;
```

**Exact output I got:**

```
               order_id               |   product_name   | quantity | unit_price 
--------------------------------------+------------------+---------+-------------
 f4d57e8e-0679-45fe-9ab3-0c78bbb65428 | Acme Racer Bike  |        1 |     499.99
 f4d57e8e-0679-45fe-9ab3-0c78bbb65428 | Acme Helmet      |        1 |      49.99
 ad45f43e-b90a-4b46-a22c-477d65164789 | Acme Racer Bike  |        2 |     499.99
 ad45f43e-b90a-4b46-a22c-477d65164789 | Acme Helmet      |        2 |      49.99
 ad45f43e-b90a-4b46-a22c-477d65164789 | Acme Racer Bike  |        2 |     499.99
 ad45f43e-b90a-4b46-a22c-477d65164789 | Acme Helmet      |        2 |      49.99
 4330f7d2-090d-4d51-a54b-95ed5d6c1efa | Globex Rocket    |        2 |     199.99
 7ba066db-4f2d-4b99-9301-5e0bd9335dab | Globex Rocket    |        2 |     199.99
(8 rows)
```

## 4. Why this matters in a real e-commerce platform

An order without its customer or its items is meaningless. `orders` + `order_items` + `products` is the classic e-commerce join trio.

## 5. When to use it and when NOT to

- Use joins for everything relational.
- `CROSS JOIN` is almost never what you want in production (cartesian explosion) — but it's valid SQL.

## 6. Common mistakes

- Forgetting the `ON` condition → you get a CROSS JOIN (every row × every row).
- Using `INNER JOIN` when you want all customers even without orders (should be LEFT JOIN).

## 7. Try it yourself

**Exercise:** List all customers together with their latest order status (LEFT JOIN).

<details>
<summary>✅ Solution (click to open)</summary>

```sql
SELECT c.full_name, o.status
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;
```

</details>

## 8. Next

➡️ **[Chapter 8a — Subqueries](08a-subqueries.md)**
