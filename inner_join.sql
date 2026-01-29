#department_table

CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
)
--------------------

#employee_table
 CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department_id INT NULL,
    salary DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_employees_department
      FOREIGN KEY (department_id) REFERENCES departments(id)
);

--------------------

#project_table

CREATE TABLE projects (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INT NULL,
    budget DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_projects_department
      FOREIGN KEY (department_id) REFERENCES departments(id)
);

...........................................................................
#Dummy_Data

INSERT INTO departments (id, name, location) VALUES
(1, 'Sales', 'New York'),
(2, 'IT', 'Chicago'),
(3, 'HR', 'Boston'),
(4, 'Marketing', 'Seattle');

INSERT INTO employees (id, name, department_id, salary) VALUES
(101, 'John Smith', 1, 60000),
(102, 'Sarah Johnson', 2, 75000),
(103, 'Mike Davis', 2, 70000),
(104, 'Lisa Brown', 1, 55000),
(105, 'Tom Wilson', 3, 65000),
(106, 'Emma Taylor', NULL, 50000);


INSERT INTO projects (id, name, department_id, budget) VALUES
(201, 'Website Redesign', 2, 100000),
(202, 'Sales Campaign', 1, 50000),
(203, 'HR System', 3, 75000),
(204, 'Mobile App', NULL, 120000);

.............................................
#date_test
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM projects;
.....................................

#Task 1.1: INNER_JOIN

.1)
SELECT e.name AS employee_name,
       d.name AS department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

.2)
SELECT e.name AS employee_name,
       d.location AS department_location
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

SELECT * FROM departments;
SELECT * FROM employees;

.3)
SELECT p.name AS project_name,
       d.name AS department_name
FROM projects p
INNER JOIN departments d ON p.department_id = d.id;

.4)
SELECT e.name AS employee_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
WHERE d.name = 'Sales';

.5)
SELECT e.name AS employee_name, e.salary,
       d.name AS department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
WHERE e.salary > 60000;


#Task 1.2 — Aliases

.6,7)
SELECT p.name AS project_name, p.budget, d.location
FROM projects p
INNER JOIN departments d ON p.department_id = d.id;


#task 2: More_Join_Types 
.left_join
.8)
SELECT e.name AS employee_name,
       d.name AS department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;

.9)
SELECT d.name AS department_name,
       p.name AS project_name
FROM departments d
LEFT JOIN projects p ON d.id = p.department_id;

.10)
SELECT e.name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
WHERE d.id IS NULL;

SELECT * FROM employees;

.11)
SELECT d.name AS department_name,
       COUNT(e.id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.name;



#task3: Subqueries

.15)
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

.16)
SELECT name, salary
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees);

.17)
SELECT name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);


.18)
SELECT name, budget
FROM projects
WHERE budget > (SELECT AVG(budget) FROM projects);

#Task 3.2 – Subqueries

.19)
SELECT name
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Chicago'
);


.20)
SELECT name
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM projects
    WHERE department_id IS NOT NULL
);

.21)
SELECT name
FROM projects
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE location = 'Boston'
);

.22)
SELECT name
FROM departments
WHERE id NOT IN (
    SELECT department_id
    FROM projects
    WHERE department_id IS NOT NULL
);


#Task 4: Practice & Review 
.23)
SELECT e.name AS employee_name,
       e.salary,
       d.name AS department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.id;



.24)
SELECT e.name,
       e.salary,
       d.location
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
WHERE e.salary > 65000;


.25)
SELECT p.name AS project_name,
       p.budget,
       d.name AS department_name
FROM projects p
LEFT JOIN departments d
ON p.department_id = d.id
WHERE p.budget > 80000;


.26)
SELECT e.name, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    INNER JOIN departments d
    ON e2.department_id = d.id
    WHERE d.name = 'IT'
);


.27)
SELECT DISTINCT d.name AS department_name
FROM departments d
INNER JOIN employees e
ON d.id = e.department_id
WHERE e.salary > 70000;


#Reall-World Scenarios

.28)
SELECT e.name,
       d.name AS department_name,
       d.location
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.id;




.29)
SELECT d.name AS department_name,
       COUNT(e.id) AS employee_count,
       SUM(e.salary) AS total_salary
FROM departments d
LEFT JOIN employees e
ON d.id = e.department_id
GROUP BY d.name;


.30)
SELECT d.name AS department_name,
       AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e
ON d.id = e.department_id
GROUP BY d.name
ORDER BY avg_salary DESC
LIMIT 1;



.31)
SELECT p.name
FROM projects p
WHERE p.department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) > 1
);



.32)
SELECT name
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE name = 'John Smith'
);



