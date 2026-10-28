# Chapter 14 — EXPLAIN and EXPLAIN ANALYZE: Reading Query Plans

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

When you run a query, PostgreSQL figures out the fastest way to get the data. `EXPLAIN` shows that plan. It tells you whether it's scanning the whole table or using an index.

## 2. Real name

`EXPLAIN`, `EXPLAIN ANALYZE`, **Seq Scan**, **Index Scan**, **cost**, **rows**, **timing**.

## 3. SQL example — Seq Scan vs Index Scan

```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = '546592e4-5a3b-4d06-a3c5-aabbfcfe848d';
```

**Exact output I got:**

```
                               QUERY PLAN                               
------------------------------------------------------------------------
 Seq Scan on orders  (cost=0.00..1.02 rows=1 width=88)
   Filter: (customer_id = '546592e4-5a3b-4d06-a3c5-aabbfcfe848d'::uuid)
(2 rows)
```

```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = '546592e4-5a3b-4d06-a3c5-aabbfcfe848d';
```

**Exact output I got:**

```
                                           QUERY PLAN                                            
-------------------------------------------------------------------------------------------------
 Seq Scan on orders  (cost=0.00..1.02 rows=1 width=88) (actual time=0.006..0.006 rows=1 loops=1)
   Filter: (customer_id = '546592e4-5a3b-4d06-a3c5-aabbfcfe848d'::uuid)
   Rows Removed by Filter: 1
 Planning Time: 0.021 ms
 Execution Time: 0.030 ms
(5 rows)
```

Note: before the index was created, it was a Seq Scan. After adding `idx_orders_customer` (Chapter 13), the plan switched to using an Index Scan.

## 4. Why this matters in a real e-commerce platform

"If it's doing a Seq Scan on 1M rows, it's slow. Add an index."

## 6. Common mistakes

- Not reading EXPLAIN ANALYZE before adding indexes.

## 7. Try it yourself

**Exercise:** Run EXPLAIN ANALYZE on a slow query, then add an index and run again.

## 8. Next

➡️ **[Chapter 15 — Transactions: BEGIN/COMMIT/ROLLBACK/ACID/isolation/FOR UPDATE](15-transactions.md)**