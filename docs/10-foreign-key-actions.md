# Chapter 10 — Foreign Keys: ON DELETE / ON UPDATE Actions

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

A **foreign key** says: "This row in this table must not exist without a matching row in that other table."

The **ON DELETE** rule says: what to do when the *other* row disappears:

- `CASCADE` → delete the children too.
- `RESTRICT` / `NO ACTION` → refuse to delete.
- `SET NULL` → set the child's link to NULL.
- `SET DEFAULT` → set it to a default value.

`ON UPDATE` does the same when the parent key is *updated*.

## 2. Real name

- `FOREIGN KEY`, `REFERENCES`, `ON DELETE`, `ON UPDATE`.
- Actions: `CASCADE`, `RESTRICT`, `NO ACTION` (default), `SET NULL`, `SET DEFAULT`.

## 3. SQL example — the danger demo (CASCADE)

We created a `payments` table that belongs to an `orders` row:

```sql
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE payments ADD CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;
INSERT INTO payments (order_id, amount, status) VALUES ('ad45f43e-b90a-4b46-a22c-477d65164789', 999.99, 'paid');
DELETE FROM orders WHERE id = 'ad45f43e-b90a-4b46-a22c-477d65164789';
```

**Outputs I got:**

```
CREATE TABLE
ALTER TABLE
INSERT 0 1
```

Then I checked what was left:

```sql
SELECT 'orders' AS what, count(*) AS n FROM orders
UNION ALL
SELECT 'payments', count(*) FROM payments
UNION ALL
SELECT 'order_items', count(*) FROM order_items;
```

**Exact output I got:**

```
    what     |    n 
----------------+-----
 orders      |    2
 payments    |    0
 order_items |    3
(3 rows)
```

The payment for that order was **gone** (payments = 0) — the `ON DELETE CASCADE` silently wiped it. This is the **danger demo**.

## 4. Why this matters in a real e-commerce platform

Deleting an order would normally want to delete its order items and its payment — `CASCADE` does this automatically. But `CASCADE` on a critical table (e.g., deleting a `tenant` deletes all its users!) can wipe data you didn't expect.

## 5. When to use it and when NOT to

- `CASCADE`: children (order_items, payments) are meaningless without the order → OK.
- `RESTRICT` / `NO ACTION`: critical records → safer to refuse.
- `SET NULL`: optional link (e.g., an order without a driver).
- `SET DEFAULT`: rarely useful.

## 6. Common mistakes

- `CASCADE` from a high-level table (tenant → users → orders → payments) → disaster. Never blindly cascade up.

## 7. Try it yourself

**Exercise:** Try deleting an order that still has a payment, with `ON DELETE RESTRICT` — expect an error.

```sql
ALTER TABLE payments ADD CONSTRAINT fk_payments_order_restrict FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT;
INSERT INTO payments (order_id, amount, status) VALUES ('7ba066db-4f2d-4b99-9301-5e0bd9335dab', 199.99, 'paid');
DELETE FROM orders WHERE id = '7ba066db-4f2d-4b99-9301-5e0bd9335dab';
```

<details>
<summary>✅ Solution (click to open)</summary>

```
ERROR:  update or delete on table "orders" violates foreign key constraint "fk_payments_order_restrict" on table "payments"
DETAIL:  Key (id)=(7ba066db-4f2d-4b99-9301-5e0bd9335dab) is still referenced from table "payments".
```

The delete was **refused** — that's `RESTRICT` protecting data.

</details>

## 8. Next

➡️ **[Chapter 11 — Design: Normalization, soft delete, snapshot pattern](11-normalization.md)**
