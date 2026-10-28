# 📋 Checklist — SQL Learning Roadmap

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — this roadmap was written and all SQL examples were verified against this version.

> **Learning database:** `learn_shop` in container `sql-learn` (port 5433 → 5432), throwaway, never touch any other database.

---

## ✅ Checklist — tick each box when its chapter is done

### Foundations
- [x] What a database is, tables, rows, columns, primary keys, relational thinking, SQL vs spreadsheet

### Data types
- [x] Text, integers, boolean, timestamps & time zones, UUID vs serial/identity, numeric vs float, JSON

### Defining data
- [x] CREATE, ALTER, DROP TABLE, schemas

### Working with data
- [x] INSERT, SELECT, UPDATE, DELETE, WHERE, ORDER BY, LIMIT, DISTINCT, NULL and three-valued logic, pattern matching

### Pagination
- [x] OFFSET vs keyset (cursor) pagination, why OFFSET gets slow

### Aggregation
- [x] COUNT, SUM, AVG, GROUP BY, HAVING

### Joins
- [x] INNER, LEFT, RIGHT, FULL, CROSS, self joins, many-to-many through a join table

### Subqueries / CTEs / set ops / window functions
- [x] Subqueries
- [x] CTEs (WITH), set operations (UNION, INTERSECT, EXCEPT), window functions (ROW_NUMBER, RANK, running totals)

### Constraints
- [x] PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT, composite keys

### Foreign key actions
- [x] ON DELETE / ON UPDATE (CASCADE, RESTRICT, NO ACTION, SET NULL, SET DEFAULT), danger demo

### Design
- [x] Normalization (1NF→3NF), denormalization, soft delete vs hard delete, snapshot pattern

### Money
- [x] Integer cents / numeric, never float; rounding; currency, taxes, discounts

### Indexes
- [x] B-tree, unique, composite (column order), partial, covering, costs, when not used

### EXPLAIN
- [x] EXPLAIN / EXPLAIN ANALYZE, reading plans (Seq Scan vs Index Scan, cost, rows, timing), fixing slow queries

### Transactions
- [x] BEGIN/COMMIT/ROLLBACK, ACID, isolation levels, FOR UPDATE, deadlocks, race conditions

### Views / materialized views / functions / triggers
- [x] Views, materialized views, functions, triggers (briefly, with warnings)

### Multi-tenancy
- [x] tenant_id, composite indexes, composite unique, composite FK, RLS

### Migrations
- [x] Versioned schema changes, add column, backfill, CONCURRENTLY, avoid long locks

### Security & operations
- [x] SQL injection, parameterized queries, users & permissions, backups & restore, connection pooling, monitoring

### Real-world patterns
- [x] Order in one transaction, stock reduction without overselling, order history with snapshots, multi-tenant product catalog, coupons & loyalty points, fraud/ban list, pitfalls of each

---

## 📦 How to reset the sample data (always)

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
```

## 🔄 Full rebuild from scratch

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/02-data-types.sql
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/03-create-tables-schemas.sql
```

## 📚 Sources of truth
1. <https://www.postgresql.org/docs/current/>
2. The SQL language and tutorial chapters of those docs
3. The running database itself (`\?`, `\d`, `\h <command>`, `EXPLAIN`)

> **Rule:** If the sources ever disagree with the real behavior, trust the real result and I'll tell you.

---

## 📄 Documentation file map

| Doc file | SQL file | Topic |
|---|---|---|
| `01-what-is-a-database.md` | `01-what-is-a-database.sql` | What is a database? |
| `02-data-types.md` | `02-data-types.sql` | Data types |
| `03-create-tables-schemas.md` | `03-create-tables-schemas.sql` | CREATE / ALTER / DROP / schemas |
| `04-insert-select-update-delete.md` | `04-insert-select-update-delete.sql` | CRUD + WHERE / ORDER BY / LIMIT / DISTINCT / NULL / LIKE |
| `05-pagination.md` | `05-pagination.sql` | OFFSET vs keyset |
| `06-aggregation.md` | `06-aggregation.sql` | COUNT / SUM / AVG / GROUP BY / HAVING |
| `07-joins.md` | `07-joins.sql` | INNER / LEFT / RIGHT / FULL / CROSS / self / many-to-many |
| `08a-subqueries.md` | `08a-subqueries.sql` | Subqueries |
| `08b-ctes-set-ops-window.md` | `08b-ctes-set-ops-window.sql` | CTEs / UNION / INTERSECT / EXCEPT / window functions |
| `09-constraints.md` | `09-constraints.sql` | UNIQUE / CHECK / FOREIGN KEY |
| `10-foreign-key-actions.md` | `10-foreign-key-actions.sql` | ON DELETE / ON UPDATE + danger demo |
| `11-normalization.md` | `11-normalization.sql` | Design: normalization / denormalization / soft delete / snapshot |
| `12-money.md` | `12-money.sql` | Money: numeric vs float / rounding / currency / taxes |
| `13-indexes.md` | `13-indexes.sql` | B-tree / unique / composite / partial / covering |
| `14-explain.md` | `14-explain.sql` | EXPLAIN / EXPLAIN ANALYZE |
| `15-transactions.md` | `15-transactions.sql` | BEGIN / COMMIT / ROLLBACK / ACID / isolation / FOR UPDATE |
| `16-views-materialized-views-functions-triggers.md` | `16-views-functions-triggers.sql` | Views / materialized views / functions / triggers |
| `17-multi-tenancy.md` | `17-multi-tenancy.sql` | tenant_id / composite FK / unique / RLS |
| `18-migrations.md` | *(implicit in SQL)* | Versioned schema changes |
| `19-security-operations.md` | *(implicit in SQL)* | Injection, users, backups, pool, monitor |
| `21-real-world-patterns.md` | `21-real-world-patterns.sql` | E-commerce patterns |

> **Note:** Chapters 18 (migrations) and 19 (security & ops) focus on concepts; their core SQL demos are embedded in other files or demonstrated via ad-hoc psql commands. The real-world patterns file contains the full e-commerce transaction demo.

---

## 🛠 Useful one-liners

```bash
# Reset the whole learning database
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql

# Run a single chapter's SQL
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/01-what-is-a-database.sql

# Dump the current state for safekeeping
docker exec sql-learn pg_dump -U postgres -d learn_shop > /tmp/opencode/learn_shop_backup.sql
```