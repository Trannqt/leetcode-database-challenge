-- Question 108
-- Given two tables as below, write a query to display the comparison result (higher/lower/same) of the 
-- average salary of employees in a department to the company's average salary.
 

-- Table: salary
-- | id | employee_id | amount | pay_date   |
-- |----|-------------|--------|------------|
-- | 1  | 1           | 9000   | 2017-03-31 |
-- | 2  | 2           | 6000   | 2017-03-31 |
-- | 3  | 3           | 10000  | 2017-03-31 |
-- | 4  | 1           | 7000   | 2017-02-28 |
-- | 5  | 2           | 6000   | 2017-02-28 |
-- | 6  | 3           | 8000   | 2017-02-28 |
 

-- The employee_id column refers to the employee_id in the following table employee.
 

-- | employee_id | department_id |
-- |-------------|---------------|
-- | 1           | 1             |
-- | 2           | 2             |
-- | 3           | 2             |
 

-- So for the sample data above, the result is:
 

-- | pay_month | department_id | comparison  |
-- |-----------|---------------|-------------|
-- | 2017-03   | 1             | higher      |
-- | 2017-03   | 2             | lower       |
-- | 2017-02   | 1             | same        |
-- | 2017-02   | 2             | same        |
 

-- Explanation
 

-- In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
 

-- The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
 

-- The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.
 

-- With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.

-- Solution

USE leetcode
GO

CREATE TABLE Salary_AverageSalary
(
	id INT,
	employee_id INT ,
	amount FLOAT	,
	pay_date    DATE
)
GO

CREATE TABLE Employee_AverageSalary
(
	employee_id INT,
	department_id INT
)
GO

INSERT INTO dbo.Salary_AverageSalary
        ( id, employee_id, amount, pay_date )
VALUES  ( 1, 1, 9000 , '2017-03-31' ),
		( 2, 2, 6000 , '2017-03-31' ),
		( 3, 3, 10000, '2017-03-31' ),
		( 4, 1, 7000 , '2017-02-28' ),
		( 5, 2, 6000 , '2017-02-28' ),
		( 6, 3, 8000 , '2017-02-28' )
GO

INSERT INTO dbo.Employee_AverageSalary
        ( employee_id, department_id )
VALUES  ( 1, 1 ),
		( 2, 2 ),
		( 3, 2 )
GO


SELECT  CAST(A.year AS VARCHAR(20)) + '-' + RIGHT('0'
                                                  + CAST(A.month AS VARCHAR(20)),
                                                  2) AS pay_month ,
        A.department_id ,
        CASE WHEN A.avg = B.avg THEN 'same'
             WHEN A.avg < B.avg THEN 'lower'
             WHEN A.avg > B.avg THEN 'higher'
        END
FROM    ( SELECT    A.department_id ,
                    YEAR(A.pay_date) year ,
                    MONTH(pay_date) month ,
                    AVG(A.amount) avg
          FROM      ( SELECT    E.department_id ,
                                E.employee_id ,
                                S.amount ,
                                S.pay_date
                      FROM      dbo.Employee_AverageSalary E
                                LEFT JOIN dbo.Salary_AverageSalary S ON S.employee_id = E.employee_id
                    ) A
          GROUP BY  A.department_id ,
                    YEAR(A.pay_date) ,
                    MONTH(A.pay_date)
        ) A
        LEFT JOIN ( SELECT  YEAR(pay_date) year ,
                            MONTH(pay_date) month ,
                            AVG(amount) avg
                    FROM    dbo.Salary_AverageSalary
                    GROUP BY YEAR(pay_date) ,
                            MONTH(pay_date)
                  ) B ON B.month = A.month
                         AND B.year = A.year
ORDER BY A.year DESC ,
        A.month DESC ,
        A.department_id ASC;

SELECT  CONVERT(VARCHAR(12), GETDATE(), 105);
SELECT  FORMAT(GETDATE(), 'yyyy-MM');


WITH query AS(
	SELECT	FORMAT(S.pay_date,'yyyy-MM') pay_date, 
			E.department_id, 
			AVG(S.amount) OVER( PARTITION BY FORMAT(S.pay_date,'yyyy-MM')) sumtotal,
			AVG(S.amount) OVER(PARTITION BY FORMAT(S.pay_date,'yyyy-MM'), E.department_id) subtotal 
	FROM dbo.Salary_AverageSalary S
	INNER JOIN dbo.Employee_AverageSalary E
	ON E.employee_id = S.employee_id
)

SELECT DISTINCT pay_date, query.department_id, 
				CASE WHEN query.sumtotal>query.subtotal THEN 'higher'
				     WHEN query.sumtotal<query.subtotal THEN 'lower'
				ELSE 'same' END 
FROM query
ORDER BY query.pay_date desc