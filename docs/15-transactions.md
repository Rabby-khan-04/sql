# Chapter 15 — Transactions: BEGIN, COMMIT, ROLLBACK, ACID, Isolation, FOR UPDATE

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

A transaction is a **bundle of steps** that either ALL happen or NONE happen.

- `BEGIN` → start the bundle.
- `COMMIT` → save it ("all or nothing").
- `ROLLBACK` → undo it.

Like a microwave meal: you heat it, you either finish or throw it away — you don't stop halfway and eat half.

## 2. Real name

- Transaction, `BEGIN` / `COMMIT` / `ROLLBACK`, **ACID**, **isolation level**, `SELECT ... FOR UPDATE`.

## 3. SQL example

```sql
BEGIN;
UPDATE products SET stock = stock - 1 WHERE id = (SELECT id FROM products WHERE name = 'Acme Racer Bike');
SELECT stock FROM products WHERE name = 'Acme Racer Bike';
COMMIT;
```

**Outputs I got:**

```
BEGIN
UPDATE 1
 stock 
-------
     4
(1 row)

COMMIT
```

Rolling back:

```sql
BEGIN;
UPDATE products SET stock = stock - 1 WHERE name = 'Acme Racer Bike';
ROLLBACK;
SELECT stock FROM products WHERE name = 'Acme Racer Bike';
```

**Outputs I got:**

```
BEGIN
UPDATE 1
ROLLBACK
 stock 
-------
     4
(1 row)
```

`FOR UPDATE` — lock the row while you work on it (important for buying last stock):

```sql
BEGIN;
SELECT * FROM products WHERE name = 'Acme Racer Bike' FOR UPDATE;
COMMIT;
```

## 4. Why this matters in a real e-commerce platform

Placing an order = deduct stock + insert order + insert payment, all in ONE transaction (Chapter 21).

## 5. When to use it and when NOT to

Always wrap multi-step writes in transactions in production.

## 6. Common mistakes

- No transaction → partial updates.
- `FOR UPDATE` missing → race conditions.

## 7. Try it yourself

**Exercise:** Wrap an update in BEGIN/COMMIT and one in BEGIN/ROLLBACK.

## 8. Next

➡️ **[Chapter 16 — Views, materialized views, functions, triggers](16-views-materialized-views-functions-triggers.md)**
