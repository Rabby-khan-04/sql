-- ============================================================================
-- Chapter 12: Money — numeric vs float rounding demo
-- ============================================================================
SELECT 0.1::numeric + 0.2::numeric AS decimal_sum, 0.3::numeric AS decimal_expected, (0.1::numeric + 0.2::numeric) = 0.3::numeric AS decimal_equal;
SELECT 0.1::float + 0.2::float AS float_sum, 0.3::float AS float_expected, (0.1::float + 0.2::float) = 0.3::float AS float_equal;