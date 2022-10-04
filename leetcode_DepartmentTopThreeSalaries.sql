-- Question 14
-- The Employee table holds all employees. Every employee has an Id, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 85000  | 1            |
-- | 2  | Henry | 80000  | 2            |
-- | 3  | Sam   | 60000  | 2            |
-- | 4  | Max   | 90000  | 1            |
-- | 5  | Janet | 69000  | 1            |
-- | 6  | Randy | 85000  | 1            |
-- | 7  | Will  | 70000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+
-- Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Randy    | 85000  |
-- | IT         | Joe      | 85000  |
-- | IT         | Will     | 70000  |
-- | Sales      | Henry    | 80000  |
-- | Sales      | Sam      | 60000  |
-- +------------+----------+--------+
-- Explanation:

-- In IT department, Max earns the highest salary, both Randy and Joe earn the second highest salary, 
-- and Will earns the third highest salary. 
-- There are only two employees in the Sales department, 
-- Henry earns the highest salary while Sam earns the second highest salary.

-- Solution

WITH Employee (Id, Name, Salary, DepartmentId)
AS
(
	SELECT 1, 'Joe  ', 85000, 1 UNION ALL
	SELECT 2, 'Henry', 80000, 2 UNION ALL
	SELECT 3, 'Sam  ', 60000, 2 UNION ALL
	SELECT 4, 'Max  ', 90000, 1 UNION ALL
	SELECT 5, 'Janet', 69000, 1 UNION ALL
	SELECT 6, 'Randy', 85000, 1 UNION ALL
	SELECT 7, 'Will ', 70000, 1 
),
Department(Id, Name)
AS
(
	SELECT 1, 'IT' UNION ALL
	SELECT 2, 'Sales'
)

SELECT R.Department, R.Employee, R.Salary
FROM(
	SELECT Department.Name Department, Employee.Name Employee, Employee.Salary,
			DENSE_RANK() OVER(PARTITION BY Employee.DepartmentId ORDER BY Employee.Salary desc) topsalary
	FROM Employee
	INNER JOIN Department ON Department.Id = Employee.DepartmentId
) R	
WHERE R.topsalary < 4
