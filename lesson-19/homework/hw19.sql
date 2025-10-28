--Task1
CREATE PROCEDURE sp_GetEmployeeBonus
AS
BEGIN
    -- Create temporary table
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    -- Insert data with calculated Bonus
    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Department,
        e.Salary,
        (e.Salary * db.BonusPercentage / 100) AS BonusAmount
    FROM Employees e
    INNER JOIN DepartmentBonus db
        ON e.Department = db.Department;

    -- Return the data
    SELECT * FROM #EmployeeBonus;
END;
GO

EXEC sp_GetEmployeeBonus;


--Task 2
CREATE PROCEDURE sp_UpdateDepartmentSalary
    @Department NVARCHAR(50),
    @IncreasePercent DECIMAL(5,2)
AS
BEGIN
    -- Update the salaries
    UPDATE Employees
    SET Salary = Salary + (Salary * @IncreasePercent / 100)
    WHERE Department = @Department;

    -- Return updated employees
    SELECT 
        EmployeeID,
        FirstName + ' ' + LastName AS FullName,
        Department,
        Salary
    FROM Employees
    WHERE Department = @Department;
END;
GO
EXEC sp_UpdateDepartmentSalary @Department = 'Sales', @IncreasePercent = 10;

--Task 3 — MERGE Products_New into Products_Current
/* 1) Update matches, 2) insert new rows, 3) delete rows missing in source */
MERGE dbo.Products_Current AS tgt
USING dbo.Products_New     AS src
  ON tgt.ProductID = src.ProductID
WHEN MATCHED THEN
  UPDATE SET
      tgt.ProductName = src.ProductName,
      tgt.Price       = src.Price
WHEN NOT MATCHED BY TARGET THEN             -- exists in src, not in tgt  -> INSERT
  INSERT (ProductID, ProductName, Price)
  VALUES (src.ProductID, src.ProductName, src.Price)
WHEN NOT MATCHED BY SOURCE THEN             -- exists in tgt, not in src  -> DELETE
  DELETE
;

-- Final state after MERGE
SELECT ProductID, ProductName, Price
FROM   dbo.Products_Current
ORDER  BY ProductID;


--Task 4 — Classify each tree node as Root / Inner / Leaf
SELECT
    t.id,
    CASE
        WHEN t.p_id IS NULL                THEN 'Root'                                  -- no parent
        WHEN EXISTS (SELECT 1
                     FROM dbo.Tree c
                     WHERE c.p_id = t.id)  THEN 'Inner'                                 -- has children
        ELSE 'Leaf'                                                                      -- has parent but no children
    END AS type
FROM dbo.Tree AS t
ORDER BY t.id;

--task5 
SELECT 
    s.user_id,
    COALESCE(
        ROUND(
            SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 /
            NULLIF(COUNT(c.action), 0), 
        2), 
    0) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c 
    ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id DESC;

--task6
SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

--task7
CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantitySold,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s 
        ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
