                                                                      --EASY--
--task1
Data yani malumotlar bularga(ism, id, yosh, gender va xokozolar kiradi ) bularsiz muxum bir qaror qilib bo'lmaydi.

Database malumotlar bazasi bu jadvallar, malumotlarni barcha saralangani va saralanmagani bo'lgan bazasi, asosan ularni tez-tez yangilab turishimiz kerak.

Relational database yani  Ma’lumotlar jadvallar ko‘rinishida, primary/foreign keylar bilan bog‘lanadigan baza turi (masalan, SQL Server).

Table (jadval): Qatorlar (rows) va ustunlar (columns) dan iborat bo'ladi.

--taks2
Ma’lumotlarni saqlash – SQL Server katta hajmdagi ma’lumotlarni xavfsiz saqlash uchun ishlatiladi.

Tez qidirish va olish – indekslar yordamida ma’lumotlarni juda tez topish mumkin.

Xavfsizlik – parol, foydalanuvchi ruxsatlari va boshqa himoya usullari mavjud.

Zaxira nusxa olish – ma’lumotlarni backup qilib saqlab qo‘yish va keyin tiklash mumkin.

Ko‘p foydalanuvchi bilan ishlash – bir vaqtning o‘zida ko‘plab odamlar bitta bazada ishlashi mumkin.

--task3
Windows Authentication – Kamputerda Windows bilan kirdim, va shu zaxoti  SQL Server ham shu hisob orqali avtomatik tanib oladi. Parol kiritish shart bo‘lmaydi.

SQL Server Authentication – SQL Server uchun alohida login va parol yaratiladi. Ulanish uchun shu login va parolni kiritish kerak bo‘ladi.

                                                                       --MEDIUM--

    CREATE DATABASE class_1;
GO

USE class_1;
GO

CREATE TABLE dbo.students
(
    id         INT         NOT NULL PRIMARY KEY,
    name       VARCHAR(30) NOT NULL,
    group_name VARCHAR(30) NOT NULL,
    age        INT         NOT NULL,
    status     BIT         NOT NULL     -- 1 = true, 0 = false
);
GO

INSERT INTO dbo.students (id, name, group_name, age, status) VALUES
(1, 'Mavlonbek', 'Artificial Intelligence', 20, 1),
(2, 'Abbos',     'Computer Science',       25, 1),
(3, 'Oybek',     'Artificial Intelligence',21, 0),
(4, 'Ilyos',     'Computer Science',       27, 0),
(5, 'Jamshid',   'Artificial Intelligence',24, 1),
(6, 'Ali',       'Artificial Intelligence',26, 0),
(7, 'Qosim',     'Computer Science',       23, 1),
(8, 'Usmon',     'Artificial Intelligence',22, 0);
GO

UPDATE dbo.students 
set name = 'Munisa';
where id = 4

GO
SELECT *
FROM dbo.students
ORDER BY id;

SQL Server, SSMS va SQL farqlari:

SQL Server – bu ma’lumotlar bazasini saqliydigan va boshqaradigan (server). Hamma ma’lumotlar shu yerda turadi.

SSMS (SQL Server Management Studio) – bu SQL Server bilan ishlash uchun kerak bo'ladi va Afsuski faqat Windowsni paderjka qiladi :( .

SQL – bu programming language . Datani searching, adding, deleting  va changing uchun komandalar yozamiz yozamiz.


                                                                           --HARD--

SQL buyruqlar oilalari – SQL buyruqlari bir nechta guruhlarga bo‘linadi:

DQL (Data Query Language) – ma’lumotlarni qidirish

Ta’rif: Bazadan ma’lumot olish uchun ishlatiladi.

Asosiy buyruq: SELECT

Misol:

SELECT name, age FROM Students WHERE age > 18;


DML (Data Manipulation Language) – ma’lumotlar bilan ishlash

Ta’rif: Ma’lumot qo‘shish, o‘chirish yoki o‘zgartirish uchun ishlatiladi.

Asosiy buyruqlar: INSERT, UPDATE, DELETE

Misol:

INSERT INTO Students (id, name, age) VALUES (1, 'Ali', 20);
UPDATE Students SET age = 21 WHERE id = 1;
DELETE FROM Students WHERE id = 1;


DDL (Data Definition Language) – jadval va baza tuzilishini boshqarish

Ta’rif: Jadval, baza, ustun va boshqa obyektlarni yaratish yoki o‘zgartirish uchun ishlatiladi.

Asosiy buyruqlar: CREATE, ALTER, DROP

Misol:

CREATE TABLE Students (id INT, name VARCHAR(50));
ALTER TABLE Students ADD age INT;
DROP TABLE Students;


DCL (Data Control Language) – foydalanuvchi ruxsatlarini boshqarish

Ta’rif: Kimga qanday ruxsat berilishini boshqaradi.

Asosiy buyruqlar: GRANT, REVOKE

Misol:

GRANT SELECT ON Students TO user1;
REVOKE SELECT ON Students FROM user1;


TCL (Transaction Control Language) – tranzaksiyalarni boshqarish

Ta’rif: Bir nechta buyruqni bitta paket sifatida bajarish yoki bekor qilish.

Asosiy buyruqlar: BEGIN, COMMIT, ROLLBACK

Misol:

BEGIN TRAN;
  UPDATE Students SET age = age + 1;
COMMIT;
-- yoki xato bo‘lsa
ROLLBACK;






