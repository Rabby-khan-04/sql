# Chapter 11 — Design: Normalization, Denormalization, Soft Delete, Snapshot Pattern

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

If a spreadsheet row gets too big, we split it into several smaller tables that point to each other. This is **normalization**.

Later, for speed, we sometimes copy some columns back together — that's **denormalization**.

- **Soft delete** = marking a row as "deleted" instead of actually deleting it.
- **Snapshot** = copying name and price into an order so the price never changes later.

## 2. Real name

Normalization (1NF, 2NF, 3NF), denormalization, soft delete, snapshot pattern.

## 3. SQL example — snapshot pattern (copy name+price into order item)

```sql
CREATE TABLE order_items_snapshot (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(10,2) NOT NULL,   -- snapshot: frozen at purchase time
    product_name TEXT NOT NULL,           -- snapshot: frozen at purchase time
    CONSTRAINT fk_osi_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
INSERT INTO order_items_snapshot (order_id, product_id, quantity, unit_price, product_name)
SELECT oi.order_id, oi.product_id, oi.quantity, oi.unit_price, p.name
FROM order_items oi
JOIN products p ON p.id = oi.product_id;
```

**Snapshot purpose:** If someone later changes the product's price from $499.99 to $599.99, the order item's snapshot price stays at $499.99. History never changes.

## 4. Why this matters in a real e-commerce platform

Order history must not break when product prices change.

## 5. When to use it and when NOT to

- Snapshot: always copy price/name at purchase time.
- Denormalize only after normalizing first.

## 6. Common mistakes

- Storing only the product ID in order items → can't reconstruct the price later.

## 7. Try it yourself

**Exercise:** Create an order_items_snapshot table with the snapshot columns and populate it.

## 8. Next

➡️ **[Chapter 12 — Money: numeric, float, rounding, currency, taxes](12-money.md)**