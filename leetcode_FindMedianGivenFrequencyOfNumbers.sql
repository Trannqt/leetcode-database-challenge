-- Question 107
-- The Numbers table keeps the value of number and its frequency.

-- +----------+-------------+
-- |  Number  |  Frequency  |
-- +----------+-------------|
-- |  0       |  7          |
-- |  1       |  1          |
-- |  2       |  3          |
-- |  3       |  1          |
-- +----------+-------------+
-- In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

-- +--------+
-- | median |
-- +--------|
-- | 0.0000 |
-- +--------+
-- Write a query to find the median of all numbers and name the result as median.

-- 0 0 0 0 0 0 0 1 2 2 2 3 3 4
WITH Numbers(Number, Frequency)
AS
(
	SELECT 0, 7 UNION ALL
	SELECT 1, 1 UNION ALL
	SELECT 2, 3 UNION ALL
	SELECT 3, 2 UNION ALL
	SELECT 4, 1 
),
solution AS 
(
	SELECT *, 
			SUM(Numbers.Frequency) OVER(ORDER BY Numbers.Number ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_distance,
			(SUM(Numbers.Frequency) OVER())/2 middle
	FROM Numbers
)

SELECT AVG(number) median 
FROM solution
WHERE solution.middle BETWEEN solution.sum_distance-solution.Frequency AND solution.sum_distance