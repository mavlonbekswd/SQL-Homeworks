

-- 1) Create & populate the temp table for the current month
DROP TABLE IF EXISTS #MonthlySales;

DECLARE @StartOfMonth date = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
DECLARE @StartOfNextMonth date = DATEADD(MONTH, 1, @StartOfMonth);

CREATE TABLE #MonthlySales
(
    ProductID     INT PRIMARY KEY,
    TotalQuantity INT,
    TotalRevenue  DECIMAL(18,2)
);

INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT
    s.ProductID,
    SUM(s.Quantity)                                     AS TotalQuantity,
    CAST(SUM(s.Quantity * p.Price) AS DECIMAL(18,2))    AS TotalRevenue
FROM Sales s
JOIN Products p ON p.ProductID = s.ProductID
WHERE s.SaleDate >= @StartOfMonth
  AND s.SaleDate <  @StartOfNextMonth
GROUP BY s.ProductID;



-- 2) Create the view
DROP VIEW IF EXISTS dbo.vw_ProductSalesSummary;
GO
CREATE VIEW dbo.vw_ProductSalesSummary
AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    COALESCE(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON s.ProductID = p.ProductID
GROUP BY
    p.ProductID, p.ProductName, p.Category;
GO


--3) Scalar function: fn_GetTotalRevenueForProduct(@ProductID)

-- 3) Create the scalar function
DROP FUNCTION IF EXISTS dbo.fn_GetTotalRevenueForProduct;
GO
CREATE FUNCTION dbo.fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);

    SELECT @Revenue = CAST(SUM(s.Quantity * p.Price) AS DECIMAL(18,2))
    FROM Sales s
    JOIN Products p ON p.ProductID = s.ProductID
    WHERE s.ProductID = @ProductID;

    RETURN ISNULL(@Revenue, 0.00);
END
GO



-- 4) Create the inline table-valued function
DROP FUNCTION IF EXISTS dbo.fn_GetSalesByCategory;
GO
CREATE FUNCTION dbo.fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.ProductName,
        COALESCE(SUM(s.Quantity), 0)                                  AS TotalQuantity,
        CAST(COALESCE(SUM(s.Quantity * p.Price), 0) AS DECIMAL(18,2)) AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON s.ProductID = p.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);
GO



--5 Goal: Return 'Yes' if the input number is prime, 'No' otherwise.

-- Drop function if it already exists
DROP FUNCTION IF EXISTS dbo.fn_IsPrime;
GO

CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(5)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime BIT = 1;

    -- Numbers less than 2 are NOT prime
    IF @Number < 2
        RETURN 'No';

    -- Check divisibility from 2 up to sqrt(Number)
    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END

    IF @IsPrime = 1 
        RETURN 'Yes';
    ELSE 
        RETURN 'No';
END;
GO

-- ✅ Example usage:
SELECT dbo.fn_IsPrime(2) AS Result1,      -- Yes
       dbo.fn_IsPrime(4) AS Result2,      -- No
       dbo.fn_IsPrime(17) AS Result3;     -- Yes




--6. Goal: Return a table of all integers between two given numbers (inclusive).


GO

CREATE FUNCTION dbo.fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;

    WHILE @i <= @End
    BEGIN
        INSERT INTO @Numbers VALUES (@i);
        SET @i = @i + 1;
    END

    RETURN;
END;
GO

--8.
-- Count each friendship for both people, then pick the max
WITH edges AS (
    SELECT requester_id AS id, accepter_id AS friend_id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id, requester_id AS friend_id
    FROM RequestAccepted
),
counts AS (
    SELECT id, COUNT(DISTINCT friend_id) AS num
    FROM edges
    GROUP BY id
)
SELECT TOP 1 id, num
FROM counts
ORDER BY num DESC, id;   -- id tie-break optional

--9 

DROP VIEW IF EXISTS vw_CustomerOrderSummary;
GO

-- Create the view
CREATE VIEW vw_CustomerOrderSummary
AS
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.name;
GO

--10)
SELECT 
    g.RowNumber,
    COALESCE(
        g.TestCase,
        (
            SELECT TOP 1 g2.TestCase
            FROM Gaps g2
            WHERE g2.RowNumber < g.RowNumber 
              AND g2.TestCase IS NOT NULL
            ORDER BY g2.RowNumber DESC
        )
    ) AS Workflow
FROM Gaps g
ORDER BY g.RowNumber;

