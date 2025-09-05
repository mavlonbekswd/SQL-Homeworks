                                                                                           --EASY--

--1)-- Barcha kombinatsiyalar (Cartesian product)
SELECT p.ProductName, s.SupplierName
FROM Products AS p
CROSS JOIN Suppliers AS s;
--2) Departments × Employees: barcha kombinatsiyalar

SELECT d.DepartmentName, e.EmployeeName
FROM Departments AS d
CROSS JOIN Employees AS e;
--3) Products ↔ Suppliers: haqiqatda ta’minlaydigan kombinatsiyalar (faqat real juftliklar)
Variant A (agar Products jadvalida SupplierID FK bo‘lsa):
SELECT s.SupplierName, p.ProductName
FROM Products AS p
JOIN Suppliers AS s
  ON p.SupplierID = s.SupplierID;

--4) Orders ↔ Customers: mijoz nomi va uning buyurtma ID’lari
SELECT c.CustomerName, o.OrderID
FROM Orders AS o
JOIN Customers AS c
  ON o.CustomerID = c.CustomerID;
--5) Courses × Students: barcha kombinatsiyalar (har bir student har bir course bilan)
SELECT s.StudentName, c.CourseName
FROM Students AS s
CROSS JOIN Courses  AS c;
--6) Products ↔ Orders: ProductID lar mos tushgan joylar
SELECT p.ProductName, o.OrderID
FROM Orders AS o
JOIN Products AS p
  ON o.ProductID = p.ProductID;
--7) Departments ↔ Employees: xodimlar o‘z DepartmentID’iga mos kelgan
SELECT e.EmployeeName, d.DepartmentName
FROM Employees  AS e
JOIN Departments AS d
  ON e.DepartmentID = d.DepartmentID;
--8) Students ↔ Enrollments: talaba nomi va ro‘yxatdan o‘tgan course ID’lari
SELECT s.StudentName, en.CourseID
FROM Enrollments AS en
JOIN Students    AS s
  ON en.StudentID = s.StudentID;
--9) Payments ↔ Orders: to‘lovi bor buyurtmalar
SELECT o.OrderID, p.PaymentID, p.Amount, p.PaymentDate
FROM Payments AS p
JOIN Orders   AS o
  ON p.OrderID = o.OrderID;
--10) Orders ↔ Products: narxi 100 dan katta bo‘lgan product’li buyurtmalar
SELECT o.OrderID, p.ProductName, p.Price
FROM Orders   AS o
JOIN Products AS p
  ON o.ProductID = p.ProductID
WHERE p.Price > 100;



                                                                                                 --MEDIUM--

--1) Employees × Departments: barcha nomuvofiq (mismatched) kombinatsiyalar

-- Mismatched juftliklar: har bir xodimni barcha bo‘limlar bilan cartesian qilib,
-- ID teng bo‘lmaganlarini qoldiramiz
SELECT e.EmployeeName, d.DepartmentName
FROM Employees AS e
CROSS JOIN Departments AS d
WHERE e.DepartmentID <> d.DepartmentID;

--2) Orders × Products: buyurtma qilingan miqdor > zaxira (stock) miqdori
SELECT o.OrderID, p.ProductName, o.Quantity, p.StockQty
FROM Orders AS o
JOIN Products AS p ON o.ProductID = p.ProductID
WHERE o.Quantity > p.StockQty;



--3) Customers × Sales: sale_amount ≥ 500 bo‘lsa, customer_name va product_id
SELECT c.CustomerName, s.ProductID, s.SaleAmount
FROM Sales     AS s
JOIN Customers AS c ON s.CustomerID = c.CustomerID
WHERE s.SaleAmount >= 500;

--4) Courses × Enrollments × Students: talaba qaysi kurslarga yozilgan
SELECT st.StudentName, c.CourseName
FROM Enrollments AS en
JOIN Students   AS st ON en.StudentID = st.StudentID
JOIN Courses    AS c  ON en.CourseID  = c.CourseID;

--5) Products × Suppliers: SupplierName “Tech” ni o‘z ichiga olsa

SELECT p.ProductName, s.SupplierName
FROM Products  AS p
JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName LIKE '%Tech%';



--6) Orders × Payments: to‘lov summasi total’dan kichik bo‘lgan buyurtmalar

SELECT o.OrderID, o.TotalAmount, p.PaymentAmount
FROM Orders   AS o
JOIN Payments AS p ON p.OrderID = o.OrderID
WHERE p.PaymentAmount < o.TotalAmount;


--7) Employees × Departments: har bir xodimning department nomi
SELECT e.EmployeeName, d.DepartmentName
FROM Employees  AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID;

--8) Products × Categories: kategoriya 'Electronics' yoki 'Furniture'

SELECT p.ProductName, c.CategoryName
FROM Products  AS p
JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');

--9) Sales × Customers: 'USA' mamlakatidagi mijozlarning barcha sales’lari
SELECT s.SaleID, s.ProductID, s.SaleAmount, c.CustomerName, c.Country
FROM Sales     AS s
JOIN Customers AS c ON s.CustomerID = c.CustomerID
WHERE c.Country = 'USA';

--10) Orders × Customers: 'Germany' mijozlari & order total > 100

SELECT o.OrderID, c.CustomerName, o.TotalAmount
FROM Orders    AS o
JOIN Customers AS c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'Germany'
  AND o.TotalAmount > 100;
