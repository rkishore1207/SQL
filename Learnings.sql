
-- Default Constraint
ALTER TABLE config.Employee
ADD CONSTRAINT DF_Employee_Gender
DEFAULT 'Unknown' FOR emp_gender

-- Find the Duplicate Records
SELECT * FROM data.Product
GROUP BY [Name]
HAVING COUNT(*) > 1

--Cascading Referential Integrity
-- When one table is referenced with another table, there if we delete one record from Parent table we have to set some of the constraint to the
-- respected child table

-- 1. SET DEFAULT, 2. SET NULL, 3. CASCADING, 4. NO ACTION
-- Open the child table go to the Relationship window, click the Insert and update section and select the required options for cascading.