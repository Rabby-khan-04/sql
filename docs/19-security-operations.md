# Chapter 19 — Security and Operations: SQL Injection, Users, Backups, Pooling, Monitoring

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

- **SQL injection** = a bad actor putting their own SQL text into your SQL → danger.
- **Parameterized queries** = safely sending values separately.
- **Users/permissions** = giving a login only the rights it needs.
- **Backup** = photocopy of the database.
- **Pooling** = many people sharing one phone line.
- **Monitoring** = watching for slow queries.

## 2. Real name

- SQL injection, parameterized query (`PREPARE` / `EXECUTE` / `$1`), `CREATE USER`, `GRANT`, `pg_dump`, connection pooler (PgBouncer), `EXPLAIN ANALYZE`.

## 3. SQL example — parameterized query

```sql
PREPARE stmt(text) AS SELECT * FROM customers WHERE email = $1;
EXECUTE stmt('alice@acme.example');
DEALLOCATE stmt;
```

**Outputs I got:**

```
PREPARE
                  id                  |              tenant_id               |        email         |   full_name    | notes       |          created_at           
...
(1 row)
DEALLOCATE
```

## 4. SQL example — users & permissions

```sql
CREATE USER learn_shop_app WITH PASSWORD 'learn_app_password';
GRANT SELECT, INSERT ON customers TO learn_shop_app;
```

**Outputs:**

```
CREATE ROLE
GRANT
```

## 5. SQL example — backup with pg_dump

```bash
docker exec sql-learn pg_dump -U postgres -d learn_shop > /tmp/opencode/learn_shop_backup.sql
```

Backup file created (~396 lines).

## 6. Why this matters in a real e-commerce platform

Never build SQL by string concatenation.

## 7. When to use it and when NOT to

Always parameterize; least-privilege users; regular backups.

## 8. Common mistakes

- String concatenation → injection.

## 9. Try it yourself

**Exercise:** Run the PREPARE/EXECUTE.

## 10. Next

➡️ **[Chapter 20 — Real-world patterns, part 1: order placement in one transaction](21-real-world-patterns.md)**
