-- 1️ Find customers who purchased at least one item in March 2024 using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND MONTH(s2.SaleDate) = 3
      AND YEAR(s2.SaleDate) = 2024
);

--2️ Find the product with the highest total sales revenue using a subquery
SELECT Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) AS Sub
);

--3 Find the second highest sale amount using a subquery
SELECT MAX(TotalAmount) AS SecondHighestSale
FROM (
    SELECT (Quantity * Price) AS TotalAmount
    FROM #Sales
) AS Sub
WHERE TotalAmount < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);

--4️ Find the total quantity of products sold per month using a subquery
SELECT 
    DATENAME(MONTH, SaleDate) AS MonthName,
    SUM(Quantity) AS TotalQuantity
FROM #Sales
GROUP BY DATENAME(MONTH, SaleDate), MONTH(SaleDate)
ORDER BY MONTH(SaleDate);

--5️ Find customers who bought the same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.Product = s2.Product
      AND s1.CustomerName <> s2.CustomerName
);

--task 6
SELECT Name, 
       ISNULL([Apple], 0) AS Apple,
       ISNULL([Orange], 0) AS Orange,
       ISNULL([Banana], 0) AS Banana
FROM (
    SELECT Name, Fruit
    FROM Fruits
) AS SourceTable
PIVOT (
    COUNT(Fruit)
    FOR Fruit IN ([Apple], [Orange], [Banana])
) AS PivotTable;

--task7
WITH FamilyCTE AS (
    SELECT ParentId, ChildID
    FROM Family
    UNION ALL
    SELECT f.ParentId, c.ChildID
    FROM Family f
    JOIN FamilyCTE c ON f.ChildID = c.ParentId
)
SELECT DISTINCT ParentId AS PID, ChildID AS CHID
FROM FamilyCTE
ORDER BY PID, CHID;

--task8
SELECT *
FROM #Orders o
WHERE DeliveryState = 'TX'
AND EXISTS (
    SELECT 1
    FROM #Orders c
    WHERE c.CustomerID = o.CustomerID
      AND c.DeliveryState = 'CA'
);

--9 task
UPDATE #residents
SET fullname = 
    SUBSTRING(address, CHARINDEX('name=', address) + 5,
    CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) 
    - CHARINDEX('name=', address) - 5)
WHERE fullname IS NULL OR fullname = '';

--10 task
WITH RoutePaths AS (
    SELECT 'Tashkent - Samarkand - Khorezm' AS Route, 
           (100 + 400) AS Cost
    UNION ALL
    SELECT 'Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm',
           (100 + 50 + 200 + 300)
)
SELECT * 
FROM RoutePaths
WHERE Cost IN (
    (SELECT MIN(Cost) FROM RoutePaths),
    (SELECT MAX(Cost) FROM RoutePaths)
);

--11 task
SELECT 
    ID,
    Vals,
    ROW_NUMBER() OVER (ORDER BY ID) AS RowRank
FROM #RankingPuzzle;

--task12
SELECT e.EmployeeName, e.Department, e.SalesAmount
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
);

--13 task
SELECT DISTINCT e1.EmployeeName, e1.SalesMonth, e1.SalesAmount
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.SalesMonth = e1.SalesMonth
    GROUP BY e2.SalesMonth
    HAVING e1.SalesAmount = MAX(e2.SalesAmount)
);

--14 task
SELECT e1.EmployeeName
FROM #EmployeeSales e1
GROUP BY e1.EmployeeName
HAVING COUNT(DISTINCT e1.SalesMonth) = (
    SELECT COUNT(DISTINCT SalesMonth)
    FROM #EmployeeSales
);
--15 task Retrieve names of products that are more expensive than the average price of all products
SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);


--16 Find products that have a stock count lower than the highest stock count

SELECT Name, Stock
FROM Products
WHERE Stock < (
    SELECT MAX(Stock)
    FROM Products
);



--17 Get the names of products that belong to the same category as 'Laptop'

SELECT Name, Category
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);



--18 Retrieve products whose price is greater than the lowest price in the Electronics category
SELECT Name, Price, Category
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);

--19 Find the products that have a higher price than the average price of their respective category
✅ Query
SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);


--20 Find the products that have been ordered at least once
SELECT DISTINCT p.ProductID, p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;



--21 Retrieve the names of products that have been ordered more than the average quantity ordered
SELECT p.Name, SUM(o.Quantity) AS TotalOrdered
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(Quantity) FROM Orders
);



-- 22 Find the products that have never been ordered

SELECT p.ProductID, p.Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);



--23 Retrieve the product with the highest total quantity ordered
SELECT TOP 1 p.Name, SUM(o.Quantity) AS TotalOrdered
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY TotalOrdered DESC;
