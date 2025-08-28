                                  --EASY--

-- 1. Products jadvalidan eng arzon (minimum) narxni topish
SELECT MIN(Price) AS MinPrice
FROM Products;

-- 2. Employees jadvalidan eng katta (maximum) maoshni topish
SELECT MAX(Salary) AS MaxSalary
FROM Employees;

-- 3. Customers jadvalidagi barcha qatorlar sonini sanash
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

-- 4. Products jadvalidan nechta turli xil (unique) kategoriya borligini topish
SELECT COUNT(DISTINCT Category) AS UniqueCategories
FROM Products;

-- 5. Sales jadvalidan ProductID = 7 bo'lgan mahsulotning umumiy sotuv summasini hisoblash
SELECT SUM(SaleAmount) AS TotalSalesForProduct7
FROM Sales
WHERE ProductID = 7;

-- 6. Employees jadvalidan xodimlarning o'rtacha yoshini hisoblash
SELECT AVG(Age) AS AverageAge
FROM Employees;

-- 7. Employees jadvalidan har bir bo'limdagi (DeptID) xodimlar sonini sanash
SELECT DeptID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DeptID;

-- 8. Products jadvalidan har bir kategoriya bo'yicha eng arzon va eng qimmat narxlarni ko'rsatish
SELECT Category, 
       MIN(Price) AS MinPrice, 
       MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

-- 9. Sales jadvalidan har bir mijozning (CustomerID) umumiy sotuv summasini hisoblash
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;

-- 10. Employees jadvalidan 5 tadan ko'p xodim ishlaydigan bo'limlarni ko'rsatish
SELECT DeptID, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DeptID
HAVING COUNT(*) > 5;

                                                      --MEDIUM--

-- 1. Sales jadvalidan har bir mahsulot kategoriyasi bo'yicha
-- umumiy sotuv (SUM) va o'rtacha sotuv (AVG) summasini hisoblash
SELECT CategoryID, 
       SUM(SaleAmount) AS TotalSales, 
       AVG(SaleAmount) AS AverageSales
FROM Sales
GROUP BY CategoryID;

-- 2. Employees jadvalidan faqat HR bo'limidagi xodimlar sonini sanash
SELECT COUNT(*) AS HR_Employees
FROM Employees
WHERE DeptName = 'HR';  -- Agar DeptName yo'q bo'lsa, DeptID dan foydalanasiz

-- 3. Employees jadvalidan har bir bo'lim bo'yicha eng katta va eng kichik maoshlarni ko'rsatish
SELECT DeptID, 
       MAX(Salary) AS HighestSalary, 
       MIN(Salary) AS LowestSalary
FROM Employees
GROUP BY DeptID;

-- 4. Employees jadvalidan har bir bo'limning o'rtacha maoshini hisoblash
SELECT DeptID, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DeptID;

-- 5. Employees jadvalidan har bir bo'lim bo'yicha o'rtacha maosh va xodimlar sonini ko'rsatish
SELECT DeptID, 
       AVG(Salary) AS AverageSalary, 
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DeptID;

-- 6. Products jadvalidan faqat o'rtacha narxi 400 dan katta bo'lgan kategoriyalarni ko'rsatish
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

-- 7. Sales jadvalidan har bir yil bo'yicha umumiy sotuv summasini hisoblash
SELECT YEAR(SaleDate) AS SaleYear, 
       SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);

-- 8. Sales jadvalidan kamida 3 marta buyurtma qilgan mijozlarni (CustomerID) chiqarish
SELECT CustomerID
FROM Sales
GROUP BY CustomerID
HAVING COUNT(OrderID) >= 3;

-- 9. Employees jadvalidan faqat o'rtacha maosh summasi 60000 dan katta bo'lgan bo'limlarni ko'rsatish
SELECT DeptID, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DeptID
HAVING AVG(Salary) > 60000;
