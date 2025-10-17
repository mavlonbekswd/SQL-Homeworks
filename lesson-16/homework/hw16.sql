--Easy Tasks
--1) Numbers table 1→1000 (recursive)
;WITH N AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM N WHERE n < 1000
)
SELECT n
INTO dbo.Numbers_1_to_1000
FROM N
OPTION (MAXRECURSION 0);

--2) Total sales per employee (derived table)
SELECT  e.EmployeeID,
        e.FirstName,
        e.LastName,
        ISNULL(s.TotalSales,0) AS TotalSales
FROM Employees e
LEFT JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) s ON s.EmployeeID = e.EmployeeID
ORDER BY TotalSales DESC, e.EmployeeID;

--3) Average salary (CTE)
;WITH A AS (
    SELECT AVG(CAST(Salary AS DECIMAL(18,2))) AS AvgSalary
    FROM Employees
)
SELECT AvgSalary FROM A;

--4) Highest sale for each product (derived table)
SELECT  p.ProductID,
        p.ProductName,
        d.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) d ON d.ProductID = p.ProductID
ORDER BY p.ProductID;

--5) Start at 1 and keep doubling until < 1,000,000 (recursive)
;WITH D AS (
    SELECT CAST(1 AS BIGINT) AS v
    UNION ALL
    SELECT v * 2 FROM D WHERE v * 2 < 1000000
)
SELECT v FROM D
OPTION (MAXRECURSION 0);

--6) Employees who made > 5 sales (CTE)
;WITH S AS (
    SELECT EmployeeID, COUNT(*) AS Cnt
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName, S.Cnt
FROM S
JOIN Employees e ON e.EmployeeID = S.EmployeeID
WHERE S.Cnt > 5
ORDER BY S.Cnt DESC, e.EmployeeID;

--7) Products that have a sale > $500 (CTE)
;WITH P AS (
    SELECT DISTINCT ProductID
    FROM Sales
    WHERE SalesAmount > 500
)
SELECT pr.ProductID, pr.ProductName, pr.Price
FROM Products pr
JOIN P ON P.ProductID = pr.ProductID
ORDER BY pr.ProductID;

--8) Employees with salary above average (CTE)
;WITH A AS (SELECT AVG(Salary) AS AvgSal FROM Employees)
SELECT e.*
FROM Employees e
CROSS JOIN A
WHERE e.Salary > A.AvgSal
ORDER BY e.Salary DESC;

--Medium Tasks
--1) Top 5 employees by number of orders (derived table)
SELECT TOP (5)
       e.EmployeeID, e.FirstName, e.LastName, x.OrderCount
FROM (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) x
JOIN Employees e ON e.EmployeeID = x.EmployeeID
ORDER BY x.OrderCount DESC, e.EmployeeID;

--2) Sales per product category (derived table)
SELECT  p.CategoryID,
        SUM(s.SalesAmount) AS TotalSales
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
GROUP BY p.CategoryID
ORDER BY p.CategoryID;

--3) Factorial for each entry in Numbers1 (recursive)
;WITH R AS (
    SELECT Number, CAST(1 AS DECIMAL(38,0)) AS Fact, 0 AS i
    FROM Numbers1
    UNION ALL
    SELECT Number, Fact * (i + 1), i + 1
    FROM R
    WHERE i < Number
)
SELECT Number, MAX(Fact) AS Factorial
FROM R
GROUP BY Number
ORDER BY Number
OPTION (MAXRECURSION 0);

--4) Split each string into one row per character (recursive, Example)
;WITH C AS (
    SELECT Id, String, 1 AS pos, SUBSTRING(String,1,1) AS ch
    FROM Example
    UNION ALL
    SELECT Id, String, pos+1, SUBSTRING(String,pos+1,1)
    FROM C
    WHERE pos < LEN(String)
)
SELECT Id, pos, ch
FROM C
ORDER BY Id, pos
OPTION (MAXRECURSION 0);

--5) Monthly sales difference vs previous month (CTE + LAG)
;WITH M AS (
    SELECT EOMONTH(SaleDate) AS MonthEnd,
           SUM(SalesAmount)  AS TotalSales
    FROM Sales
    GROUP BY EOMONTH(SaleDate)
)
SELECT  MonthEnd,
        TotalSales,
        TotalSales - LAG(TotalSales) OVER (ORDER BY MonthEnd) AS DiffFromPrev
FROM M
ORDER BY MonthEnd;

--6) Employees with quarterly sales > $45,000 (derived table)
SELECT  e.EmployeeID, e.FirstName, e.LastName,
        X.[Year], X.[Quarter], X.QuarterSales
