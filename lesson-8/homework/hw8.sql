-- 1) Products: har bir kategoriyadagi mahsulotlar soni
SELECT Category, COUNT(*) AS ProductCount
FROM Products
GROUP BY Category;

-- 2) Products: 'Electronics' kategoriyasidagi o'rtacha narx
SELECT AVG(Price) AS AvgPrice_Electronics
FROM Products
WHERE Category = 'Electronics';

-- 3) Customers: shahri 'L' harfi bilan boshlanadigan mijozlar
SELECT CustomerID, FirstName, LastName, City
FROM Customers
WHERE City LIKE 'L%';

-- 4) Products: nomi 'er' bilan tugaydigan mahsulotlar
SELECT ProductID, ProductName
FROM Products
WHERE ProductName LIKE '%er';

-- 5) Customers: mamlakati 'A' bilan tugaydigan mijozlar
SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country LIKE '%A';

-- 6) Products: barcha mahsulotlar ichida eng yuqori narx
SELECT MAX(Price) AS MaxProductPrice
FROM Products;

-- 7) Products: zaxira yorlig'i ('Low Stock' < 30, aks holda 'Sufficient')
SELECT ProductID, ProductName, StockQuantity,
       CASE WHEN StockQuantity < 30 THEN 'Low Stock'
            ELSE 'Sufficient'
       END AS StockLabel
FROM Products;

-- 8) Customers: har bir mamlakat bo'yicha mijozlar soni
SELECT Country, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY Country;

-- 9) Orders: minimal va maksimal buyurtma miqdori
SELECT MIN(Quantity) AS MinQty, MAX(Quantity) AS MaxQty
FROM Orders;

/* 10) Orders & Invoices: 2023-yanvarda buyurtma qilgan,
      lekin 2023-yanvarda hisob-fakturasi yo'q mijozlar (CustomerID)
   Izoh: "did not have invoices" — o'sha oyning invoices'i yo'q deb qabul qildik.
*/
WITH jan_orders AS (
  SELECT DISTINCT CustomerID
  FROM Orders
  WHERE OrderDate >= '2023-01-01' AND OrderDate < '2023-02-01'
),
jan_invoices AS (
  SELECT DISTINCT CustomerID
  FROM Invoices
  WHERE InvoiceDate >= '2023-01-01' AND InvoiceDate < '2023-02-01'
)
SELECT jo.CustomerID
FROM jan_orders jo
WHERE NOT EXISTS (SELECT 1 FROM jan_invoices ji WHERE ji.CustomerID = jo.CustomerID);

/* (Agar talqiningiz "umuman invoice yo'q" bo'lsa:)
SELECT DISTINCT o.CustomerID
FROM Orders o
WHERE o.OrderDate >= '2023-01-01' AND o.OrderDate < '2023-02-01'
  AND NOT EXISTS (SELECT 1 FROM Invoices i WHERE i.CustomerID = o.CustomerID);
*/

-- 11) Products & Products_Discounted: nomlarni DUPLIKATLAR bilan birlashtirish
SELECT ProductName FROM Products
UNION ALL
SELECT ProductName FROM Products_Discounted;

-- 12) Products & Products_Discounted: nomlarni DUPLIKATLARSIZ birlashtirish
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 13) Orders: yil bo‘yicha o'rtacha buyurtma summasi
SELECT YEAR(OrderDate) AS OrderYear,
       AVG(TotalAmount) AS AvgOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

-- 14) Products: narxga qarab guruhlash ('Low' <100, 'Mid' 100-500, 'High' >500)
SELECT ProductName,
       CASE
         WHEN Price < 100 THEN 'Low'
         WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
         ELSE 'High'
       END AS PriceGroup
FROM Products;

-- 15) City_Population: Year ni ustunlarga PIVOT qilib, yangi jadvalga yozish
SELECT district_id, district_name, [2012], [2013]
INTO Population_Each_Year
FROM (
  SELECT district_id, district_name, CAST(year AS VARCHAR(4)) AS y, population
  FROM city_population
) src
PIVOT (
  SUM(population) FOR y IN ([2012],[2013])
) p;

