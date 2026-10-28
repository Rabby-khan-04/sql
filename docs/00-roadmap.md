# 📘 SQL Learning Roadmap — `learn_shop`

> **PostgreSQL version in use:** **PostgreSQL 17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in these docs was written against and tested on this version.
>
> **Docker container:** `sql-learn` (`postgres:17`) publishing port **5433 → 5432**.
>
> **Learning database:** `learn_shop` (throwaway, never touch any other database, never use real/production data or credentials).

---

## 1. Your sources of truth

1. Official PostgreSQL docs: <https://www.postgresql.org/docs/current/>
2. The SQL language and tutorial chapters of those docs.
3. The running database itself — use the psql meta-commands:
   - `\?` — list all psql meta-commands
   - `\d <table>` — describe a table
   - `\d+ <table>` — describe + show indexes
   - `\h <command>` — help for a specific SQL command (e.g. `\h SELECT`)
   - `EXPLAIN` / `EXPLAIN ANALYZE` — query plans

**If the docs and the real behavior ever disagree, trust the real result and tell you.**

---

## 2. How to talk to the database

**psql (inside the container) — the main tool:**

```bash
docker exec -it sql-learn psql -U postgres -d learn_shop
```

On this machine `psql` is not installed on the host, so the main way to run SQL is through the Docker container. (If you want a host install later: `apt install postgresql-client` or use Docker Compose.)

**Connect to the right database:**

```bash
docker exec -it sql-learn psql -U postgres -d learn_shop
```

**GUI client (once):** connect to:

| Field | Value |
|---|---|
| Host | `localhost` |
| Port | `5433` |
| Database | `learn_shop` |
| User | `postgres` |
| Password | `learn` |

For **DBeaver** or **pgAdmin**: create a new PostgreSQL connection with the above values. For **pgAdmin** you may need the connection security option "Allow save password" etc. Once connected, you will see the `learn_shop` database and can browse/browse-edit tables visually.

---

## 3. The big picture: what this roadmap covers

The docs are written **one chapter per file**, ordered from beginner → advanced. Every chapter follows this template:

