-- EASY --

--1) 
SELECT
    Id,
    LTRIM(RTRIM(SUBSTRING(Name, 1, CHARINDEX(',', Name) - 1)))  AS FirstName,
    LTRIM(RTRIM(SUBSTRING(Name, CHARINDEX(',', Name) + 1, 8000))) AS LastName
FROM TestMultipleColumns;

--2) Rows where the string itself contains a % (TestPercent)
-- Either way works; pick one

-- Using LIKE with an escape pattern:
SELECT *
FROM TestPercent
WHERE Strs LIKE '%[%]%';

-- Or using CHARINDEX:
-- SELECT * FROM TestPercent WHERE CHARINDEX('%', Strs) > 0;

--3) Split a string by dot . (Splitter)
a) Into rows (one token per row, in input order)
SELECT s.Id,
       v.[value]        AS token,
       v.ordinal        AS token_ordinal
FROM Splitter AS s
CROSS APPLY STRING_SPLIT(s.Vals, '.', 1) AS v;   -- requires SQL Server 2022/2019 CU12+ for 'ordinal'

b) Into columns (first two pieces; everything after the first dot goes to RightPart)
SELECT
  Id,
  LEFT(Vals, CHARINDEX('.', Vals+'.')-1)                                                   AS LeftPart,
  STUFF(Vals, 1, CHARINDEX('.', Vals+'.'), '')                                             AS RightPart
FROM Splitter;

--4) Rows where Vals has more than two dots (testDots)
SELECT *
FROM testDots
WHERE (LEN(Vals) - LEN(REPLACE(Vals, '.', ''))) > 2;

--5) Count spaces in each string (CountSpaces)
SELECT
    texts,
    (LEN(texts) - LEN(REPLACE(texts, ' ', ''))) AS SpaceCount
FROM CountSpaces;

--6) Employees who earn more than their managers (Employee)
SELECT e.Name AS Employee, e.Salary, m.Name AS Manager, m.Salary AS ManagerSalary
FROM Employee e
JOIN Employee m ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;

--7) Employees with tenure > 10 and < 15 years (Employees)

--(Shows ID, First, Last, Hire Date, and exact whole years of service.)

WITH Tenure AS (
  SELECT
      EMPLOYEE_ID,
      FIRST_NAME,
      LAST_NAME,
      HIRE_DATE,
      /* whole-year tenure (doesn't overcount if anniversary not reached) */
      DATEDIFF(YEAR, HIRE_DATE, GETDATE())
        - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HIRE_DATE, GETDATE()), HIRE_DATE) > GETDATE()
               THEN 1 ELSE 0 END AS YearsOfService
  FROM Employees
)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, YearsOfService
FROM Tenure
WHERE YearsOfService > 10 AND YearsOfService < 15
ORDER BY EMPLOYEE_ID;

--MEDIUM--

--1) Dates whose temperature is higher than yesterday’s (weather)

--Return the Id (you can also add the date if you want).

SELECT Id  -- , RecordDate
FROM (
  SELECT w.*,
         LAG(Temperature) OVER (ORDER BY RecordDate) AS prev_temp
  FROM weather w
) x
WHERE Temperature > prev_temp;

--2) First login date for each player (Activity)
SELECT player_id, MIN(event_date) AS first_login_date
FROM Activity
GROUP BY player_id;

--3) Return the third item from the list (fruits)
-- apple(1), banana(2), orange(3), grape(4)
SELECT PARSENAME(REPLACE(fruit_list, ',', '.'), 2) AS third_item
FROM fruits;

--4) Employment Stage by HIRE_DATE (Employees)
WITH Tenure AS (
  SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE,
         /* whole years of service (no overcount before anniversary) */
         DATEDIFF(YEAR, HIRE_DATE, GETDATE())
           - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HIRE_DATE, GETDATE()), HIRE_DATE) > GETDATE()
                  THEN 1 ELSE 0 END AS YearsOfService
  FROM Employees
)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, YearsOfService,
       CASE
         WHEN YearsOfService < 1  THEN 'New Hire'
         WHEN YearsOfService < 5  THEN 'Junior'
         WHEN YearsOfService < 10 THEN 'Mid-Level'
         WHEN YearsOfService < 20 THEN 'Senior'
         ELSE 'Veteran'
       END AS EmploymentStage
