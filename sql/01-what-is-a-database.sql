-- ============================================================================
-- Chapter 1: What is a database? (SQL Foundations)
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/01-what-is-a-database.sql
--
-- This chapter is intentionally read-only: it introduces concepts, not tables.

SELECT version() AS postgres_version;

SELECT current_database() AS current_database, current_user AS current_user;

SELECT datname FROM pg_database WHERE datallowconn ORDER BY datname;
