-- ============================================================================
-- Chapter 7: Joins (INNER, LEFT, RIGHT, FULL, CROSS, self, many-to-many)
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/07-joins.sql
--
-- Introduces the e-commerce tables needed for join demos:
--   products, orders, order_items (the "join table" for orders <-> products)

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    name TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(10,2) NOT NULL
);

INSERT INTO products (tenant_id, name, price, stock) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Acme Racer Bike', 499.99, 5),
    ('11111111-1111-1111-1111-111111111111', 'Acme Helmet',    49.99, 20),
    ('22222222-2222-2222-2222-222222222222', 'Globex Rocket',  199.99, 8);

INSERT INTO orders (tenant_id, customer_id, status) VALUES
    ('11111111-1111-1111-1111-111111111111', '546592e4-5a3b-4d06-a3c5-aabbfcfe848d', 'shipped'),
    ('11111111-1111-1111-1111-111111111111', '546592e4-5a3b-4d06-a3c5-aabbfcfe848d', 'pending'),
    ('11111111-1111-1111-1111-111111111111', 'a93d3381-496e-4f1e-8518-546b1ef286a2', 'pending'),
    ('22222222-2222-2222-2222-222222222222', '3de36e69-f77e-47a4-9035-a524e0935878', 'pending'),
    ('22222222-2222-2222-2222-222222222222', '99999999-9999-9999-9999-999999999999', 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.id, p.id, 1, p.price
FROM orders o
JOIN products p ON p.tenant_id = o.tenant_id
WHERE o.status = 'shipped';

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.id, p.id, 2, p.price
FROM orders o
JOIN products p ON p.tenant_id = o.tenant_id
WHERE o.status = 'pending';

-- INNER JOIN: orders with their customer
SELECT o.id AS order_id, c.full_name, c.email, o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;

-- LEFT JOIN: customers with their orders (Carol has none -> NULLs)
SELECT c.full_name, o.status
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;

-- FULL JOIN: both sides
SELECT o.id AS order_id, c.full_name
FROM orders o
FULL JOIN customers c ON o.customer_id = c.id;

-- CROSS JOIN
SELECT c.email, t.name AS tenant_name
FROM customers c
CROSS JOIN tenants t;

-- SELF JOIN: two orders by the same customer (Alice)
SELECT c1.full_name, o1.id AS order_1, o2.id AS order_2
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id AND o1.id <> o2.id;

-- MANY-TO-MANY: order_items joins orders and products
SELECT o.id AS order_id, p.name AS product_name, oi.quantity, oi.unit_price
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.id
INNER JOIN products p ON oi.product_id = p.id;
```

Note: the self join needs an alias for customers? I wrote c1/c2 but only joined orders... let me fix: use `SELECT o1.id AS order_1, o2.id AS order_2 FROM orders o1 JOIN orders o2 ON ...` without customer name. I'll fix before running.

Let me rewrite the file properly and run it.</think>Let me fix and run the Chapter 7 SQL file:<tool_call>write<arg_key>content</arg_key><arg_value>-- ============================================================================
-- Chapter 7: Joins (INNER, LEFT, RIGHT, FULL, CROSS, self, many-to-many)
-- ============================================================================
-- Run with:
--   docker exec -i sql-learn psql -U postgres -d learn_shop -f - < sql/07-joins.sql
--
-- Introduces the e-commerce tables needed for join demos:
--   products, orders, order_items (the "join table" for orders <-> products)

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    name TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(10,2) NOT NULL
);

INSERT INTO products (tenant_id, name, price, stock) VALUES
    ('11111111-1111-1111-1111-111111111111', 'Acme Racer Bike', 499.99, 5),
    ('11111111-1111-1111-1111-111111111111', 'Acme Helmet',    49.99, 20),
    ('22222222-2222-2222-2222-222222222222', 'Globex Rocket',  199.99, 8);

INSERT INTO orders (tenant_id, customer_id, status) VALUES
    ('11111111-1111-1111-1111-111111111111', '546592e4-5a3b-4d06-a3c5-aabbfcfe848d', 'shipped'),
    ('11111111-1111-1111-1111-111111111111', '546592e4-5a3b-4d06-a3c5-aabbfcfe848d', 'pending'),
    ('11111111-1111-1111-1111-111111111111', 'a93d3381-496e-4f1e-8518-546b1ef286a2', 'pending'),
    ('22222222-2222-2222-2222-222222222222', '3de36e69-f77e-47a4-9035-a524e0935878', 'pending'),
    ('22222222-2222-2222-2222-222222222222', '99999999-9999-9999-9999-999999999999', 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.id, p.id, 1, p.price
FROM orders o
JOIN products p ON p.tenant_id = o.tenant_id
WHERE o.status = 'shipped';

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.id, p.id, 2, p.price
FROM orders o
JOIN products p ON p.tenant_id = o.tenant_id
WHERE o.status = 'pending';

-- INNER JOIN: orders with their customer
SELECT o.id AS order_id, c.full_name, c.email, o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;

-- LEFT JOIN: customers with their orders (Carol has none -> NULLs)
SELECT c.full_name, o.status
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;

-- FULL JOIN: both sides
SELECT o.id AS order_id, c.full_name
FROM orders o
FULL JOIN customers c ON o.customer_id = c.id;

-- CROSS JOIN
SELECT c.email, t.name AS tenant_name
FROM customers c
CROSS JOIN tenants t;

-- SELF JOIN: two orders by the same customer (Alice)
SELECT o1.id AS order_1, o2.id AS order_2
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id AND o1.id <> o2.id;

-- MANY-TO-MANY: order_items joins orders and products
SELECT o.id AS order_id, p.name AS product_name, oi.quantity, oi.unit_price
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.id
INNER JOIN products p ON oi.product_id = p.id;