FROM Tenure
ORDER BY EMPLOYEE_ID;

--5) Extract the leading integer from GetIntegers.VALS
SELECT Id,
       CASE
         WHEN VALS LIKE '[0-9]%'    -- starts with a digit?
           THEN CAST(LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'X') - 1) AS INT)
         ELSE NULL
       END AS leading_int
FROM GetIntegers;

--DIFFICULT TASKS
--1) Swap the first two tokens of a comma-separated string (MultipleVals)

--a,b,c → b,a,c

SELECT mv.Id,
       CONCAT(t2.token, ',', t1.token, t.tail) AS swapped
FROM MultipleVals mv
CROSS APPLY (
  SELECT CHARINDEX(',', mv.Vals) AS pos1
) p
CROSS APPLY (
  SELECT CASE WHEN p.pos1 > 0 THEN LEFT(mv.Vals, p.pos1-1) ELSE mv.Vals END AS token,
         CASE WHEN p.pos1 > 0 THEN SUBSTRING(mv.Vals, p.pos1+1, 8000) ELSE '' END AS rest
) t1
CROSS APPLY (
  SELECT CHARINDEX(',', t1.rest) AS pos2
) p2
CROSS APPLY (
  SELECT CASE WHEN p2.pos2 > 0 THEN LEFT(t1.rest, p2.pos2-1) ELSE t1.rest END AS token,
         CASE WHEN p2.pos2 > 0 THEN SUBSTRING(t1.rest, p2.pos2, 8000) ELSE '' END AS tail
) t2;

--2) Split a string into rows (each character → one row)

--(use any input string; here’s an example variable)

DECLARE @s varchar(200) = 'sdgfhsdgfhs@121313131';

;WITH n AS (
  SELECT TOP (LEN(@s))
         ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS n
  FROM sys.all_objects
)
SELECT n AS position,
       SUBSTRING(@s, n, 1) AS ch
FROM n
ORDER BY n;

--3) Device of the first login for each player (Activity)
SELECT a.player_id, a.device_id, a.event_date AS first_login_date
FROM Activity a
JOIN (
  SELECT player_id, MIN(event_date) AS first_login_date
  FROM Activity
  GROUP BY player_id
) m
  ON a.player_id = m.player_id
 AND a.event_date = m.first_login_date
-- If multiple devices on the same first day, pick the smallest device_id:
-- QUALIFY ROW_NUMBER() OVER (PARTITION BY a.player_id ORDER BY a.device_id) = 1  -- (Azure SQL / Synapse)
-- For boxed SQL Server use APPLY instead:
-- OUTER APPLY (SELECT TOP(1) device_id FROM Activity aa
--              WHERE aa.player_id = a.player_id AND aa.event_date = m.first_login_date
--              ORDER BY device_id) pick
-- and select pick.device_id
;


--A very clean alternative with APPLY:

SELECT p.player_id, x.device_id, x.event_date AS first_login_date
FROM (SELECT DISTINCT player_id FROM Activity) p
CROSS APPLY (
  SELECT TOP (1) device_id, event_date
  FROM Activity a
  WHERE a.player_id = p.player_id
  ORDER BY event_date, device_id
) x;

--4) Split a mixed string into letters and digits columns

--Example input: 'rtcfvty34redt'

DECLARE @s varchar(100) = 'rtcfvty34redt';

;WITH n AS (
  SELECT TOP (LEN(@s))
         ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS n
  FROM sys.all_objects
),
chars AS (
  SELECT SUBSTRING(@s, n, 1) AS ch
  FROM n
)
SELECT
  STRING_AGG(CASE WHEN ch LIKE '[0-9]' THEN ch END, '') AS Digits,
  STRING_AGG(CASE WHEN ch LIKE '[A-Za-z]' THEN ch END, '') AS Letters;
