# Chapter 1 — What is a Database?

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

Imagine a big office with filing cabinets.

- The **building** where all files live is the **database**.
- Each **filing cabinet** is a **schema** (we will meet schemas in Chapter 3).
- Each **drawer** inside the cabinet is a **table**.
- Each **file** in the drawer is a **row**.
- The **label on the file** is the **column**.
- The **unique file number** that never repeats is the **primary key**.

A database is just a very organized, very fast way to store data so a computer can save it, find it, change it, and not lose it.

**SQL** is the language we use to talk to the database. It stands for **Structured Query Language**. You ask: "Give me all files from drawer X where the label says Y." The database answers.

This is very different from a **spreadsheet** (like Excel). A spreadsheet is one file on one computer. A database is a whole library of filing cabinets that many computers can use at the same time, safely.

## 2. Real name

| Simple word | Real database term | What it means technically |
|---|---|---|
| Filing cabinet | **Database** | A structured collection of data. |
| Drawer | **Schema** | A group of related tables. (We meet schemas in Chapter 3.) |
| Folder | **Table** | A grid of columns and rows. In PostgreSQL we say **relation** (table is a special kind of relation). |
| File | **Row** (record) | One stored piece of data. Technically a **tuple**. |
| Label | **Column** (field) | One attribute of the row. Has a **data type** (text, number, date...). |
| Unique file number | **Primary key** | An **identifier** that is unique per row, usually the table's first column. |

## 3. SQL example

We run these statements on the `learn_shop` database. (`learn_shop` is our throwaway learning database — see `docs/00-roadmap.md`.)

```sql
SELECT version() AS postgres_version;
SELECT current_database() AS current_database, current_user AS current_user;
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
```

**Exact output I got** (on PostgreSQL 17.11):

```
postgres_version
------------------------------------------------------------------------------------------------------------------
 PostgreSQL 17.11 (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) on x86_64-pc-linux-gnu, 64-bit
(1 row)

 current_database | current_user
------------------+---------------
 learn_shop       | postgres
(1 row)

  tablename
-----------
 customers
 tenants
(3 rows)
```

### Line-by-line explanation

- `SELECT version() ...` — asks the database for its version. `version()` is a built-in function returning the version as one value.
- `SELECT current_database() ...` — asks "which database are you me?" → `learn_shop`. `current_user` → `postgres`.
- `SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename` — lists all tables in the **`public` schema** (the default schema). `pg_tables` is a **system catalog** (a table the database itself uses to describe tables).

> **Note:** `pg_*` tables are how PostgreSQL internally keeps track of things. You rarely query them, but it's a nice way to see what's inside a database.

## 4. Why this matters in a real e-commerce platform

When a company runs an online shop, they have one big database (or a few) holding **tenants** (stores), **users**, **customers**, **products**, **orders**, **order_items**, **payments**, **coupons** — the tables we will build later in this course.

When you write in Prisma:

```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model Tenant {
  id   String @id @default(uuid()) @db.Uuid
  name String
}
```

...Prisma translates `model Tenant` into a `tenants` table in PostgreSQL. A Prisma `SELECT` becomes a SQL query like `SELECT ... FROM tenants WHERE ...`. Understanding the database means you understand what Prisma is secretly doing for you.

If you understand "database → table → row → column → primary key → SQL", you will understand every Prisma error, every slow query, and every migration.

## 5. When to use it and when NOT to

- **Use a database** when you need data to be safe, shared, queryable, and consistent (e.g., orders, payments, products).
- **Not a database** when you just need a small bit of state that lives for seconds (like a form draft) — but even then people often use a cache or session store. Keep this simple for now.

## 6. Common mistakes

- Thinking a database is just "a really big Excel file" → no, it has transactions, concurrency control, and query planning.
- Forgetting that a **table** is not the same as a **spreadsheet tab**: no formulas, no cell merging — just typed columns and rows.

## 7. Try it yourself

**Exercise:** Look at the current tables and run these queries.

```sql
SELECT * FROM tenants;
```

**Hint:** You created a `tenants` table in Chapter 2. If you reset, you can also use the psql meta-command `\dt` to list tables (`\dt` = "describe tables").

<details>
<summary>✅ Solution (click to open)</summary>

```sql
SELECT * FROM tenants;
```

**Expected output** (from my run):

```
                  id                  |     name     | is_active |          created_at          
--------------------------------------+--------------+------------+-------------------------------
 11111111-1111-1111-1111-111111111111 | Acme Toys    | t          | 2026-10-28 05:30:23.804613+00
 22222222-2222-2222-2222-222222222222 | Globex Gifts | t          | 2026-10-28 05:30:23.804613+00
(2 rows)
```

</details>

**Reset the sample data any time:**

```bash
docker exec -i sql-learn psql -U postgres -d learn_shop -f sql/00-reset.sql
```

## 8. Next

➡️ **[Chapter 2 — Data Types](02-data-types.md)**
