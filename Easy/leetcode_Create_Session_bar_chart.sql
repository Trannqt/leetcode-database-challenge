-- Question 2
-- Table: Sessions

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | session_id          | int     |
-- | duration            | int     |
-- +---------------------+---------+
-- session_id is the primary key for this table.
-- duration is the time in seconds that a user has visited the application.
 

-- You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>" and "15 minutes or more" and count the number of sessions on it.

-- Write an SQL query to report the (bin, total) in any order.

-- The query result format is in the following example.

-- Sessions table:
-- +-------------+---------------+
-- | session_id  | duration      |
-- +-------------+---------------+
-- | 1           | 30            |
-- | 2           | 199           |
-- | 3           | 299           |
-- | 4           | 580           |
-- | 5           | 1000          |
-- +-------------+---------------+

-- Result table:
-- +--------------+--------------+
-- | bin          | total        |
-- +--------------+--------------+
-- | [0-5>        | 3            |
-- | [5-10>       | 1            |
-- | [10-15>      | 0            |
-- | 15 or more   | 1            |
-- +--------------+--------------+

-- For session_id 1, 2 and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
-- For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
-- There are no session with a duration greater or equial than 10 minutes and less than 15 minutes.
-- For session_id 5 has a duration greater or equal than 15 minutes.

CREATE DATABASE leetcode_Create_Session_bar_chart
GO

USE leetcode_Create_Session_bar_chart
GO

CREATE TABLE Sessions
(
	session_id          INT,
	duration            INT 
)

GO

INSERT INTO dbo.Sessions
        ( session_id, duration )
VALUES  ( 1, 30   ),
		( 2, 199  ),
		( 3, 299  ),
		( 4, 580  ),
		( 5, 1000 )
GO

SELECT '[0-5>' AS bin, SUM(CASE WHEN duration/60 < 5 THEN 1 ELSE 0 END) Total
FROM dbo.Sessions
UNION 
SELECT '[5-10>' AS bin, SUM(CASE WHEN duration/60 >= 5 AND duration/60 < 10 THEN 1 ELSE 0 END) AS Total
FROM dbo.Sessions
UNION
SELECT '[10-15>' AS bin, SUM(CASE WHEN duration/60 >= 10 AND duration/60 < 15 THEN 1 ELSE 0 END) AS Total
FROM dbo.Sessions
UNION
SELECT '15 or more' AS bin, SUM(CASE WHEN duration/60 >= 15 THEN 1 ELSE 0 END) AS Total
FROM dbo.Sessions

SELECT b.BIN, COUNT(a.bin)
FROM(
	SELECT
		CASE 
			WHEN duration/60 BETWEEN 0 AND 5 THEN '[0-5>'
			WHEN duration/60 BETWEEN 5 AND 10 THEN '[5-10>'
			WHEN duration/60 BETWEEN 10 AND 15 THEN '[10-15>'
			WHEN duration/60 >= 15 THEN '15 or more' 
			ELSE NULL END AS BIN
	FROM Sessions
) a
RIGHT JOIN(
	SELECT '[0-5>' BIN
	UNION
	SELECT '[5-10>' BIN
	UNION
	SELECT '[10-15>' BIN
	UNION
	SELECT '15 or more' BIN
) b ON b.BIN = a.BIN
GROUP BY b.BIN
