-- ============================================================================
-- Chapter 14: EXPLAIN and EXPLAIN ANALYZE
-- ============================================================================
EXPLAIN SELECT * FROM orders WHERE customer_id = '546592e4-5a3b-4d06-a3c5-aabbfcfe848d';
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = '546592e4-5a3b-4d06-a3c5-aabbfcfe848d';