-- 16) Sales: har bir ProductID bo'yicha umumiy savdo
SELECT ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID
ORDER BY ProductID;

-- 17) Products: nomida 'oo' qatnashgan mahsulotlar
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%';

-- 18) City_Population: uchta tuman (Bektemir, Chilonzor, Yakkasaroy) ni ustunlarga PIVOT qilamiz
SELECT [2012] AS Year, [Bektemir], [Chilonzor], [Yakkasaroy]
INTO Population_Each_City
FROM (
  SELECT CAST(year AS VARCHAR(4)) AS y, district_name, population
  FROM city_population
  WHERE district_name IN ('Bektemir','Chilonzor','Yakkasaroy')
) src
PIVOT (
  SUM(population) FOR district_name IN ([Bektemir],[Chilonzor],[Yakkasaroy])
) p
ORDER BY [2012];  -- ustun sifatida ham saqlanadi

-- 19) Invoices: eng ko'p umumiy invoice summasiga ega TOP 3 mijoz (CustomerID, TotalSpent)
SELECT TOP 3
       CustomerID,
       SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- 20) Population_Each_Year -> City_Population formatiga qaytarish (UNPIVOT)
--  Eslatma: district_id/district_name bor; UNPIVOT yil-qiymatga ajratadi.
SELECT
  district_id,
  district_name,
  CAST(y AS VARCHAR(4)) AS [year],
  population
FROM Population_Each_Year
UNPIVOT (
  population FOR y IN ([2012],[2013])
) u
ORDER BY district_id, [year];

-- (Agar aynan City_Population ga INSERT qilmoqchi bo'lsangiz:)
-- INSERT INTO city_population (district_id, district_name, population, year)
-- SELECT district_id, district_name, population, y FROM ... (yuqoridagi select)

-- 21) Products & Sales: mahsulot nomi va necha marta sotilgan (JOIN + COUNT)
SELECT p.ProductName,
       COUNT(*) AS TimesSold
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
GROUP BY p.ProductName
ORDER BY TimesSold DESC, p.ProductName;

-- 22) Population_Each_City -> City_Population formatiga qaytarish (UNPIVOT)
--  Population_Each_City tuzilmasi: Year, Bektemir, Chilonzor, Yakkasaroy
SELECT
  CASE u.City
    WHEN 'Bektemir'   THEN 5  -- ixtiyoriy ID tayinlash yoki asl mappingdan foydalanish
    WHEN 'Chilonzor'  THEN 1
    WHEN 'Yakkasaroy' THEN 2
    ELSE NULL
  END AS district_id,
  u.City        AS district_name,
  u.population,
  u.[Year]      AS [year]
FROM (
  SELECT CAST([2012] AS VARCHAR(4)) AS [Year], [Bektemir], [Chilonzor], [Yakkasaroy]
  FROM Population_Each_City
  UNION ALL
  SELECT CAST([2013] AS VARCHAR(4)) AS [Year], [Bektemir], [Chilonzor], [Yakkasaroy]
  FROM Population_Each_City
) src
UNPIVOT (
  population FOR City IN ([Bektemir],[Chilonzor],[Yakkasaroy])
) u
ORDER BY [Year], City;

/* Izoh:
   - Agar asl City_Population jadvali hali mavjud bo'lsa va undagi district_id mappingi kerak bo'lsa,
     UNPIVOT natijasini DISTINCT district_name ↔ district_id mappingiga JOIN qilib aniq IDlarni qo'yish mumkin:
   WITH map AS (
     SELECT district_name, MIN(district_id) AS district_id
     FROM city_population
     GROUP BY district_name
   )
   SELECT m.district_id, u.City AS district_name, u.population, u.Year
   FROM (...UNPIVOT...) u
   JOIN map m ON m.district_name = u.City;
*/
