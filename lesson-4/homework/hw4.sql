                                                                           -- EASY --
--task_1 
SELECT TOP 5 * --Faqat tepadagi 5 ta sini oladi
FROM Employees;

--taks_2
SELECT DISTINCT Category --Distinct bu takrorlangan qiymatni olib tashlaydi
FROM Products;

--task_3
SELECT *
FROM Products
WHERE Price > 100;

--task_4
SELECT *
FROM Customers
WHERE FirstName LIKE 'A%'; --LIKE 'A~Z%' A harfi bilan boshlanadigan qiymatlar.

--task_5
SELECT *
FROM Products
ORDER BY Price ASC; --ASC bu defoult bo'ladi, va o'sih tartibida joylashadi

--task_6
SELECT *
FROM Employees
WHERE Salary >= 60000
  AND Department = 'HR';

--task_7
SELECT EmployeeID, FirstName, LastName,
       ISNULL(Email, 'noemail@example.com') AS Email
FROM Employees; --Agar Email bo‘sh (NULL) bo‘lsa, noemail@example.com ko‘rsatadi.

--task_8
SELECT *
FROM Products
WHERE Price BETWEEN 50 AND 100;

--task_9
SELECT DISTINCT Category, ProductName
FROM Products; -- Ikkita ustunni birgalikda noyob qilib beradi.

--task_10
SELECT DISTINCT Category, ProductName
FROM Products
ORDER BY ProductName DESC;
                                                            --MEDIUM--

--task_11
SELECT TOP 10 *
FROM Products
ORDER BY Price DESC;   -- eng qimmatidan arzoniga

--task_12
--COALESCE – FirstName yoki LastName’dan birinchisi (NULL bo‘lmaganini) qaytarish
SELECT EmployeeID,
       COALESCE(FirstName, LastName) AS PreferredName
FROM Employees;
-- COALESCE: birinchi NULL bo'lmagan qiymatni oladi

--task-13
--DISTINCT – Category va Price juftliklari
SELECT DISTINCT Category, Price
FROM Products;
-- Ikkala ustun kombinatsiyasi bo'yicha takrorlarni olib tashlaydi

--task-14
SELECT *
FROM Employees
WHERE (Age BETWEEN 30 AND 40)
   OR Department = 'Marketing';

--task15
SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS       -- birinchi 10 ta (1–10) tashlab ketiladi
FETCH NEXT 10 ROWS ONLY;  -- keyingi 10 ta (11–20)

--task16
SELECT *
FROM Products
WHERE Price <= 1000
  AND Stock  > 50
ORDER BY Stock ASC;
