--task1
-- Bitta xodim uchun:
SELECT CONCAT(emp_id, '-', first_name, ' ', last_name) AS EmpLabel
FROM employees
WHERE emp_id = 100;

-- Barchasi uchun (umumiy):
SELECT CONCAT(emp_id, '-', first_name, ' ', last_name) AS EmpLabel
FROM employees;

--task2
UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999')
WHERE phone_number LIKE '%124%';

--task3
SELECT
  first_name,
  LEN(first_name) AS first_name_length
FROM employees
WHERE first_name LIKE 'A%' 
   OR first_name LIKE 'J%' 
   OR first_name LIKE 'M%'
ORDER BY first_name;

--task4
SELECT
  manager_id,
  SUM(salary) AS total_salary
FROM employees
GROUP BY manager_id
ORDER BY manager_id;

--task5
SELECT t.[Year],
       MAX(v.val) AS HighestValue
FROM TestMax AS t
CROSS APPLY (VALUES (t.Max1), (t.Max2), (t.Max3)) AS v(val)
GROUP BY t.[Year]
ORDER BY t.[Year];

--task6
SELECT *
FROM cinema
WHERE (id % 2) = 1
  AND (description IS NULL OR description <> 'boring');

--task7
SELECT *
FROM SingleOrder
ORDER BY
  CASE WHEN Id = 0 THEN 1 ELSE 0 END,  -
  Id;                                   

--task8
SELECT
  COALESCE(col1, col2, col3 /* , … */) AS first_non_null
FROM person;

--MEDIUM

