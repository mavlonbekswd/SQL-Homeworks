

-- ========== EASY TASKS ==========

-- 1) ProductName ustunini alias bilan Name deb ko‘rsatish
SELECT ProductName AS Name
FROM Products;

-- 2) Customers jadvaliga alias (Client) berib ko‘rsatish
SELECT *
FROM Customers AS Client;

-- 3) Products va Products_Discounted dan ProductName ni UNION qilib birlashtirish (takrorlarni olib tashlaydi)
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 4) INTERSECT: ikkala jadvalda ham mavjud bo‘lgan productlar
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted;

-- 5) DISTINCT: mijoz nomi va mamlakati bo‘yicha noyob qatorlar
SELECT DISTINCT CustomerName, Country
FROM Customers;

-- 6) CASE: Price > 1000 -> 'High', aks holda 'Low'
SELECT ProductID, ProductName, Price,
       CASE WHEN Price > 1000 THEN 'High' ELSE 'Low' END AS PriceLevel
FROM Products;

-- 7) IIF: Products_Discounted.StockQuantity > 100 bo‘lsa 'Yes', aks holda 'No'
SELECT ProductName, StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS StockGT100
FROM Products_Discounted;


-- ========== MEDIUM TASKS ==========

-- 8) (Yana) UNION: ikkala jadvaldan ProductName’larni birlashtirish
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 9) EXCEPT: Products dagi, lekin Products_Discounted da yo‘q bo‘lgan ProductName’lar
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM Products_Discounted;

-- 10) IIF: Price > 1000 -> 'Expensive', aks holda 'Affordable'
SELECT ProductID, ProductName, Price,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceTag
FROM Products;

-- 11) Employees: Age < 25 YOKI Salary > 60000
SELECT *
FROM Employees
WHERE Age < 25
   OR Salary > 60000;

-- 12) Employees: Department = 'HR' YOKI EmployeeID = 5 bo‘lsa, Salary’ni 10% ga oshirish
-- Diqqat: bu UPDATE ma'lumotlarni o'zgartiradi.
-- Ishonch uchun avval SELECT bilan tekshiring:
-- SELECT * FROM Employees WHERE Department = 'HR' OR EmployeeID = 5;

UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'HR'
   OR EmployeeID = 5;

-- ========== HARD TASKS ==========

--task13
SELECT
    SaleID,            -- agar bor bo‘lsa
    CustomerID,        -- agar bor bo‘lsa
    SaleAmount,
    CASE
        WHEN SaleAmount > 500 THEN 'Top Tier'
        WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
        ELSE 'Low Tier'
    END AS AmountTier
FROM Sales;

--task14
/* =========================
   Orders bor, lekin Sales’da yo‘q bo‘lgan mijoz ID’lari
   ========================= */
SELECT DISTINCT CustomerID
FROM Orders
EXCEPT
SELECT DISTINCT CustomerID
FROM Sales;

/* =========================
   HARD 3)
   Orders: Quantity bo‘yicha chegirma foizi
   1 dona => 3%
   2–3 dona => 5%
   Aks holda => 7%
   ========================= */
SELECT
    CustomerID,
    Quantity,
    CASE
        WHEN Quantity = 1 THEN 0.03   -- 3%
        WHEN Quantity BETWEEN 2 AND 3 THEN 0.05  -- 5%
        ELSE 0.07                     -- 7%
    END AS DiscountPercent
FROM Orders;

-- Agar natijani matn (foiz belgisi bilan) ko‘rsatmoqchi bo‘lsangiz:
-- SELECT CustomerID, Quantity,
--        CASE
--            WHEN Quantity = 1 THEN '3%'
--            WHEN Quantity BETWEEN 2 AND 3 THEN '5%'
--            ELSE '7%'
--        END AS DiscountPercentText
-- FROM Orders;

