-- ============================================================================
-- Chapter 3: CREATE / ALTER / DROP TABLE, and Schemas
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/03-create-tables-schemas.sql
--
-- Expects the state from Chapter 2 (the `tenants` table).

CREATE TABLE customers (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    email      TEXT NOT NULL,
    full_name  TEXT NOT NULL,
    notes      TEXT,                      -- nullable on purpose (see Chapter 4 / NULLs)
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO customers (tenant_id, email, full_name, notes) VALUES
    ('11111111-1111-1111-1111-111111111111', 'alice@acme.example',  'Alice Anderson',  'VIP'),
    ('11111111-1111-1111-1111-111111111111', 'bob@acme.example',    'Bob Brown',       NULL),
    ('22222222-2222-2222-2222-222222222222', 'carol@globex.example','Carol Clark',    'Prefers email');

SELECT * FROM customers;

-- ALTER TABLE: add a new column (here: phone, optional -> may be NULL)
ALTER TABLE customers ADD COLUMN phone TEXT;

SELECT id, full_name, email, notes, phone FROM customers;

-- DANGER ZONE (throwaway learning database ONLY):
--   DROP TABLE customers;
-- would permanently delete the whole `customers` table.
-- We run it here on purpose, on the throwaway DB, and then reset everything.

DROP TABLE customers;

SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