FROM (
    SELECT EmployeeID,
           YEAR(SaleDate) AS [Year],
           DATEPART(QUARTER, SaleDate) AS [Quarter],
           SUM(SalesAmount) AS QuarterSales
    FROM Sales
    GROUP BY EmployeeID, YEAR(SaleDate), DATEPART(QUARTER, SaleDate)
) X
JOIN Employees e ON e.EmployeeID = X.EmployeeID
WHERE X.QuarterSales > 45000
ORDER BY X.[Year], X.[Quarter], X.QuarterSales DESC;

--Difficult Tasks
-1) Fibonacci (first 20 numbers; adjust WHERE n < 20 to your need)
;WITH F AS (
    SELECT 1 AS n, CAST(0 AS BIGINT) AS a, CAST(1 AS BIGINT) AS b
    UNION ALL
    SELECT n + 1, b, a + b
    FROM F
    WHERE n < 20
)
SELECT n, a AS Fibonacci
FROM F
ORDER BY n
OPTION (MAXRECURSION 0);

--2) Rows where all characters are the same and length > 1

(FindSameCharacters)

SELECT Id, Vals
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(REPLACE(Vals, LEFT(Vals,1), '')) = 0;  -- everything is that 1st char

--3) Produce: 1, 12, 123, … up to n (say @n = 5)
DECLARE @n int = 5;

;WITH C AS (
    SELECT 1 AS i, CAST('1' AS VARCHAR(100)) AS s
    UNION ALL
    SELECT i + 1, s + CAST(i + 1 AS VARCHAR(10))
    FROM C
    WHERE i < @n
)
SELECT s
FROM C
ORDER BY i
OPTION (MAXRECURSION 0);

--4) Employees with the most sales in the last 6 months (derived table)
;WITH MaxD AS (SELECT MAX(SaleDate) AS MaxSaleDate FROM Sales),
Win AS (
    SELECT  s.EmployeeID,
            SUM(s.SalesAmount) AS Last6MoSales
    FROM Sales s
    CROSS JOIN MaxD m
    WHERE s.SaleDate >= DATEADD(MONTH, -6, m.MaxSaleDate)
    GROUP BY s.EmployeeID
),
TopAmt AS (SELECT MAX(Last6MoSales) AS Mx FROM Win)
SELECT  e.EmployeeID, e.FirstName, e.LastName, w.Last6MoSales
FROM Win w
JOIN TopAmt t  ON w.Last6MoSales = t.Mx
JOIN Employees e ON e.EmployeeID = w.EmployeeID
ORDER BY e.EmployeeID;

--5) Clean RemoveDuplicateIntsFromNames

--Goal: compress repeated digits (e.g., 1111 → 1, 4444 → 4) and remove a trailing -X when only a single digit remains.

-- 1) Split each string into positions
;WITH Positions AS (
    SELECT r.PawanName,
           r.Pawan_slug_name,
           v.number AS pos,
           SUBSTRING(r.Pawan_slug_name, v.number, 1) AS ch
    FROM RemoveDuplicateIntsFromNames r
    JOIN master..spt_values v
      ON v.type = 'P' AND v.number BETWEEN 1 AND LEN(r.Pawan_slug_name)
),
-- 2) Keep char if (a) it's not a digit OR (b) it's a digit and not the same as previous char
Dedup AS (
    SELECT  PawanName,
            pos,
            ch,
            CASE
              WHEN ch LIKE '[0-9]'
                   AND ch = LAG(ch) OVER (PARTITION BY PawanName ORDER BY pos)
              THEN ''         -- drop repeated digit
              ELSE ch
            END AS keep_ch
    FROM Positions
),
-- 3) Rebuild the compressed string
Rebuilt AS (
    SELECT  d.PawanName,
            (
              SELECT '' + keep_ch
              FROM Dedup d2
              WHERE d2.PawanName = d.PawanName
              ORDER BY d2.pos
              FOR XML PATH(''), TYPE
            ).value('.','varchar(1000)') AS Compressed
    FROM Dedup d
    GROUP BY d.PawanName
)
-- 4) If the trailing part after '-' is exactly one digit, drop the '-X'
SELECT  r.PawanName,
        r.Pawan_slug_name AS OriginalValue,
        CASE
          WHEN CHARINDEX('-', Rebuilt.Compressed) > 0
           AND LEN(SUBSTRING(Rebuilt.Compressed, CHARINDEX('-', Rebuilt.Compressed) + 1, 8000)) = 1
          THEN LEFT(Rebuilt.Compressed, CHARINDEX('-', Rebuilt.Compressed) - 1)
          ELSE Rebuilt.Compressed
        END AS CleanedValue
FROM RemoveDuplicateIntsFromNames r
JOIN Rebuilt ON Rebuilt.PawanName = r.PawanName
ORDER BY r.PawanName;
