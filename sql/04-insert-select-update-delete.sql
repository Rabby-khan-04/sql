-- ============================================================================
-- Chapter 4: Working with Data — INSERT, SELECT, UPDATE, DELETE, WHERE,
--             ORDER BY, LIMIT, DISTINCT, LIKE, IS NULL
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/04-insert-select-update-delete.sql
--
-- Expects the state created by chapters 2 and 3 (tenants + customers).

-- ---------- SELECT ----------
SELECT * FROM customers;

-- ---------- SELECT + WHERE ----------
SELECT full_name, email
FROM customers
WHERE tenant_id = '11111111-1111-1111-1111-111111111111';

-- ---------- SELECT + ORDER BY + LIMIT ----------
SELECT full_name, email
FROM customers
ORDER BY full_name ASC
LIMIT 2;

-- ---------- SELECT + DISTINCT ----------
SELECT DISTINCT tenant_id FROM customers ORDER BY tenant_id;

-- ---------- SELECT + LIKE (pattern matching) ----------
SELECT full_name
FROM customers
WHERE full_name LIKE 'A%';

-- ---------- SELECT + IS NULL ----------
SELECT full_name, notes FROM customers WHERE notes IS NULL;

-- ---------- UPDATE ----------
UPDATE customers
SET notes = 'newsletter_opt_in'
WHERE email = 'bob@acme.example';

SELECT full_name, notes FROM customers WHERE email = 'bob@acme.example';

-- ---------- DELETE ----------
DELETE FROM customers
WHERE email = 'carol@globex.example';

SELECT * FROM customers;

-- ============================================================================
-- DANGER ZONE (throwaway learning database ONLY):
-- A DELETE without WHERE wipes ALL rows. We do it here on purpose, on the
-- throwaway DB, and then reset with:  sql/00-reset.sql
-- ============================================================================
DELETE FROM customers;

SELECT count(*) AS remaining_customers FROM customers;
