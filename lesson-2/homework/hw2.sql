
--Task_1 >>>> Create database class2_homework

Use class2_homework

create table Employees (EmpID int, Name varchar(50), Salary decimal(10,2))

--task_2 >>> INSERT INTO Employees (EmpID, Name, Salary) Values
   (1, 'Mavlonbek', 500000.00),
   (2, 'Abbos', 450000.00),
   (3, 'Qosim', 557000.00)

--task_3>>>   Update Employees
   set Salary = 7000
   Where EmpID=1

--task_4 Delete FROM Employees
         Where EmpID = 2

--task_5 Delete: bu yozilgan kodga moslab ochiradi yani qaysini xoxlayotgan bo'lsa osha ustun yoki qatorni o'chiradi Where ishlatilinadi.
        Trancate: Barcha qatorlarni bir zumda o'chiradi faqat strukturasi qoladi. Where ishlatilinmaydi umuman.
        DROP: obyektni butunlay o‘chiradi (jadval/baza); strukturasi ham yo‘q bo‘ladi.

--task_6 Alter table Employees 
        Alter Column Name varchar(100)

--task_7  Alter table Employees
          Add  Department varchar(50)

--task_13
       UPDATE Employees
       SET Department = 'Management'
       WHERE Salary > 5000;
--task_8
        Alter Table Employees
        Alter Column salary float
     
Select * from Employees

--task_9 
          Create Table Department (DepartmentID int PRIMARY KEY, DepartmentName varchar(50))

   Select * from Department

--task_10 & 13
      TRUNCATE TABLE Employees;

SELECT * FROM Employees; 

--task11 
        Create Table Department (DepartmentID int PRIMARY KEY, DepartmentName varchar(50))

--task12 
        Insert Into Department (DepartmentID, DepartmentName) values (1, 'Marketing'),
   (2, 'Programming'),(3, 'Google Cloud'),(4, 'Operation'),(5, 'Hotel&SPA'),(6, 'Ex-Dudenmukh')

--task_14 
        ALTER TABLE Employees
        DROP COLUMN Department;

--task_15
       EXEC sp_rename 'Employees', 'StaffMembers';
        Select * from StaffMembers
-task_16 
    DROP TABLE Departments;


--- Advanced Section --- 
-task_17
   CREATE TABLE Products (
    ProductID INT PRIMARY KEY,          
    ProductName VARCHAR(100) NOT NULL, 
    Category VARCHAR(50) NOT NULL,    
    Price DECIMAL(10,2) NOT NULL,       
    Description VARCHAR(200) NULL      
);

--task_18
      ALTER TABLE Products
      ADD CONSTRAINT CK_Products_Price CHECK (Price > 0);

--task _19
ALTER TABLE Products
ADD StockQuantity INT NOT NULL CONSTRAINT DF_Products_Stock DEFAULT(50);

--task_20
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

--task_21
        INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES
(1, 'Wireless Mouse', 'Gadgets', 19.99, '2.4GHz nano receiver'),
(2, 'LED Strip 5m', 'Home Decor', 12.50, 'USB powered RGB'),
(3, 'Phone Stand', 'Accessories', 8.99, 'Aluminum, foldable'),
(4, 'Water Bottle', 'Fitness', 14.00, 'BPA-free 1L'),
(5, 'Desk Organizer', 'Office', 11.75, 'Modular trays');

--task_22
      SELECT *
INTO Products_Backup
FROM Products;

--task_23
        EXEC sp_rename 'Products', 'Inventory'

--task_24
        Alter table Inventory
        Alter Column Price FLOAT

--task_25
