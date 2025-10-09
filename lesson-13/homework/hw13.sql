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
--task1
SELECT
  PARSENAME(REPLACE(FullName,' ','.'), 3) AS FirstName,
  PARSENAME(REPLACE(FullName,' ','.'), 2) AS MiddleName,
  PARSENAME(REPLACE(FullName,' ','.'), 1) AS LastName
FROM Students;

--task2
SELECT o.*
FROM Orders AS o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
        SELECT 1
        FROM Orders AS oc
        WHERE oc.CustomerID   = o.CustomerID
          AND oc.DeliveryState = 'CA'
      );
--task3
SELECT
  KeyCol,
  STRING_AGG(ValueCol, ',') WITHIN GROUP (ORDER BY ValueCol) AS ConcatenatedValues
FROM DMLTable
GROUP BY KeyCol;
--task4
SELECT *
FROM Employees
WHERE (
   LEN(LOWER(first_name + last_name))
 - LEN(REPLACE(LOWER(first_name + last_name), 'a', ''))
) >= 3;
--task5

--HARD
--task1
SELECT
  StudentID,
  Score + COALESCE(LAG(Score) OVER(ORDER BY StudentID), 0) AS NewScore
FROM Students
ORDER BY StudentID;
--task 2
SELECT BirthDate,
       STRING_AGG(FullName, ', ') AS Students
FROM Students
GROUP BY BirthDate
HAVING COUNT(*) > 1;

--task 3
