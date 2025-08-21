--Task_1 
BULK INSERT bu kotta hajmdagi malumotlarni table ga tez yuklash uchun ishlatilinadi. Masalan ( CVV, Excel, TXT )
bu qo‘lda birma-bir INSERT yozish o‘rniga, fayldan minglab yozuvlarni bir martada yuklab olish.

--task_2
SQL Serverga turli faylarni import qilish mumkun masalan Excel.xlc CSV, TXT filelarni

--Task_3
Create database Class3_Homework

use  Class3_Homework

Create Table Products (ProductID int primary key, ProductName varchar (50), Price Decimal(10,2))

--task4 

      INSERT INTO Products (ProductID, ProductName,Price) Values (1, 'Apple', 13000),(2, 'Peach', 22000),(3, 'Banana', 16000),(4, 'Pineapple', 17000),(5, 'Grapes', 10000);

Select * From Products

--task5
NULL da qiymat bo'sh qo'yilmaydi
NOT NULL da qiymat bo'lishi kerak

--task6
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

--task7
-- bu kometrayi degani 

--task8 
Alter table Products
Add CategoryID int

task10
IDENTITY → avtomatik raqam beruvchi ustun.
Masalan: IDENTITY(1,1) → 1-dan boshlaydi va har safar 1 ga oshadi.
Bu ko‘pincha PRIMARY KEY sifatida ishlatiladi.