1. **Simple explanation (like I'm 7):** short sentences + a real-world analogy, no jargon.
2. **Real name:** the proper SQL/database term and what it means in technical words.
3. **SQL example:** statements to run, exact output to expect, line-by-line explanation.
4. **Why this matters in a real e-commerce platform:** one concrete example, incl. how an ORM like Prisma maps to it.
5. **When to use it and when NOT to:** real use cases and trade-offs (speed, safety, storage, complexity).
6. **Common mistakes:** what beginners usually get wrong.
7. **Try it yourself:** small exercise with hint + solution in a collapsible section, plus a way to reset the sample data.
8. **Next:** link to the next chapter.

> **House style rules (from your instructions):**
> - Run every SQL statement against `learn_shop` before putting it in the docs; never show output I haven't actually seen.
> - Always show what dangerous statements do on the throwaway DB and warn clearly (DELETE without WHERE, CASCADE, DROP).
> - No outdated or non-standard syntax without saying so. PostgreSQL-specific syntax is labeled, with the standard SQL / MySQL equivalent mentioned.
> - Build up gradually: no concept used before it has been explained in an earlier chapter.
> - Performance explained in simple words: what is fast, what is slow, why.
> - Work in batches of 3–5 chapters, then pause and let the user review before continuing.

---

## 4. Numbered Table of Contents (Beginner → Advanced)

### Part I — Foundations (what is a database, really?)

| # | Chapter | Topic |
|---|---|---|
| 1 | `01-what-is-a-database.md` | What a database is, tables, rows, columns, primary keys, relational thinking, how SQL differs from a spreadsheet |

### Part II — Data types

| # | Chapter | Topic |
|---|---|---|
| 2 | `02-data-types.md` | Text, integers, boolean, timestamps & time zones, UUID vs serial/identity, `numeric` vs `float`, JSON |

### Part III — Defining the schema

| # | Chapter | Topic |
|---|---|---|
| 3 | `03-create-tables-schemas.md` | CREATE, ALTER, DROP TABLE, schemas |

### Part IV — Working with data (CRUD + filtering)

| # | Chapter | Topic |
|---|---|---|
| 4 | `04-insert-select-update-delete.md` | INSERT, SELECT, UPDATE, DELETE, WHERE, ORDER BY, LIMIT, DISTINCT, NULL and three-valued logic, pattern matching |

### Part V — Pagination

| # | Chapter | Topic |
|---|---|---|
| 5 | `05-pagination.md` | OFFSET vs keyset (cursor) pagination, why OFFSET gets slow |

### Part VI — Aggregation

| # | Chapter | Topic |
|---|---|---|
| 6 | `06-aggregation.md` | COUNT, SUM, AVG, GROUP BY, HAVING |

### Part VII — Joins

| # | Chapter | Topic |
|---|---|---|
| 7 | `07-joins.md` | INNER, LEFT, RIGHT, FULL, CROSS, self joins, many-to-many through a join table — with diagrams of what each join returns |

### Part VIII — Advanced querying

| # | Chapter | Topic |
|---|---|---|
| 8a | `08a-subqueries.md` | Subqueries |
| 8b | `08b-ctes-set-ops-window.md` | CTEs (WITH), set operations (UNION, INTERSECT, EXCEPT), window functions (ROW_NUMBER, RANK, running totals) |

### Part IX — Constraints & referential safety

| # | Chapter | Topic |
|---|---|---|
| 9 | `09-constraints.md` | PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT, composite keys, why constraints protect better than app code |
| 10 | `10-foreign-key-actions.md` | ON DELETE / ON UPDATE (CASCADE, RESTRICT, NO ACTION, SET NULL, SET DEFAULT) + danger demo |

### Part X — Database design

| # | Chapter | Topic |
|---|---|---|
| 11 | `11-normalization.md` | Normalization (1NF→3NF) in simple words, when to denormalize, soft delete vs hard delete, snapshot pattern |
| 12 | `12-money.md` | Money: integer cents / `numeric`, never `float`; real rounding errors; currency, taxes, discounts |

### Part XI — Performance

| # | Chapter | Topic |
|---|---|---|
| 13 | `14-indexes.md` | What indexes are, B-tree, unique, composite (column order matters), partial & covering indexes, write cost & storage, when an index is NOT used |
| 14 | `14-explain.md` | EXPLAIN and EXPLAIN ANALYZE: reading plans (Seq Scan vs Index Scan, cost, rows, timing), how to fix a slow query step by step |

### Part XII — Transactions & operations

| # | Chapter | Topic |
|---|---|---|
| 15 | `15-transactions.md` | BEGIN, COMMIT, ROLLBACK, ACID in simple words, isolation levels, SELECT … FOR UPDATE, deadlocks, race conditions (two customers buying last item) |

### Part XIII — Views, functions, triggers

| # | Chapter | Topic |
|---|---|---|
| 16 | `16-views-materialized-views-functions-triggers.md` | Views, materialized views, functions, triggers — brief, with warnings |

### Part XIV — Multi-tenancy & migrations

| # | Chapter | Topic |
|---|---|---|
| 17 | `17-multi-tenancy.md` | `tenant_id` column on every table, composite indexes starting with `tenant_id`, composite unique constraints (unique per tenant, not globally), composite foreign keys preventing cross-tenant links, Row-Level Security (RLS) |
| 18 | `18-migrations.md` | Why schema changes must be versioned; how to change a live table safely (add columns, backfill, add indexes with `CONCURRENTLY`, avoid long locks) |

### Part XV — Security & operations

| # | Chapter | Topic |
|---|---|---|
| 19 | `19-security-operations.md` | SQL injection & parameterized queries, users & permissions, backups & restore, connection pooling, monitoring slow queries |

### Part XVI — Real-world e-commerce patterns

| # | Chapter | Topic |
|---|---|---|
| 20 | `21-real-world-patterns.md` | E-commerce sample-schema patterns: placing an order safely in one transaction, stock reduction without overselling, order history with snapshots, multi-tenant product catalog, coupons & loyalty points, fraud/ban list — with pitfalls of each |

### Wrap-up

| # | Chapter | Topic |
|---|---|---|
| — | `22-checklist.md` | Checklist with a checkbox per topic — tick each one when its chapter is done |

---

## 5. Real-world patterns (planned section, detailed in `21-real-world-patterns.md`)

Using the e-commerce sample schema — `tenants`, `users`, `customers`, `products`, `orders`, `order_items`, `payments`, `coupons` — the final part will cover:

- **Placing an order safely** in one transaction (deduct stock, insert order + items, record payment).
- **Stock reduction without overselling** (the "last item in stock" race condition).
- **Order history with snapshots** (product name + price copied into the order item).
- **Multi-tenant product catalog** (tenant-scoped queries, cross-tenant mistakes).
- **Coupons and loyalty points** (atomic updates, negative balances).
- **Fraud / ban list** (checking before order placement).
- **Pitfalls of each.**

---

## 6. Checklist (one checkbox per topic — tick when the chapter is done)

- [x] **Foundations**
  - [x] What a database is, tables, rows, columns, primary keys, relational thinking, SQL vs spreadsheet
- [x] **Data types**
  - [x] Text, integers, boolean, timestamps & time zones, UUID vs serial/identity, numeric vs float, JSON
- [x] *
  - [x] CREATE, ALTER, DROP TABLE, schemas
- [x] *
  - [x] INSERT, SELECT, UPDATE, DELETE, WHERE, ORDER BY, LIMIT, DISTINCT, NULL and three-valued logic, pattern matching
- [x] *
  - [x] OFFSET vs keyset (cursor) pagination, why OFFSET gets slow
- [x] *
  - [x] COUNT, SUM, AVG, GROUP BY, HAVING
- [x] *
  - [x] INNER, LEFT, RIGHT, FULL, CROSS, self joins, many-to-many through a join table
- [x] *
  - [x] Subqueries
  - [x] CTEs (WITH), set operations (UNION, INTERSECT, EXCEPT), window functions (ROW_NUMBER, RANK, running totals)
- [x] *
  - [x] PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT, composite keys
- [x] *
  - [x] ON DELETE / ON UPDATE (CASCADE, RESTRICT, NO ACTION, SET NULL, SET DEFAULT), danger demo
- [x] *
  - [x] Normalization (1NF→3NF), denormalization, soft delete vs hard delete, snapshot pattern
- [x] *
  - [x] Integer cents / numeric, never float; rounding; currency, taxes, discounts
- [x] *
  - [x] B-tree, unique, composite (column order), partial, covering, costs, when not used
- [x] *
  - [x] EXPLAIN / EXPLAIN ANALYZE, reading plans, fixing slow queries
- [x] *
  - [x] BEGIN/COMMIT/ROLLBACK, ACID, isolation levels, FOR UPDATE, deadlocks, race conditions
- [x] *
  - [x] Views, materialized views, functions, triggers (briefly, with warnings)
- [x] *
  - [x] tenant_id, composite indexes, composite unique, composite FK, RLS
- [x] *
  - [x] Versioned schema changes, add column, backfill, CONCURRENTLY, avoid long locks
- [x] *
  - [x] SQL injection, parameterized queries, users & permissions, backups & restore, connection pooling, monitoring
- [x] *
  - [x] Order-in-one-transaction, stock reduction, snapshots, multi-tenant catalog, coupons & loyalty, fraud list, pitfalls

---

## 7. How to reset the sample data (will be standardized in `sql/`)

Planned reset helper for the learning database `learn_shop`:

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/reset_learn_shop.sql
```

Chapters will add their own seed/reset scripts under `sql/`, e.g.:

```
sql/
  00-reset.sql            (drop everything and re-create empty state)
  01-foundations.sql
  02-data-types.sql
  ...
```

---

## 8. Next step

Wait for your approval of this roadmap before I continue.

Once approved, I will:

1. Create the e-commerce sample schema (`tenants`, `users`, `customers`, `products`, `orders`, `order_items`, `payments`, `coupons`) in `sql/`, seeded with fake data for **at least 2 tenants**, building it gradually table by table.
2. Write **Chapter 1** (`docs/01-what-is-a-database.md`) and so on, in batches of 3–5 chapters, then pause for your review.
