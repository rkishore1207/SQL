
-- Default Constraint
ALTER TABLE config.Employee
ADD CONSTRAINT DF_Employee_Gender
DEFAULT 'Unknown' FOR emp_gender

-- Find the Duplicate Records
SELECT * FROM data.Product
GROUP BY [Name]
HAVING COUNT(*) > 1