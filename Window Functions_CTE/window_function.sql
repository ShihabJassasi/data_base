#create_tables
PRAGMA foreign_keys = ON;

CREATE TABLE customers (
  customer_id   INT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  city          TEXT NOT NULL
);

CREATE TABLE customer (
  customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_id INTEGER,
  customer_name TEXT NOT NULL,
  customer_phone TEXT,
  birth_date TEXT,
  FOREIGN KEY (branch_id) REFERENCES bank_branch(branch_id)
);


CREATE TABLE orders (
  order_id     INT PRIMARY KEY,
  customer_id  INT NOT NULL REFERENCES customers(customer_id),
  order_date   DATE NOT NULL,
  amount       NUMERIC(10,2) NOT NULL
);


#Insert_sample_data

INSERT INTO customers (customer_id, customer_name, city) VALUES
(1, 'Aisha',  'Muscat'),
(2, 'Omar',   'Muscat'),
(3, 'Mariam', 'Sohar'),
(4, 'Salim',  'Nizwa');

INSERT INTO orders (order_id, customer_id, order_date, amount) VALUES
(101, 1, '2026-01-03', 120.00),
(102, 1, '2026-01-10',  80.00),
(103, 1, '2026-01-20', 200.00),
(104, 2, '2026-01-05',  60.00),
(105, 2, '2026-01-12',  90.00),
(106, 3, '2026-01-07', 150.00),
(107, 3, '2026-01-21',  50.00),
(108, 4, '2026-01-08',  40.00);


#practice_Window_Functions

SELECT customer_id, order_id, order_date, amount,
  SUM(amount) OVER ( PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders
; 


SELECT
  customer_id,
  order_id,
  amount,
  SUM(amount) OVER (PARTITION BY customer_id) AS customer_total
FROM orders
;

#CTE:

WITH customer_totals AS (
  SELECT
    customer_id,
    SUM(amount) AS total_spent
  FROM orders
  GROUP BY customer_id
)
SELECT
  c.customer_name,
  ct.total_spent
FROM customer_totals ct
JOIN customers c ON c.customer_id = ct.customer_id
WHERE ct.total_spent > 200
;

