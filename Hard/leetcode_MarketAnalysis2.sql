-- Question 103
-- Table: Users

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | user_id        | int     |
-- | join_date      | date    |
-- | favorite_brand | varchar |
-- +----------------+---------+
-- user_id is the primary key of this table.
-- This table has the info of the users of an online shopping website where users can sell and buy items.
-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | order_date    | date    |
-- | item_id       | int     |
-- | buyer_id      | int     |
-- | seller_id     | int     |
-- +---------------+---------+
-- order_id is the primary key of this table.
-- item_id is a foreign key to the Items table.
-- buyer_id and seller_id are foreign keys to the Users table.
-- Table: Items

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | item_id       | int     |
-- | item_brand    | varchar |
-- +---------------+---------+
-- item_id is the primary key of this table.
 

-- Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

-- It is guaranteed that no seller sold more than one item on a day.

-- The query result format is in the following example:

-- Users table:
-- +---------+------------+----------------+
-- | user_id | join_date  | favorite_brand |
-- +---------+------------+----------------+
-- | 1       | 2019-01-01 | Lenovo         |
-- | 2       | 2019-02-09 | Samsung        |
-- | 3       | 2019-01-19 | LG             |
-- | 4       | 2019-05-21 | HP             |
-- +---------+------------+----------------+

-- Orders table:
-- +----------+------------+---------+----------+-----------+
-- | order_id | order_date | item_id | buyer_id | seller_id |
-- +----------+------------+---------+----------+-----------+
-- | 1        | 2019-08-01 | 4       | 1        | 2         |
-- | 2        | 2019-08-02 | 2       | 1        | 3         |
-- | 3        | 2019-08-03 | 3       | 2        | 3         |
-- | 4        | 2019-08-04 | 1       | 4        | 2         |
-- | 5        | 2019-08-04 | 1       | 3        | 4         |
-- | 6        | 2019-08-05 | 2       | 2        | 4         |
-- +----------+------------+---------+----------+-----------+

-- Items table:
-- +---------+------------+
-- | item_id | item_brand |
-- +---------+------------+
-- | 1       | Samsung    |
-- | 2       | Lenovo     |
-- | 3       | LG         |
-- | 4       | HP         |
-- +---------+------------+

-- Result table:
-- +-----------+--------------------+
-- | seller_id | 2nd_item_fav_brand |
-- +-----------+--------------------+
-- | 1         | no                 |
-- | 2         | yes                |
-- | 3         | yes                |
-- | 4         | no                 |
-- +-----------+--------------------+

-- The answer for the user with id 1 is no because they sold nothing.
-- The answer for the users with id 2 and 3 is yes because the brands of their second sold items are their favorite brands.
-- The answer for the user with id 4 is no because the brand of their second sold item is not their favorite brand.

-- Solution

WITH Users(user_id, join_date, favorite_brand)
AS
(
	SELECT 1, '2019-01-01', 'Lenovo' UNION ALL
	SELECT 2, '2019-02-09', 'Samsung' UNION ALL
	SELECT 3, '2019-01-19', 'LG' UNION ALL
	SELECT 4, '2019-05-21', 'HP'
),
Orders(order_id, order_date, item_id, buyer_id, seller_id)
AS
(
	SELECT 1, '2019-08-01', 4, 1, 2 UNION ALL
	SELECT 2, '2019-08-02', 2, 1, 3 UNION ALL
	SELECT 3, '2019-08-03', 3, 2, 3 UNION ALL
	SELECT 4, '2019-08-04', 1, 4, 2 UNION ALL
	SELECT 5, '2019-08-04', 1, 3, 4 UNION ALL
	SELECT 6, '2019-08-05', 2, 2, 4
),
Items(item_id, item_brand)
AS
(
	SELECT 1, 'Samsung' UNION ALL
	SELECT 2, 'Lenovo' UNION ALL
	SELECT 3, 'LG' UNION ALL
	SELECT 4, 'HP'
)

SELECT solution.user_id seller_id, solution.second_item_fav_brand 
FROM(
	SELECT *,
	CASE WHEN R.cnt < 2 THEN 'no' 
		ELSE 
			CASE WHEN R.rnk=2 AND R.favorite_brand = R.item_brand THEN 'yes'
					WHEN R.rnk =2 AND R.favorite_brand <> R.item_brand THEN 'no'
			END
	END second_item_fav_brand
	FROM(
		SELECT u.user_id, u.join_date, u.favorite_brand, o.order_date, i.item_brand,
		ROW_NUMBER() OVER(PARTITION BY u.user_id ORDER BY o.order_date) rnk,
		COUNT(u.user_id) OVER(PARTITION BY u.user_id) cnt
		FROM Users u
		LEFT JOIN Orders o ON o.seller_id = u.user_id 
		LEFT JOIN Items i ON i.item_id = o.item_id
	) R
) solution 
WHERE solution.second_item_fav_brand IS NOT NULL 
