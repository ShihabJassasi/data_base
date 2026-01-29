PRAGMA foreign_keys = ON;

CREATE TABLE bank_branch (
  branch_id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_address TEXT,
  branch_phone TEXT
);


'
CREATE TABLE customer (
  customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_id INTEGER,
  customer_name TEXT NOT NULL,
  customer_phone TEXT,
  birth_date TEXTCREATE TABLE customer (
  customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_id INTEGER,
  customer_name TEXT NOT NULL,
  customer_phone TEXT,
  birth_date TEXT,
);
'


CREATE TABLE customer (
  customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_id INTEGER,
  customer_name TEXT NOT NULL,
  customer_phone TEXT,
  birth_date TEXT,
  FOREIGN KEY (branch_id) REFERENCES bank_branch(branch_id)
);

CREATE TABLE employee (
  employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
  branch_id INTEGER,
  employee_name TEXT,
  position TEXT,
  hire_date TEXT,
  FOREIGN KEY (branch_id) REFERENCES bank_branch(branch_id)
);




-------------------------------------
PRAGMA foreign_keys = ON;

CREATE TABLE loans (
  loans_id INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  employee_id INTEGER NOT NULL,
  loan_type TEXT,
  issue_date TEXT,
  loan_amout real NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE bank_account (
  account_number INTEGER PRIMARY KEY AUTOINCREMENT,
  customer_id INTEGER NOT NULL,
  account_date TEXT,
  account_type TEXT,
  balance REAL DEFAULT 0,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);




CREATE TABLE transactions (
  transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_number INTEGER NOT NULL,
  date TEXT,
  amount REAL NOT NULL,
  transaction_type TEXT NOT NULL,
  FOREIGN KEY (account_number) REFERENCES bank_account(account_number)
);

CREATE TABLE customer_assist (
  employee_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL,
  action_type TEXT NOT NULL,
  PRIMARY KEY (employee_id, customer_id),
  FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);





-------------------------------
#Dummy_Data

INSERT INTO bank_branch (branch_address, branch_phone) VALUES
('Ibri-Main Street', '24567890'),
('muscat-Main Street', '24567234'),
('Sohar Center', '26881234');

select * from bank_branch;


INSERT INTO employee (branch_id, employee_id, employee_name, position) VALUES
(1, 001, 'Salim', 'Teller'),
(1,002, 'Mona', 'Manager'),
(2,0010, 'Ali', 'customer service'),
(2,0011, 'Fatma', 'Manager'),
(3,0020, 'abdullah', 'Finance'),
(3,0021, 'Arwa', 'Manager');

INSERT INTO loans (customer_id, employee_id, loan_type, issue_date, loan_amount)
SELECT
  c.customer_id,
  e.employee_id,
  'Personal',
  '2026-02-15',
  20000
FROM customer c
JOIN employee e
  ON (c.customer_id % 6) = (
       CASE e.employee_id
         WHEN 1 THEN 0
         WHEN 2 THEN 1
         WHEN 10 THEN 2
         WHEN 11 THEN 3
         WHEN 20 THEN 4
         WHEN 21 THEN 5
       END
     )
WHERE c.customer_id NOT IN (
  SELECT customer_id FROM loans
);


UPDATE employee
SET hire_date = '2024-01-27'
WHERE employee_id = 20;








INSERT INTO customer (branch_id, customer_name, customer_phone, birth_date) VALUES
(1, 'Saud', '91456778', '1999-05-12'),
(2, 'Usama', '9145234', '1999-07-18'),
(3, 'Shihab', '91456732', '1999-04-11'),
(1, 'Fatma', '92345678', '2000-03-20');

INSERT INTO customer (branch_id, customer_name, customer_phone, birth_date) VALUES
(1, 'Ali',      '91200001', '1994-01-15'),
(2, 'Sara',     '91200002', '1995-02-18'),
(3, 'Hassan',   '91200003', '1993-03-22'),
(1, 'Aisha',    '91200004', '1996-04-10'),
(2, 'Khalid',   '91200005', '1992-05-30'),
(3, 'Mona',     '91200006', '1997-06-12'),
(1, 'Yousef',   '91200007', '1995-07-19'),
(2, 'Noor',     '91200008', '1998-08-25'),
(3, 'Abdullah', '91200009', '1991-09-09'),
(1, 'Lina',     '91200010', '1996-10-14'),
(2, 'Omar',     '91200011', '1994-11-21'),
(3, 'Reem',     '91200012', '1997-12-02'),
(1, 'Faisal',   '91200013', '1993-01-07'),
(2, 'Huda',     '91200014', '1998-02-16'),
(3, 'Nasser',   '91200015', '1992-03-11'),
(1, 'Dana',     '91200016', '1999-04-17'),
(2, 'Salma',    '91200017', '1995-05-26'),
(3, 'Majed',    '91200018', '1991-06-30'),
(1, 'Rashid',   '91200019', '1994-07-08'),
(2, 'Amal',     '91200020', '1998-08-19');

select * from customer


INSERT INTO bank_account (account_number,customer_id,account_date,account_type, balance) VALUES
('12344567',1,'2026-01-01', 'Savings', 5000),
('56789076',2,'2026-03-02',  'Current', 200),
('36789877',3,'2026-05-03', 'Savings', 100),
('78908764',4,'2026-07-04',  'Savings', 400);

#Auto_crration:

INSERT INTO bank_account (account_number, customer_id, account_date, account_type, balance)
SELECT
  20000000 + customer_id,
  customer_id,
  DATE('now'),
  'Savings',
  1000
FROM customer
WHERE customer_id NOT IN (
  SELECT customer_id FROM bank_account
);


select * from bank_account

INSERT INTO transactions (account_number, date, amount, transaction_type) VALUES
(12344567, '2026-01-05', 200, 'Deposit'),
(56789076, '2026-01-06', 50,  'Withdraw'),
(36789877, '2026-01-07', 100, 'Deposit'),
(78908764, '2026-01-07', 100, 'Deposit');

#for_each_acount_will _have_deposit&withdraw

INSERT INTO transactions (account_number, date, amount, transaction_type)
SELECT account_number, '2026-01-28', 300, 'Deposit'
FROM bank_account
UNION ALL
SELECT account_number, '2026-01-29', 100, 'Withdraw'
FROM bank_account;

select * from transactions;

INSERT INTO loans (customer_id, employee_id, loan_type, issue_date, loan_amout) VALUES
(1, 2, 'Personal', '2026-01-16', 20000),
(2, 11, 'Personal', '2026-01-18', 12000),
(3, 10, 'Personal', '2026-01-19', 50000),
(4, 1, 'Personal', '2026-01-14', 40000);

INSERT INTO loans (customer_id, employee_id, loan_type, issue_date, loan_amout) VALUES
(5, 2, 'home', '2026-01-16', 200000),
(6, 21, 'Personal', '2026-01-18', 120000),
(7, 10, 'care', '2026-01-19', 500000),
(8, 1, 'Personal', '2026-01-14', 400000),
(9, 2, 'home', '2026-01-16', 20000),
(10, 21, 'Personal', '2026-01-18', 12000),
(11, 10, 'home', '2026-01-19', 50000),
(12, 11, 'car', '2026-01-14', 400000),
(13, 20, 'business', '2026-01-16', 2000000),
(14, 11, 'Personal', '2026-01-18', 102000),
(15, 11, 'business', '2026-01-19', 560000),
(16, 21, 'Personal', '2026-01-14', 480000),
(17, 20, 'Personal', '2026-01-16', 20000),
(18, 11, 'car', '2026-01-18', 182000),
(19, 10, 'business', '2026-01-19', 580000),
(20, 21, 'Personal', '2026-01-14', 408000),
(21, 20, 'car', '2026-01-16', 200800),
(22, 21, 'business', '2026-01-18', 128000),
(23, 10, 'Personal', '2026-01-19', 5670000),
(24, 11, 'business', '2026-01-14', 470000);


 select * from loans;
  


INSERT INTO customer_assist (employee_id, customer_id, action_type)
SELECT
  CASE (c.customer_id % 6)
    WHEN 1 THEN 1
    WHEN 2 THEN 2
    WHEN 3 THEN 10
    WHEN 4 THEN 11
    WHEN 5 THEN 20
    ELSE 21
  END AS employee_id,
  c.customer_id,
  CASE (c.customer_id % 4)
    WHEN 1 THEN 'Account Opening'
    WHEN 2 THEN 'Customer Support'
    WHEN 3 THEN 'Account Update'
    ELSE 'Loan Consultation'
  END AS action_type
FROM customer c
WHERE c.customer_id IN (
  SELECT customer_id
  FROM customer
  ORDER BY customer_id
  LIMIT 24
);


SELECT * FROM customer_assist;


