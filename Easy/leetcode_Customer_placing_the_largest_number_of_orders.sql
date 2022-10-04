-- Question 8
-- Query the customer_number from the orders table for the customer who has placed the largest number of orders.

-- It is guaranteed that exactly one customer will have placed more orders than any other customer.

-- The orders table is defined as follows:

-- | Column            | Type      |
-- |-------------------|-----------|
-- | order_number (PK) | int       |
-- | customer_number   | int       |
-- | order_date        | date      |
-- | required_date     | date      |
-- | shipped_date      | date      |
-- | status            | char(15)  |
-- | comment           | char(200) |
-- Sample Input

-- | order_number | customer_number | order_date | required_date | shipped_date | status | comment |
-- |--------------|-----------------|------------|---------------|--------------|--------|---------|
-- | 1            | 1               | 2017-04-09 | 2017-04-13    | 2017-04-12   | Closed |         |
-- | 2            | 2               | 2017-04-15 | 2017-04-20    | 2017-04-18   | Closed |         |
-- | 3            | 3               | 2017-04-16 | 2017-04-25    | 2017-04-20   | Closed |         |
-- | 4            | 3               | 2017-04-18 | 2017-04-28    | 2017-04-25   | Closed |         |
-- Sample Output

-- | customer_number |
-- |-----------------|
-- | 3               |
-- Explanation

-- The customer with number '3' has two orders, 
-- which is greater than either customer '1' or '2' because each of them  only has one order. 
-- So the result is customer_number '3'.


-- Solution
-- Ranking them according to the number of orders to have same rank for 
-- customers with same number of orders

CREATE DATABASE leetcode_Customer_placing_the_largest_number_of_orders
GO

USE leetcode_Customer_placing_the_largest_number_of_orders
GO

Create table orders (
 order_number int,
 customer_number int,
 order_date date,
 required_date date,
 shipped_date date,
 status char(15),
 comment char(200),
 PRIMARY KEY(order_number)
);
GO

insert into orders (order_number, customer_number)
 values ('1', '1');
GO
insert into orders (order_number, customer_number)
 values ('2', '2');
GO
insert into orders (order_number, customer_number)
 values ('3', '3');
GO
insert into orders (order_number, customer_number)
 values ('4', '3');
GO

SELECT customer_number
FROM dbo.orders
GROUP BY customer_number
HAVING COUNT(customer_number) = (
	SELECT MAX(order_count)
	FROM (
		SELECT COUNT(order_number) order_count FROM dbo.orders GROUP BY customer_number
	) A
)

SELECT A.customer_number
FROM(
	SELECT customer_number,
			RANK() OVER(ORDER BY COUNT(customer_number) desc) rk
	FROM dbo.orders
	GROUP BY customer_number
) A WHERE A.rk = 1