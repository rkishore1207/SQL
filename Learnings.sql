
-- Default Constraint

ALTER TABLE config.Employee
ADD CONSTRAINT DF_Employee_Gender
DEFAULT 'Unknown' FOR emp_gender