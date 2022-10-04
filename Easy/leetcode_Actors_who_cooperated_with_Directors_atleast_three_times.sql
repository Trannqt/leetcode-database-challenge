-- Question 21
-- Table: ActorDirector

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | actor_id    | int     |
-- | director_id | int     |
-- | timestamp   | int     |
-- +-------------+---------+
-- timestamp is the primary key column for this table.
 

-- Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor have cooperated with the director at least 3 times.

-- Example:

-- ActorDirector table:
-- +-------------+-------------+-------------+
-- | actor_id    | director_id | timestamp   |
-- +-------------+-------------+-------------+
-- | 1           | 1           | 0           |
-- | 1           | 1           | 1           |
-- | 1           | 1           | 2           |
-- | 1           | 2           | 3           |
-- | 1           | 2           | 4           |
-- | 2           | 1           | 5           |
-- | 2           | 1           | 6           |
-- +-------------+-------------+-------------+

-- Result table:
-- +-------------+-------------+
-- | actor_id    | director_id |
-- +-------------+-------------+
-- | 1           | 1           |
-- +-------------+-------------+
-- The only pair is (1, 1) where they cooperated exactly 3 times.

CREATE DATABASE leetcode_Actors_who_cooperated_with_Directors_atleast_three_times
GO
USE leetcode_Actors_who_cooperated_with_Directors_atleast_three_times
GO

CREATE TABLE ActorDirector
(
	actor_id		INT,
	director_id		INT,
	timestamp		INT PRIMARY KEY
)
GO

INSERT INTO leetcode_Actors_who_cooperated_with_Directors_atleast_three_times.dbo.ActorDirector
        ( actor_id, director_id, timestamp )
VALUES  ( 1, -- actor_id - int
          1, -- director_id - int
          0  -- timestamp - int
          ),
		  ( 1, -- actor_id - int
          1, -- director_id - int
          1  -- timestamp - int
          ),
		  ( 1, -- actor_id - int
          1, -- director_id - int
          2  -- timestamp - int
          ),
		  ( 1, -- actor_id - int
          2, -- director_id - int
          3  -- timestamp - int
          ),
		  ( 1, -- actor_id - int
          2, -- director_id - int
          4  -- timestamp - int
          ),
		  ( 2, -- actor_id - int
          1, -- director_id - int
          5  -- timestamp - int
          ),
		  ( 1, -- actor_id - int
          1, -- director_id - int
          6  -- timestamp - int
          )
GO

--solution:

SELECT actor_id, director_id
FROM leetcode_Actors_who_cooperated_with_Directors_atleast_three_times.dbo.ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(actor_id)>=3