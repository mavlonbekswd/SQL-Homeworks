--1)
SELECT
    R.Region,
    D.Distributor,
    ISNULL(S.Sales, 0) AS Sales
FROM D
CROSS JOIN R
LEFT JOIN #RegionSales S
       ON S.Region = R.Region
      AND S.Distributor = D.Distributor
-- (Optional) nice ordering: North, South, East, West within each distributor
ORDER BY
    D.Distributor,
    CASE R.Region
         WHEN 'North' THEN 1
         WHEN 'South' THEN 2
         WHEN 'East'  THEN 3
         WHEN 'West'  THEN 4
         ELSE 5
    END;

--2)-- Find managers with 5 or more direct reports
SELECT 
    m.name
FROM Employee e
JOIN Employee m
    ON e.managerId = m.id
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5;

--3)Get the names of products that have at least 100 units ordered in February 2020 and their total ordered amount.


SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Products p
JOIN Orders o
    ON p.product_id = o.product_id
WHERE 
    o.order_date >= '2020-02-01' 
    AND o.order_date < '2020-03-01'
GROUP BY 
    p.product_name
HAVING 
    SUM(o.unit) >= 100;

--4) Return the vendor from which each customer has placed the most orders.


SELECT 
    CustomerID,
    Vendor
FROM (
    SELECT 
        CustomerID,
        Vendor,
        SUM([Count]) AS TotalOrders,
        RANK() OVER (PARTITION BY CustomerID ORDER BY SUM([Count]) DESC) AS rnk
    FROM Orders
    GROUP BY CustomerID, Vendor
) AS RankedVendors
WHERE rnk = 1;

--5. Check if a Number is Prime
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2, @IsPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @IsPrime = 0;
        BREAK;
    END
    SET @i = @i + 1;
END

IF @IsPrime = 1 AND @Check_Prime > 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';



-- 6. Return number of locations, most signals sent location, and total signals
SELECT 
    Device_id,
    COUNT(DISTINCT Locations) AS no_of_location,
    MAX(Locations) WITHIN GROUP (ORDER BY COUNT(*) DESC) AS max_signal_location,
    COUNT(*) AS no_of_signals
FROM Device
GROUP BY Device_id;


WITH LocationCount AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS SignalCount
    FROM Device
    GROUP BY Device_id, Locations
),
Ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY SignalCount DESC) AS rn
    FROM LocationCount
)
SELECT 
    Device_id,
    (SELECT COUNT(DISTINCT Locations) FROM Device d WHERE d.Device_id = l.Device_id) AS no_of_location,
    Locations AS max_signal_location,
    (SELECT COUNT(*) FROM Device d WHERE d.Device_id = l.Device_id) AS no_of_signals
FROM Ranked l
WHERE rn = 1;


-- 7. Employees earning more than department average
SELECT 
    e.EmpID, 
    e.EmpName, 
    e.Salary
FROM Employee e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);

-- 9. Find total number of users and amount spent per date & platform
WITH UserPlatform AS (
    SELECT 
        Spend_date,
        User_id,
        SUM(Amount) AS TotalAmount,
        COUNT(DISTINCT Platform) AS PlatformCount
    FROM Spending
    GROUP BY Spend_date, User_id
),
Category AS (
    SELECT 
        s.Spend_date,
        CASE 
            WHEN COUNT(DISTINCT s.Platform) = 2 THEN 'Both'
            ELSE MAX(s.Platform)
        END AS Platform,
        SUM(s.Amount) AS Total_Amount,
        COUNT(DISTINCT s.User_id) AS Total_users
    FROM Spending s
    GROUP BY s.Spend_date, s.User_id
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Spend_date, Platform) AS Row,
    Spend_date,
    Platform,
    SUM(Total_Amount) AS Total_Amount,
    COUNT(Total_users) AS Total_users
FROM Category
GROUP BY Spend_date, Platform
ORDER BY Spend_date, Platform;

--10)

WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL SELECT n + 1 FROM Numbers WHERE n < 100  -- create sequence
)
SELECT 
    g.Product,
    1 AS Quantity
FROM Grouped g
JOIN Numbers n
    ON n.n <= g.Quantity
ORDER BY g.Product
OPTION (MAXRECURSION 0);
