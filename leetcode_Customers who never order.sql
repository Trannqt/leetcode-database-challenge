-- Question 13
-- Suppose that a website contains two tables, 
-- the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

-- Table: Customers.

-- +----+-------+
-- | Id | Name  |
-- +----+-------+
-- | 1  | Joe   |
-- | 2  | Henry |
-- | 3  | Sam   |
-- | 4  | Max   |
-- +----+-------+
-- Table: Orders.

-- +----+------------+
-- | Id | CustomerId |
-- +----+------------+
-- | 1  | 3          |
-- | 2  | 1          |
-- +----+------------+
-- Using the above tables as example, return the following:

-- +-----------+
-- | Customers |
-- +-----------+
-- | Henry     |
-- | Max       |
-- +-----------+

-- Solution

CREATE DATABASE leetcode
GO

USE leetcode
GO

CREATE TABLE Customers_Customerswhoneverorder
(
	Id INT,
	Name VARCHAR(100)
)
GO

CREATE TABLE Orders_Customerswhoneverorder
(
	Id INT,
	CustomerId INT
)
GO

INSERT INTO dbo.Customers_Customerswhoneverorder
        ( Id, Name )
VALUES  ( 1, 'Joe'),
		( 2, 'Henry'),
		( 3, 'Sam'),
		( 4, 'Max')
GO

INSERT INTO dbo.Orders_Customerswhoneverorder
        ( Id, CustomerId )
VALUES  ( 1, -- Id - int
          3  -- CustomerId - int
          ),
		  ( 2, -- Id - int
          1  -- CustomerId - int
          )
GO

--solution
SELECT C.Name As Customers
FROM Customers_Customerswhoneverorder C
LEFT JOIN Orders_Customerswhoneverorder O ON O.CustomerId = C.Id
WHERE O.CustomerId IS NULL 