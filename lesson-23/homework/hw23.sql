
--task1 
CREATE TABLE Dates (
    Id INT,
    Dt DATETIME
);

INSERT INTO Dates VALUES
(1,'2018-04-06 11:06:43.020'),
(2,'2017-12-06 11:06:43.020'),
(3,'2016-01-06 11:06:43.020'),
(4,'2015-11-06 11:06:43.020'),
(5,'2014-10-06 11:06:43.020');

SELECT 
    Id,
    Dt,
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;

--  PUZZLE 2
CREATE TABLE MyTabel (
    Id INT,
    rID INT,
    Vals INT
);
INSERT INTO MyTabel VALUES
(121, 9, 1), (121, 9, 8),
(122, 9, 14), (122, 9, 0), (122, 9, 1),
(123, 9, 1), (123, 9, 2), (123, 9, 10);

SELECT 
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) AS t
GROUP BY rID;

--  PUZZLE 3
CREATE TABLE TestFixLengths (
    Id INT,
    Vals VARCHAR(100)
);
INSERT INTO TestFixLengths VALUES
(1,'1111111'), (2,'123456'), (2,'123467'),
(2,'1234567890'), (5,''), (6,NULL), (7,'123456789012345');

SELECT Id, Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;

--  PUZZLE 4
CREATE TABLE TestMaximum (
    ID INT,
    Item VARCHAR(20),
    Vals INT
);
INSERT INTO TestMaximum VALUES
(1,'a1',15),(1,'a2',20),(1,'a3',90),
(2,'q1',10),(2,'q2',40),(2,'q3',60),(2,'q4',30),
(3,'q5',20);

SELECT ID, Item, Vals
FROM TestMaximum t
WHERE Vals = (
    SELECT MAX(Vals)
    FROM TestMaximum
    WHERE ID = t.ID
);

-- PUZZLE 5
CREATE TABLE SumOfMax (
    DetailedNumber INT,
    Vals INT,
    Id INT
);
INSERT INTO SumOfMax VALUES
(1,5,101),(1,4,101),(2,6,101),(2,3,101),
(3,3,102),(4,2,102),(4,3,102);

SELECT Id, SUM(MaxVals) AS SumOfMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVals
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS t
GROUP BY Id;

--  PUZZLE 6
CREATE TABLE TheZeroPuzzle (
    Id INT,
    a INT,
    b INT
);
INSERT INTO TheZeroPuzzle VALUES
(1,10,4),(2,10,10),(3,1,10000000),(4,15,15);

SELECT 
    Id, a, b,
    NULLIF(a - b, 0) AS OUTPUT
FROM TheZeroPuzzle;


-- 7. Total revenue generated from all sales
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

-- 8. Average unit price of products
SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;

-- 9. Number of sales transactions recorded
SELECT COUNT(*) AS TotalTransactions
FROM Sales;

-- 10. Highest number of units sold in a single transaction
SELECT MAX(QuantitySold) AS HighestUnitsSold
FROM Sales;

-- 11. Number of products sold in each category
SELECT Category, SUM(QuantitySold) AS TotalProductsSold
FROM Sales
GROUP BY Category;

-- 12. Total revenue for each region
SELECT Region, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

-- 13. Product that generated the highest total revenue
SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 14. Running total of revenue ordered by sale date
SELECT 
    SaleDate,
    SUM(QuantitySold * UnitPrice) AS DailyRevenue,
    SUM(SUM(QuantitySold * UnitPrice)) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;

-- 15. Each category's contribution to total sales revenue
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    ROUND(SUM(QuantitySold * UnitPrice) * 100.0 / SUM(SUM(QuantitySold * UnitPrice)) OVER (), 2) AS PercentageContribution
FROM Sales
GROUP BY Category;


--17. Show all sales along with the corresponding customer names
SELECT 
    s.SaleID,
    s.Product,
    s.Category,
    s.QuantitySold,
    s.UnitPrice,
    s.SaleDate,
    c.CustomerName,
    c.Region
FROM Sales s
JOIN Customers c 
    ON s.CustomerID = c.CustomerID;

-- 18. List customers who have not made any purchases
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Region
FROM Customers c
LEFT JOIN Sales s 
    ON c.CustomerID = s.CustomerID
WHERE s.SaleID IS NULL;

-- 19. Compute total revenue generated from each customer
SELECT 
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c 
    ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName;

-- 20. Find the customer who has contributed the most revenue
SELECT TOP 1
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c 
    ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName
ORDER BY TotalRevenue DESC;

-- 21. Calculate the total sales per customer (number of transactions)
SELECT 
    c.CustomerName,
    COUNT(s.SaleID) AS TotalSales
FROM Customers c
LEFT JOIN Sales s 
    ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerName;

-- 22. List all products that have been sold at least once
SELECT DISTINCT p.ProductName
FROM Products p
JOIN Sales s 
    ON p.ProductName = s.Product;

-- 23. Find the most expensive product in the Products table
SELECT TOP 1 
    ProductName,
    Category,
    SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

-- 24. Find all products where the selling price is higher than the average selling price in their category
SELECT 
    p.ProductName,
    p.Category,
    p.SellingPrice
FROM Products p
WHERE p.SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products
    WHERE Category = p.Category
);
