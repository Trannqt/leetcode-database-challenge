-- Question 115
-- Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.

-- Return the result table in any order.

-- The query result format is in the following example.

 

-- TVProgram table:
-- +--------------------+--------------+-------------+
-- | program_date       | content_id   | channel     |
-- +--------------------+--------------+-------------+
-- | 2020-06-10 08:00   | 1            | LC-Channel  |
-- | 2020-05-11 12:00   | 2            | LC-Channel  |
-- | 2020-05-12 12:00   | 3            | LC-Channel  |
-- | 2020-05-13 14:00   | 4            | Disney Ch   |
-- | 2020-06-18 14:00   | 4            | Disney Ch   |
-- | 2020-07-15 16:00   | 5            | Disney Ch   |
-- +--------------------+--------------+-------------+

-- Content table:
-- +------------+----------------+---------------+---------------+
-- | content_id | title          | Kids_content  | content_type  |
-- +------------+----------------+---------------+---------------+
-- | 1          | Leetcode Movie | N             | Movies        |
-- | 2          | Alg. for Kids  | Y             | Series        |
-- | 3          | Database Sols  | N             | Series        |
-- | 4          | Aladdin        | Y             | Movies        |
-- | 5          | Cinderella     | Y             | Movies        |
-- +------------+----------------+---------------+---------------+

-- Result table:
-- +--------------+
-- | title        |
-- +--------------+
-- | Aladdin      |
-- +--------------+
-- "Leetcode Movie" is not a content for kids.
-- "Alg. for Kids" is not a movie.
-- "Database Sols" is not a movie
-- "Alladin" is a movie, content for kids and was streamed in June 2020.
-- "Cinderella" was not streamed in June 2020.

-- Solution

USE leetcode
GO

CREATE TABLE TVProgram_FriendlyMoviesStreamedList
(
	program_date DATETIME,
	content_id INT, 
	channel VARCHAR(100)
)
GO

CREATE TABLE Content_FriendlyMoviesStreamedList
(
	content_id INT,
	title          VARCHAR(100),
	Kids_content  VARCHAR(100),
	content_type  VARCHAR(100)
) 
GO


INSERT INTO dbo.TVProgram_FriendlyMoviesStreamedList
        ( program_date, content_id, channel )
VALUES  ( '2020-06-10 08:00', 1, 'LC-Channel' ),
		( '2020-05-11 12:00', 2, 'LC-Channel' ),
		( '2020-05-12 12:00', 3, 'LC-Channel' ),
		( '2020-05-13 14:00', 4, 'Disney Ch' ),
		( '2020-06-18 14:00', 4, 'Disney Ch' ),
		( '2020-07-15 16:00', 5, 'Disney Ch' )
GO

INSERT INTO dbo.Content_FriendlyMoviesStreamedList
        ( content_id ,
          title ,
          Kids_content ,
          content_type
        )
VALUES  ( 1 , 'Leetcode Movie' , 'N' , 'Movies' ),
		( 2 , 'Alg. for Kids ' , 'Y' , 'Series' ),
		( 3 , 'Database Sols ' , 'N' , 'Series' ),
		( 4 , 'Aladdin       ' , 'Y' , 'Movies' ),
		( 5 , 'Cinderella    ' , 'Y' , 'Movies' )
GO

SELECT DISTINCT C.title
FROM TVProgram_FriendlyMoviesStreamedList TV
LEFT JOIN Content_FriendlyMoviesStreamedList C ON C.content_id = TV.content_id
WHERE C.content_type = 'Movies' AND C.Kids_content = 'Y' AND MONTH(TV.program_date) = 6 AND YEAR(TV.program_date) = 2020 