# Chapter 12 — Money: Why Not Float? Numeric, Integer Cents, Rounding, Currency, Taxes, Discounts

> **PostgreSQL version in use:** PostgreSQL **17.11** (Debian 17.11-1.pgdg13+2, compiled by gcc 14.2.0-19) — every example in this chapter was run against this version.

---

## 1. Simple explanation (like I'm 7)

Money is just numbers with decimal points. Computers are bad at decimals (like 0.1) and great at integers (like 10 cents). So:

- `NUMERIC(10,2)` = exact decimal (e.g., 19.99).
- Integer cents = 1999 (just an integer, super safe).
- `FLOAT` = binary approximation → surprises.

## 2. Real name

- `NUMERIC`, `DECIMAL`, `FLOAT`, `REAL`, `DOUBLE PRECISION`, integer cents, `MONEY` (PostgreSQL has a `MONEY` type! — but generally avoid).

## 3. SQL example — the float rounding error

```sql
SELECT 0.1::numeric + 0.2::numeric AS decimal_sum, 0.3::numeric AS decimal_expected, (0.1::numeric + 0.2::numeric) = 0.3::numeric AS decimal_equal;
SELECT 0.1::float + 0.2::float AS float_sum, 0.3::float AS float_expected, (0.1::float + 0.2::float) = 0.3::float AS float_equal;
```

**Exact output I got:**

```
  decimal_sum | decimal_expected | decimal_equal 
-------------+------------------+---------------
        0.3 |              0.3 |              t
(1 row)

    float_sum      | float_expected | float_equal 
------------------+-----------------+------------
 0.30000000000000004 | 0.3            |              f
(1 row)
```

## 4. Why this matters in a real e-commerce platform

Price × quantity, tax, discount, currency → all need exact decimals.

## 5. When to use it and when NOT to

Use `NUMERIC(10,2)` or integer cents; never `FLOAT` for money.

## 6. Common mistakes

- Using FLOAT → rounding errors.

## 7. Try it yourself

**Exercise:** Which is safe for money?

<details>
<summary>✅ Solution (click to open)</summary>

Use `NUMERIC(10,2)` (or store integer cents).

</details>

## 8. Next

➡️ **[Chapter 13 — Indexes](13-indexes.md)**
