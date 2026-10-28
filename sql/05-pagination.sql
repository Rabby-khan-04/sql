-- ============================================================================
-- Chapter 5: Pagination — OFFSET vs keyset
-- ============================================================================
SELECT email, full_name, created_at
FROM customers
ORDER BY created_at DESC
LIMIT 2 OFFSET 0;

SELECT email, full_name, created_at
FROM customers
ORDER BY created_at DESC
LIMIT 2 OFFSET 2;

SELECT email, full_name, created_at
FROM customers
ORDER BY created_at DESC
LIMIT 10 OFFSET 20;

SELECT email, full_name, created_at
FROM customers
WHERE created_at < '2026-10-28 09:00:00+00'
ORDER BY created_at DESC
LIMIT 2;
