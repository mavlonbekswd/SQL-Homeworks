-- 1. Running Total Sales per Customer
SELECT customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS RunningTotal
FROM sales_data;

-- 2. Number of Orders per Product Category
SELECT product_category, COUNT(*) AS OrderCount
FROM sales_data
GROUP BY product_category;

-- 3. Maximum Total Amount per Product Category
SELECT product_category, MAX(total_amount) AS MaxAmount
FROM sales_data
GROUP BY product_category;

-- 4. Minimum Price of Products per Product Category
SELECT product_category, MIN(unit_price) AS MinPrice
FROM sales_data
GROUP BY product_category;

-- 5. Moving Average of Sales of 3 Days (prev, curr, next)
SELECT order_date, total_amount,
       AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM sales_data;

-- 6. Total Sales per Region
SELECT region, SUM(total_amount) AS TotalSales
FROM sales_data
GROUP BY region;

-- 7. Rank of Customers Based on Their Total Purchase Amount
SELECT customer_name, SUM(total_amount) AS TotalPurchase,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS CustomerRank
FROM sales_data
GROUP BY customer_name;

-- 8. Difference Between Current and Previous Sale Amount per Customer
SELECT customer_name, order_date, total_amount,
       total_amount - LAG(total_amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS DiffFromPrev
FROM sales_data;

-- 9. Top 3 Most Expensive Products in Each Category
SELECT *
FROM (
    SELECT product_category, product_name, unit_price,
           DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rnk
    FROM sales_data
) AS t
WHERE rnk <= 3;

-- 10. Cumulative Sum of Sales per Region by Order Date
SELECT region, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS CumulativeSales
FROM sales_data;
-- 11. Compute Cumulative Revenue per Product Category
SELECT product_category, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS CumulativeRevenue
FROM sales_data;

-- 12. Sum of Previous Values (Sample Input)
CREATE TABLE Numbers (ID INT);
INSERT INTO Numbers VALUES (1), (2), (3), (4), (5);

SELECT ID,
       SUM(ID) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS SumPreValues
FROM Numbers;

-- 13. Sum of Previous Values to Current Value
CREATE TABLE OneColumn (Value SMALLINT);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

SELECT Value,
       SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS [Sum of Previous]
FROM OneColumn;

-- 14. Customers who purchased items from more than one product_category
SELECT customer_name
FROM sales_data
GROUP BY customer_name
HAVING COUNT(DISTINCT product_category) > 1;

-- 15. Customers with Above-Average Spending in Their Region
SELECT customer_name, region, SUM(total_amount) AS TotalSpent
FROM sales_data
GROUP BY customer_name, region
HAVING SUM(total_amount) > (
    SELECT AVG(total_amount)
    FROM sales_data s2
    WHERE s2.region = sales_data.region
);

-- 16. Rank customers based on total spending within each region
SELECT region, customer_name, SUM(total_amount) AS TotalSpent,
       DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS RankByRegion
FROM sales_data
GROUP BY region, customer_name;

-- 17. Running total (cumulative_sales) per customer
SELECT customer_id, customer_name, order_date, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS CumulativeSales
FROM sales_data;

-- 18. Sales growth rate for each month compared to previous month
SELECT DISTINCT
       FORMAT(order_date, 'yyyy-MM') AS Month,
       SUM(total_amount) OVER (PARTITION BY FORMAT(order_date, 'yyyy-MM')) AS MonthlySales,
       (SUM(total_amount) OVER (PARTITION BY FORMAT(order_date, 'yyyy-MM'))
       - LAG(SUM(total_amount) OVER (PARTITION BY FORMAT(order_date, 'yyyy-MM'))) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')))
       / NULLIF(LAG(SUM(total_amount) OVER (PARTITION BY FORMAT(order_date, 'yyyy-MM'))) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')), 0) * 100 AS GrowthRate
FROM sales_data;

-- 19. Customers whose total_amount is higher than their last order
SELECT customer_id, customer_name, order_date, total_amount
FROM (
    SELECT *, LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS PrevAmount
    FROM sales_data
) AS t
WHERE total_amount > PrevAmount;
-- 20. Identify Products whose prices are above the average product price
SELECT product_name, product_category, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

-- 21. Sum of val1 and val2 for each group (show at beginning of each group)
CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29),(2,1,19,0),(3,1,11,45),(4,2,0,0),(5,2,100,17);

SELECT Id, Grp, Val1, Val2,
       CASE WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1
            THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
       END AS Tot
FROM MyData;

-- 22. Sum up cost and quantity by Id
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164),(1234,13,164),(1235,100,130),(1235,100,135),(1236,12,136);

SELECT ID, SUM(Cost) AS Cost, MAX(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

-- 23. Find continuous seat ranges
CREATE TABLE Seats (SeatNumber INT);
INSERT INTO Seats VALUES
(7),(13),(14),(15),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(52),(53),(54);

SELECT MIN(SeatNumber) AS StartSeat, MAX(SeatNumber) AS EndSeat
FROM (
    SELECT SeatNumber,
           SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS grp
    FROM Seats
) AS t
GROUP BY grp
ORDER BY StartSeat;

