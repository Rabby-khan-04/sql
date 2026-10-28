-- ============================================================================
-- 00-reset.sql — reset the throwaway learning database `learn_shop`
-- ============================================================================
-- Usage (from /home/sunny/app/nimo/sql):
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/00-reset.sql
--
-- Drops and recreates the schemas, wiping all sample data.
-- Safe: this only ever touches the `learn_shop` database in the `sql-learn`
-- Docker container. NEVER run this against any other database.

DROP SCHEMA IF EXISTS public CASCADE;
DROP SCHEMA IF EXISTS shop CASCADE;
CREATE SCHEMA public;
