--EASY--
--1)
SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

--2) Find Products Above Average Price
SELECT id, product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);


--With the sample data, AVG(price) = (1200+400+800+300)/4 = 675 → returns Laptop (1200) and Smartphone (800).

--3) Find Employees in the "Sales" Department

SELECT e.id, e.name
FROM employees AS e
WHERE e.department_id = (
    SELECT d.id
    FROM departments AS d
    WHERE d.department_name = 'Sales'
);

--4)Using NOT IN

SELECT name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

--5) Find Products with Max Price in Each Category
-- returns the product(s) that have the highest price within their category
SELECT p.id, p.product_name, p.price, p.category_id
FROM products AS p
WHERE p.price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
);


(If multiple items tie for max price in a category, they all return.)

--6) Employees in the Department with the Highest Average Salary
WITH dept_avg AS (
    SELECT d.id,
           d.department_name,
           AVG(e.salary) AS avg_salary
    FROM departments d
    JOIN employees  e ON e.department_id = d.id
    GROUP BY d.id, d.department_name
),
top_dept AS (
    SELECT TOP 1 WITH TIES id
    FROM dept_avg
    ORDER BY avg_salary DESC
)
SELECT e.id,
       e.name,
       e.salary,
       e.department_id
FROM employees e
JOIN top_dept td
  ON e.department_id = td.id;

--7) Find Employees Earning Above Department Average

--Retrieve employees earning more than the average salary in their department.

SELECT e.id, e.name, e.salary, e.department_id
FROM employees AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees AS e2
    WHERE e2.department_id = e.department_id
);

--8)

SELECT s.student_id, s.name, g.course_id, g.grade
FROM grades AS g
JOIN students AS s
  ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(g2.grade)
    FROM grades AS g2
    WHERE g2.course_id = g.course_id
);

--9) Third-Highest Price per Category
;WITH ranked AS (
    SELECT
        p.*,
        DENSE_RANK() OVER (PARTITION BY p.category_id
                           ORDER BY p.price DESC) AS rn
    FROM products AS p
)
SELECT id, product_name, price, category_id
FROM ranked
WHERE rn = 3;   -- third-highest within each category



--Returns all products that place 3rd in their category (multiple rows if ties).

--10) Salary > Company Average AND < Department Max
-- company average once
WITH company AS (
    SELECT AVG(CAST(salary AS DECIMAL(18,2))) AS avg_company_salary
    FROM employees
),
dept_max AS (
    SELECT department_id, MAX(salary) AS max_dept_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.id, e.name, e.salary, e.department_id
FROM employees AS e
CROSS JOIN company c
JOIN dept_max d
  ON d.department_id = e.department_id
WHERE e.salary > c.avg_company_salary
  AND e.salary < d.max_dept_salary;
