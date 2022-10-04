-- Question 39
-- Table: Prices

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | start_date    | date    |
-- | end_date      | date    |
-- | price         | int     |
-- +---------------+---------+
-- (product_id, start_date, end_date) is the primary key for this table.
-- Each row of this table indicates the price of the product_id in the period from start_date to end_date.
-- For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

-- Table: UnitsSold

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | purchase_date | date    |
-- | units         | int     |
-- +---------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- Each row of this table indicates the date, units and product_id of each product sold. 
 

-- Write an SQL query to find the average selling price for each product.

-- average_price should be rounded to 2 decimal places.

-- The query result format is in the following example:

-- Prices table:
-- +------------+------------+------------+--------+
-- | product_id | start_date | end_date   | price  |
-- +------------+------------+------------+--------+
-- | 1          | 2019-02-17 | 2019-02-28 | 5      |
-- | 1          | 2019-03-01 | 2019-03-22 | 20     |
-- | 2          | 2019-02-01 | 2019-02-20 | 15     |
-- | 2          | 2019-02-21 | 2019-03-31 | 30     |
-- +------------+------------+------------+--------+
 
-- UnitsSold table:
-- +------------+---------------+-------+
-- | product_id | purchase_date | units |
-- +------------+---------------+-------+
-- | 1          | 2019-02-25    | 100   |
-- | 1          | 2019-03-01    | 15    |
-- | 2          | 2019-02-10    | 200   |
-- | 2          | 2019-03-22    | 30    |
-- +------------+---------------+-------+

-- Result table:
-- +------------+---------------+
-- | product_id | average_price |
-- +------------+---------------+
-- | 1          | 6.96          |
-- | 2          | 16.96         |
-- +------------+---------------+
-- Average selling price = Total Price of Product / Number of products sold.
-- Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
-- Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96

-- Solution

CREATE DATABASE leetcode_Average_selling_price
GO

USE leetcode_Average_selling_price
GO

CREATE TABLE Prices
(
	product_id    INT,
	start_date    DATE,
	end_date      DATE,
	price         INT,
	PRIMARY KEY(product_id, start_date, end_date)
)
GO

CREATE TABLE UnitsSold
(
	product_id    INT,
	purchase_date DATE,
	units         INT 
)

INSERT INTO dbo.Prices
        ( product_id ,
          start_date ,
          end_date ,
          price
        )
VALUES  ( 1 , -- product_id - int
          '2019-02-17' , -- start_date - date
          '2019-02-28' , -- end_date - date
          5 -- price - int
        ),
		( 1 , -- product_id - int
          '2019-03-01' , -- start_date - date
          '2019-03-22' , -- end_date - date
          20 -- price - int
        ),
		( 2 , -- product_id - int
          '2019-02-01' , -- start_date - date
          '2019-02-20' , -- end_date - date
          15 -- price - int
        ),
		( 2 , -- product_id - int
          '2019-02-21' , -- start_date - date
          '2019-03-31' , -- end_date - date
          30 -- price - int
        )
GO

INSERT INTO dbo.UnitsSold
        ( product_id, purchase_date, units )
VALUES  ( 1, -- product_id - int
          '2019-02-25', -- purchase_date - date
          100  -- units - int
          ),
		  ( 1, -- product_id - int
          '2019-03-01', -- purchase_date - date
          15  -- units - int
          ),
		  ( 2, -- product_id - int
          '2019-03-01', -- purchase_date - date
          200  -- units - int
          ),
		  ( 2, -- product_id - int
          '2019-03-22', -- purchase_date - date
          30  -- units - int
          )
GO


SELECT R.product_id, ISNULL(ROUND(SUM(R.price*R.units*1.0)/NULLIF(SUM(R.units),0),2),0) average_price 
FROM(
SELECT P.product_id, P.price, U.units
FROM dbo.Prices P
LEFT JOIN dbo.UnitsSold U ON U.product_id = P.product_id
WHERE P.start_date <= U.purchase_date AND U.purchase_date <= P.end_date
) R
GROUP BY R.product_id

