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

task_7
SELECT EmployeeID, FirstName, LastName,
       ISNULL(Email, 'noemail@example.com') AS Email
FROM Employees; --Agar Email bo‘sh (NULL) bo‘lsa, noemail@example.com ko‘rsatadi.

task_8
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
