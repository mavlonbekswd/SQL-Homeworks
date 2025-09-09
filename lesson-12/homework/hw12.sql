
--puzzle1
SELECT 
    p.firstName, 
    p.lastName, 
    a.city, 
    a.state
FROM Person p
LEFT JOIN Address a
    ON p.personId = a.personId;

--puzzle2

SELECT e.name AS Employee
FROM Employee e
JOIN Employee m
    ON e.managerId = m.id
WHERE e.salary > m.salary;

--puzzle3
SELECT email AS Email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;

--puzzle 4
DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);

--puzzle 5
SELECT DISTINCT g.ParentName
FROM girls g
LEFT JOIN boys b
    ON g.ParentName = b.ParentName
WHERE b.ParentName IS NULL;

--puzzle 7
SELECT 
    c1.Item AS [Item Cart 1],
    c2.Item AS [Item Cart 2]
FROM Cart1 c1
FULL OUTER JOIN Cart2 c2
    ON c1.Item = c2.Item;

--puzzle 8
SELECT c.name AS Customers
FROM Customers c
LEFT JOIN Orders o
    ON c.id = o.customerId
WHERE o.id IS NULL;

--puzzle 9
SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub               -- har bir talaba uchun barcha fanlar
LEFT JOIN Examinations e              -- bor imtihon yozuvlarini qo‘shamiz
    ON e.student_id = s.student_id
   AND e.subject_name = sub.subject_name
GROUP BY 
    s.student_id, s.student_name, sub.subject_name
ORDER BY 
    s.student_id, sub.subject_name;

