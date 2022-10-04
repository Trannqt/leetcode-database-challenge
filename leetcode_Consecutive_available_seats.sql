-- Question 37
-- Several friends at a cinema ticket office would like to reserve consecutive available seats.
-- Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?
-- | seat_id | free |
-- |---------|------|
-- | 1       | 1    |
-- | 2       | 0    |
-- | 3       | 1    |
-- | 4       | 1    |
-- | 5       | 1    |
 

-- Your query should return the following result for the sample case above.
 

-- | seat_id |
-- |---------|
-- | 3       |
-- | 4       |
-- | 5       |
-- Note:
-- The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.).
-- Consecutive available seats are more than 2(inclusive) seats consecutively available.

-- Solution

CREATE DATABASE leetcode_Consecutive_available_seats
GO
USE leetcode_Consecutive_available_seats
GO

create table Seats
(
	seat_id INT,
	free INT
)
GO

insert into Seats
values
(1,1),
(2,0),
(3,1),
(4,1),
(5,1),
(6,0),
(7,1),
(8,1),
(9,1),
(10,1)

GO

-- solution
SELECT seat_id
FROM(
	select	seat_id, 
			free, 
			LEAD(free) OVER (ORDER BY seat_id) lead_flag , 
			LAG(free) OVER (order by seat_id) lag_flag
	from Seats
) R 
WHERE R.free = 1 AND (R.lead_flag = 1 OR R.lag_flag = 1)

select DISTINCT a.seat_id FROM dbo.Seats a, dbo.Seats b
WHERE ABS(a.seat_id - b.seat_id) = 1 AND a.free = 1 AND b.free = 1
ORDER BY a.seat_id


SELECT DISTINCT a.seat_id
FROM dbo.Seats a
INNER JOIN dbo.Seats b
ON ABS(a.seat_id - b.seat_id) = 1 AND a.free = 1 AND b.free = 1
ORDER BY a.seat_id