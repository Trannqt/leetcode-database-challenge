-- Question 111
-- Table: Activity

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key of this table.
-- This table shows the activity of players of some game.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

-- We define the install date of a player to be the first login day of that player.

-- We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

-- Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

-- The query result format is in the following example:

-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-01 | 0            |
-- | 3         | 4         | 2016-07-03 | 5            |
-- +-----------+-----------+------------+--------------+

-- Result table:
-- +------------+----------+----------------+
-- | install_dt | installs | Day1_retention |
-- +------------+----------+----------------+
-- | 2016-03-01 | 2        | 0.50           |
-- | 2017-06-25 | 1        | 0.00           |
-- +------------+----------+----------------+
-- Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the
-- day 1 retention of 2016-03-01 is 1 / 2 = 0.50
-- Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00

-- Solution
WITH Activity(player_id, device_id, event_date, games_played)
AS
(
	SELECT 1, 2, '2016-03-01', 5 UNION ALL
	SELECT 1, 2, '2016-03-02', 6 UNION ALL
	SELECT 2, 3, '2017-06-25', 1 UNION ALL
	SELECT 3, 1, '2016-03-01', 0 UNION ALL
	SELECT 3, 4, '2016-07-03', 5
),
solution AS
(
	SELECT *,
			ROW_NUMBER() OVER(PARTITION BY Activity.player_id ORDER BY Activity.event_date) rankdate,
			MIN(Activity.event_date) OVER(PARTITION BY Activity.player_id ORDER BY Activity.event_date) install_dt,
			LEAD(Activity.event_date) OVER(PARTITION BY Activity.player_id ORDER BY Activity.event_date) nodeNext
	FROM Activity
)

SELECT solution.install_dt,
		COUNT(solution.player_id) installs,
		ROUND(SUM(case when solution.nodeNext=DATEADD(DAY,1,event_date) then 1 else 0 END)*1.0/ISNULL(COUNT(solution.player_id),0),2) Day1_retention 
FROM solution
WHERE solution.rankdate = 1
GROUP BY solution.install_dt