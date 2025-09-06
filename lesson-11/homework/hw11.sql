--Easy (7)
-- 1) Orders after 2022 (>= 2023-01-01) + customer names
SELECT 
  o.OrderID,
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  o.OrderDate
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '2023-01-01';

-- 2) Employees in Sales or Marketing
SELECT 
  e.Name AS EmployeeName,
  d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName IN ('Sales','Marketing');

-- 3) Max salary by department
SELECT 
  d.DepartmentName,
  MAX(e.Salary) AS MaxSalary
FROM Departments d
JOIN Employees  e ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

-- 4) USA customers who placed orders in 2023
SELECT 
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  o.OrderID,
  o.OrderDate
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'
  AND o.OrderDate >= '2023-01-01' AND o.OrderDate < '2024-01-01';

-- 5) How many orders each customer has placed
SELECT 
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY CONCAT(c.FirstName, ' ', c.LastName)
ORDER BY TotalOrders DESC, CustomerName;

-- 6) Products supplied by Gadget Supplies or Clothing Mart
SELECT 
  p.ProductName,
  s.SupplierName
FROM Products  p
JOIN Suppliers s ON s.SupplierID = p.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies','Clothing Mart')
ORDER BY s.SupplierName, p.ProductName;

-- 7) For each customer, their most recent order (include those with no orders)
SELECT 
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
GROUP BY CONCAT(c.FirstName, ' ', c.LastName)
ORDER BY CustomerName;

--🟠 Medium (6)
-- 8) Customers who have an order with TotalAmount > 500
SELECT DISTINCT
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  o.TotalAmount AS OrderTotal
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 500;

-- 9) Product sales where (year = 2022) OR (SaleAmount > 400)
SELECT 
  p.ProductName,
  s.SaleDate,
  s.SaleAmount
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE (s.SaleDate >= '2022-01-01' AND s.SaleDate < '2023-01-01')
   OR s.SaleAmount > 400
ORDER BY s.SaleDate, p.ProductName;

-- 10) Each product with total sales amount (0 for never sold)
SELECT 
  p.ProductName,
  COALESCE(SUM(s.SaleAmount), 0) AS TotalSalesAmount
FROM Products p
LEFT JOIN Sales s ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSalesAmount DESC, p.ProductName;

-- 11) HR employees with Salary > 60000
SELECT 
  e.Name AS EmployeeName,
  d.DepartmentName,
  e.Salary
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'Human Resources'
  AND e.Salary > 60000;

-- 12) Products sold in 2023 AND had >100 units in stock (assume current stock)
SELECT 
  p.ProductName,
  s.SaleDate,
  p.StockQuantity
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE s.SaleDate >= '2023-01-01' AND s.SaleDate < '2024-01-01'
  AND p.StockQuantity > 100
ORDER BY s.SaleDate, p.ProductName;

-- 13) Employees who are in Sales OR hired after 2020
SELECT 
  e.Name AS EmployeeName,
  d.DepartmentName,
  e.HireDate
FROM Employees e
LEFT JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE (d.DepartmentName = 'Sales')
   OR (e.HireDate > '2020-12-31');

🔴 Hard (7)
-- 14) USA customers whose Address starts with 4 digits + their orders
SELECT 
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  o.OrderID,
  c.Address,
  o.OrderDate
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA'
  AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';

-- 15) Sales for Electronics OR SaleAmount > 350
SELECT 
  p.ProductName,
  p.Category,
  s.SaleAmount
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE p.Category = 'Electronics'
   OR s.SaleAmount > 350
ORDER BY s.SaleAmount DESC;

-- 16) Number of products in each category
-- Variant A: If you have a Categories table (CategoryID, CategoryName) and Products.Category stores the name:
-- (In this dataset Products.Category is VARCHAR, so we can do it directly)
SELECT 
  p.Category AS CategoryName,
  COUNT(*)   AS ProductCount
FROM Products p
GROUP BY p.Category
ORDER BY ProductCount DESC, CategoryName;

-- Variant B (normalized): if Products.Category = CategoryID INT and you also have Categories:
-- SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
-- FROM Categories c
-- LEFT JOIN Products p ON p.Category = c.CategoryID
-- GROUP BY c.CategoryName
-- ORDER BY ProductCount DESC, c.CategoryName;

-- 17) Los Angeles orders with amount > 300
SELECT 
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  c.City,
  o.OrderID,
  o.TotalAmount AS Amount
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE c.City = 'Los Angeles'
  AND o.TotalAmount > 300;

-- 18) Employees in HR or Finance OR name contains at least 4 vowels
-- Count vowels: total length - length after removing vowels
SELECT 
  e.Name AS EmployeeName,
  d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName IN ('Human Resources','Finance')
   OR (
        LEN(e.Name) 
        - LEN(REPLACE(LOWER(e.Name), 'a', ''))
        - LEN(REPLACE(LOWER(e.Name), 'e', ''))
        - LEN(REPLACE(LOWER(e.Name), 'i', ''))
        - LEN(REPLACE(LOWER(e.Name), 'o', ''))
        - LEN(REPLACE(LOWER(e.Name), 'u', ''))
      ) >= 4;

-- 19) Employees in Sales or Marketing with salary > 60000
SELECT 
  e.Name AS EmployeeName,
  d.DepartmentName,
  e.Salary
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName IN ('Sales','Marketing')
  AND e.Salary > 60000;
