-- Question 99
-- X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

-- Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

-- For example, the table stadium:
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 1    | 2017-01-01 | 10        |
-- | 2    | 2017-01-02 | 109       |
-- | 3    | 2017-01-03 | 150       |
-- | 4    | 2017-01-04 | 99        |
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- For the sample data above, the output is:

-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- Note:
-- Each day only have one row record, and the dates are increasing with id increasing.

-- Solution

WITH Stadium(id, visit_date, people)
AS
(
	SELECT 1, '2017-01-01', 10   UNION ALL
	SELECT 2, '2017-01-02', 109  UNION ALL
	SELECT 3, '2017-01-03', 150  UNION ALL
	SELECT 4, '2017-01-04', 99   UNION ALL
	SELECT 5, '2017-01-05', 145  UNION ALL
	SELECT 6, '2017-01-06', 1455 UNION ALL
	SELECT 7, '2017-01-07', 199  UNION ALL
	SELECT 8, '2017-01-08', 188 
),
cte AS(
	SELECT 
		id , 
		visit_date, 
		people,
		LEAD(people, 1) OVER(ORDER BY id) as next,
		LEAD(people, 2) OVER(ORDER By id) as next2,
		LAG(people, 1) OVER(ORDER BY id ) as prev,
		LAG(people, 2) OVER(ORDER BY id) as prev2
	FROM Stadium
)

--SELECT *
--FROM cte

SELECT 
	id,
	visit_date,
	people
FROM cte 
WHERE (cte.people >= 100 AND cte.next >= 100 AND cte.next2>=100)
	OR (cte.people >= 100 AND cte.next >= 100 AND cte.prev >= 100)
	OR (cte.people >= 100 AND cte.prev >=100 AND cte.prev2 >=100)
ORDER BY visit_date

