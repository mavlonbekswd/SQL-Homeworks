-- 1
SELECT SaleID, ProductName, SaleDate, 
       ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

-- 2
SELECT ProductName, SUM(Quantity) AS TotalQuantity,
       RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankNumber
FROM ProductSales
GROUP BY ProductName;

-- 3
SELECT CustomerID, ProductName, SaleAmount
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) AS t
WHERE rn = 1;

-- 4
SELECT SaleID, ProductName, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

-- 5
SELECT SaleID, ProductName, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSaleAmount
FROM ProductSales;

-- 6
SELECT SaleID, ProductName, SaleAmount
FROM (
    SELECT *, LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) AS t
WHERE SaleAmount > PrevSale;

-- 7
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromPrev
FROM ProductSales;

-- 8
SELECT SaleID, ProductName, SaleAmount,
       ((LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) / SaleAmount) * 100 AS PercentChange
FROM ProductSales;

-- 9
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS RatioToPrev
FROM ProductSales;

-- 10
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromFirst
FROM ProductSales;

-- 11
SELECT ProductName, SaleDate, SaleAmount
FROM (
    SELECT ProductName, SaleDate, SaleAmount,
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) AS t
WHERE SaleAmount > PrevSale;

-- 12
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM ProductSales;

-- 13
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM ProductSales;

-- 14
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;
-- 15. Employees Who Have the Same Salary Rank
SELECT Name, Department, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

-- 16. Top 2 Highest Salaries in Each Department
SELECT *
FROM (
    SELECT Name, Department, Salary,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
    FROM Employees1
) AS t
WHERE rnk <= 2;

-- 17. Lowest-Paid Employee in Each Department
SELECT *
FROM (
    SELECT Name, Department, Salary,
           RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rnk
    FROM Employees1
) AS t
WHERE rnk = 1;

-- 18. Running Total of Salaries in Each Department
SELECT Name, Department, Salary,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS RunningTotal
FROM Employees1;

-- 19. Total Salary of Each Department Without GROUP BY
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalSalary
FROM Employees1;

-- 20. Average Salary in Each Department Without GROUP BY
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgSalary
FROM Employees1;

-- 21. Difference Between an Employee’s Salary and Department Average
SELECT Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;

-- 22. Moving Average Over 3 Employees (Previous, Current, Next)
SELECT Name, Department, Salary,
       AVG(Salary) OVER (ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

-- 23. Sum of Salaries for the Last 3 Hired Employees
SELECT SUM(Salary) AS SumLast3Hired
FROM (
    SELECT Salary
    FROM Employees1
    ORDER BY HireDate DESC
    OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
) AS t;

