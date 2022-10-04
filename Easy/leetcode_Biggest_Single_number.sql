-- Question 24
-- Table my_numbers contains many numbers in column num including duplicated ones.
-- Can you write a SQL query to find the biggest number, which only appears once.

-- +---+
-- |num|
-- +---+
-- | 8 |
-- | 8 |
-- | 3 |
-- | 3 |
-- | 1 |
-- | 4 |
-- | 5 |
-- | 6 | 
-- For the sample data above, your query should return the following result:
-- +---+
-- |num|
-- +---+
-- | 6 |
-- Note:
-- If there is no such number, just output null.

-- Solution
CREATE DATABASE leetcode_Biggest_Single_number
GO
USE leetcode_Biggest_Single_number
GO 
CREATE TABLE number
(
	num int
)
GO
INSERT INTO dbo.number
        ( num )
VALUES  ( 8 ),
		( 8 ),
		( 3 ),
		( 3 ),
		( 1 ),
		( 4 ),
		( 5 ),
		( 6 )

--solution
SELECT MAX(R.num) num
FROM(
	SELECT num
	FROM dbo.number
	GROUP BY num
	HAVING COUNT(*)<2
) R
