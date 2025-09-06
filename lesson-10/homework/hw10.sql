
--Easy (10)
-- 1) >50000 maosh + bo'lim nomi
SELECT e.Name AS EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 50000;

-- 2) 2023-yilda berilgan buyurtmalar: mijoz ismi + OrderDate
SELECT c.FirstName, c.LastName, o.OrderDate
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '2023-01-01' AND o.OrderDate < '2024-01-01';

-- 3) Barcha xodimlar + bo'lim nomi (bo'limi yo'qlar ham chiqsin)
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON d.DepartmentID = e.DepartmentID;

-- 4) Barcha ta'minotchilar va ular yetkazadigan mahsulotlar
-- (hatto mahsulotsiz supplier ham chiqsin)
SELECT s.SupplierName, p.ProductName
FROM Suppliers s
LEFT JOIN Products p ON p.SupplierID = s.SupplierID
ORDER BY s.SupplierName, p.ProductName;

-- 5) Orders va Payments: har ikkala tomonni ham ko'rsatish
-- (to'lovsiz orderlar + ordersiz payments)
SELECT
  o.OrderID,
  o.OrderDate,
  p.PaymentDate,
  p.Amount
FROM Orders o
FULL OUTER JOIN Payments p ON p.OrderID = o.OrderID
ORDER BY COALESCE(o.OrderID, p.OrderID);

-- 6) Har bir xodim va uning menejeri nomi
SELECT e.Name AS EmployeeName, m.Name AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON m.EmployeeID = e.ManagerID;

-- 7) 'Math 101' kursiga yozilgan talabalar
SELECT s.Name AS StudentName, c.CourseName
FROM Enrollments en
JOIN Students  s ON s.StudentID = en.StudentID
JOIN Courses   c ON c.CourseID  = en.CourseID
WHERE c.CourseName = 'Math 101';

-- 8) Kamida bitta buyurtmasida Quantity > 3 bo'lgan mijozlar
SELECT c.FirstName, c.LastName, o.Quantity
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.Quantity > 3;

-- 9) 'Human Resources' bo'limidagi xodimlar
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'Human Resources';

-- Medium (9)
-- 10) 5 tadan ko'p xodimli bo'limlar
SELECT d.DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(*) > 5;

-- 11) Hech qachon sotilmagan mahsulotlar (Sales bo'yicha)
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Sales s ON s.ProductID = p.ProductID
WHERE s.ProductID IS NULL;

-- 12) Kamida 1 ta buyurtma bergan mijozlar + buyurtmalar soni
SELECT c.FirstName, c.LastName, COUNT(*) AS TotalOrders
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

-- 13) Faqat Employee va Department mavjud bo'lgan yozuvlar (NULLs yo'q)
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID;

-- 14) Bir xil menejerdagi xodimlar juftligi
SELECT e1.Name AS Employee1, e2.Name AS Employee2, e1.ManagerID
FROM Employees e1
JOIN Employees e2
  ON e1.ManagerID = e2.ManagerID
 AND e1.EmployeeID < e2.EmployeeID
WHERE e1.ManagerID IS NOT NULL;

-- 15) 2022-yil buyurtmalari va mijoz ismlari
SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '2022-01-01' AND o.OrderDate < '2023-01-01';

-- 16) 'Sales' bo'limi va maoshi > 60000 bo'lganlar
SELECT e.Name AS EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'Sales' AND e.Salary > 60000;

-- 17) Faqat to'lovi mavjud bo'lgan orderlar
SELECT o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
FROM Orders o
JOIN Payments p ON p.OrderID = o.OrderID;

-- 18) Hech qachon buyurtma qilinmagan mahsulotlar (Orders bo'yicha)
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Orders o ON o.ProductID = p.ProductID
WHERE o.ProductID IS NULL;

🔴 Hard (9)
-- 19) O'z bo'limidagi o'rtacha maoshdan yuqori maosh oladigan xodimlar
SELECT e.Name AS EmployeeName, e.Salary
FROM Employees e
WHERE e.DepartmentID IS NOT NULL
  AND e.Salary >
      (SELECT AVG(e2.Salary)
       FROM Employees e2
       WHERE e2.DepartmentID = e.DepartmentID);

-- 20) 2020-yilgacha berilgan, to'lovi yo'q orderlar
SELECT o.OrderID, o.OrderDate
FROM Orders o
LEFT JOIN Payments p ON p.OrderID = o.OrderID
WHERE o.OrderDate < '2020-01-01'
  AND p.OrderID IS NULL;

-- 21) Kategoriya bilan mos kelmaydigan mahsulotlar
-- (Products.Category = INT; Categories.CategoryID ga mos kelmaganlar)
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Categories c ON c.CategoryID = p.Category
WHERE c.CategoryID IS NULL;

-- 22) Bir menejerdagi va har ikkisi ham >60000 oladigan juftliklar
-- (talab Salary ustuni bitta deb ko'rsatilgan bo'lsa ham, juftlik uchun ikkala maoshni ko'rsatish foydali)
SELECT e1.Name AS Employee1,
       e2.Name AS Employee2,
       e1.ManagerID,
       e1.Salary AS Salary1,   -- qo'shimcha ko'rinish
       e2.Salary AS Salary2
FROM Employees e1
JOIN Employees e2
  ON e1.ManagerID = e2.ManagerID
 AND e1.EmployeeID < e2.EmployeeID
WHERE e1.ManagerID IS NOT NULL
  AND e1.Salary > 60000
  AND e2.Salary > 60000;

-- 23) Nomlari 'M' bilan boshlanuvchi bo'limlarda ishlovchilar
SELECT e.Name AS EmployeeName, d.DepartmentName
FROM Employees e
JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName LIKE 'M%';

-- 24) SaleAmount > 500 bo'lgan savdolar (mahsulot nomlari bilan)
SELECT s.SaleID, p.ProductName, s.SaleAmount
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE s.SaleAmount > 500;

-- 25) 'Math 101' ga yozilmagan talabalar
SELECT s.StudentID, s.Name AS StudentName
FROM Students s
WHERE NOT EXISTS (
  SELECT 1
  FROM Enrollments en
  JOIN Courses c ON c.CourseID = en.CourseID
  WHERE en.StudentID = s.StudentID
    AND c.CourseName = 'Math 101'
);

-- 26) To'lov ma'lumoti yo'q orderlar (PaymentID kerak)
SELECT o.OrderID, o.OrderDate, p.PaymentID
FROM Orders o
LEFT JOIN Payments p ON p.OrderID = o.OrderID
WHERE p.PaymentID IS NULL;

-- 27) 'Electronics' yoki 'Furniture' kategoriyasidagi mahsulotlar
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products p
JOIN Categories c ON c.CategoryID = p.Category
WHERE c.CategoryName IN ('Electronics', 'Furniture')
ORDER BY c.CategoryName, p.ProductName;
