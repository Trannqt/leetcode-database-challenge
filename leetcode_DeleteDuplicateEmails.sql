-- Question 32
-- Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

-- +----+------------------+
-- | Id | Email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- | 3  | john@example.com |
-- +----+------------------+
-- Id is the primary key column for this table.
-- For example, after running your query, the above Person table should have the following rows:

-- +----+------------------+
-- | Id | Email            |
-- +----+------------------+
-- | 1  | john@example.com |
-- | 2  | bob@example.com  |
-- +----+------------------+

-- Solution

USE leetcode
GO

CREATE TABLE Email_DeleteDuplicateEmails
(
	Id INT,
	Email VARCHAR(500)
)
GO

INSERT INTO dbo.Email_DeleteDuplicateEmails
        ( Id, Email )
VALUES  ( 1, -- Id - int
          'john@example.com'  -- Email - varchar(500)
          ),
		  ( 2, -- Id - int
          'bob@example.com'  -- Email - varchar(500)
          ),
		  ( 3, -- Id - int
          'john@example.com'  -- Email - varchar(500)
          )
GO

 Select Email,
    RANK() OVER(ORDER BY COUNT(Email) DESC) rk
    from Email_DeleteDuplicateEmails
	GROUP BY Email

Select *,
    row_number() over(partition by email order by id) as rk
    from Email_DeleteDuplicateEmails

With t1 as
(
 Select *,
    row_number() over(partition by email order by id) as rk
    from Email_DeleteDuplicateEmails
)

Delete from Email_DeleteDuplicateEmails
where id in (Select t1.id from t1 where t1.rk>1)
