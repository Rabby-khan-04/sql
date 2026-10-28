-- ============================================================================
-- Chapter 15: Transactions — BEGIN, COMMIT, ROLLBACK, FOR UPDATE
-- ============================================================================
BEGIN;
UPDATE products SET stock = stock - 1 WHERE name = 'Acme Racer Bike';
SELECT stock FROM products WHERE name = 'Acme Racer Bike';
COMMIT;

-- ROLLBACK demo
BEGIN;
UPDATE products SET stock = stock - 1 WHERE name = 'Acme Racer Bike';
ROLLBACK;
SELECT stock FROM products WHERE name = 'Acme Racer Bike';

-- FOR UPDATE demo (race condition)
BEGIN;
SELECT * FROM products WHERE name = 'Acme Racer Bike' FOR UPDATE;
COMMIT;