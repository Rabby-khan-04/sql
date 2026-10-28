-- ============================================================================
-- Chapter 2: Data Types (UUID, TEXT, BOOLEAN, TIMESTAMPTZ)
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/02-data-types.sql
--
-- Introduces the first sample table of the `learn_shop` e-commerce schema.
-- We start small: the `tenants` table. Later chapters add the rest.

CREATE TABLE tenants (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name       TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO tenants (id, name, is_active) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Acme Toys', TRUE),
    ('22222222-2222-2222-2222-222222222222', 'Globex Gifts', TRUE);

SELECT * FROM tenants;
