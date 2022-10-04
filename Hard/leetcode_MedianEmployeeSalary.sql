-- Question 105
-- The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |1    | A          | 2341   |
-- |2    | A          | 341    |
-- |3    | A          | 15     |
-- |4    | A          | 15314  |
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |7    | B          | 15     |
-- |8    | B          | 13     |
-- |9    | B          | 1154   |
-- |10   | B          | 1345   |
-- |11   | B          | 1221   |
-- |12   | B          | 234    |
-- |13   | C          | 2345   |
-- |14   | C          | 2645   |
-- |15   | C          | 2645   |
-- |16   | C          | 2652   |
-- |17   | C          | 65     |
-- +-----+------------+--------+
-- Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |12   | B          | 234    |
-- |9    | B          | 1154   |
-- |14   | C          | 2645   |
-- +-----+------------+--------+

-- Solution

WITH Employee (Id, Company, Salary)
AS
(
	SELECT 1 , 'A', 2341  UNION ALL
	SELECT 2 , 'A', 341   UNION ALL
	SELECT 3 , 'A', 15    UNION ALL
	SELECT 4 , 'A', 15314 UNION ALL
	SELECT 5 , 'A', 451   UNION ALL
	SELECT 6 , 'A', 513   UNION ALL
	SELECT 7 , 'B', 15    UNION ALL
	SELECT 8 , 'B', 13    UNION ALL
	SELECT 9 , 'B', 1154  UNION ALL
	SELECT 10, 'B', 1345  UNION ALL
	SELECT 11, 'B', 1221  UNION ALL
	SELECT 12, 'B', 234   UNION ALL
	SELECT 13, 'C', 2345  UNION ALL
	SELECT 14, 'C', 2645  UNION ALL
	SELECT 15, 'C', 2645  UNION ALL
	SELECT 16, 'C', 2652  UNION ALL
	SELECT 17, 'C', 65    
)

SELECT  Id ,
        Company ,
        Salary
FROM    ( SELECT    * ,
                    ROW_NUMBER() OVER ( PARTITION BY Company ORDER BY Salary ) AS rn ,
                    COUNT(*) OVER ( PARTITION BY Company ) AS cnt
          FROM      Employee
        ) a
WHERE   rn BETWEEN cnt / 2 AND (cnt / 2) + CASE WHEN a.cnt%2=1 THEN 0 ELSE 1 end