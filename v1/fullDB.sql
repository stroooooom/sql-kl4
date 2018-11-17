USE master 
GO 

IF NOT EXISTS (
SELECT name
FROM sys.databases
WHERE name = 'RK2'
)
RETURN 
GO

USE RK2
GO

BULK INSERT Employee
FROM 'C:\Users\Rin\Desktop\DB_RK2\1_VAR\1_VAR\Employee.txt' 
WITH (DATAFILETYPE = 'char', FIRSTROW = 1, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a');
GO

--SELECT * FROM Employee

BULK INSERT Department
FROM 'C:\Users\Rin\Desktop\DB_RK2\1_VAR\1_VAR\Department.txt' 
WITH (DATAFILETYPE = 'char', FIRSTROW = 1, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a');
GO

--SELECT * FROM Department


BULK INSERT Medecine
FROM 'C:\Users\Rin\Desktop\DB_RK2\1_VAR\1_VAR\Medecine.txt' 
WITH (DATAFILETYPE = 'char', FIRSTROW = 1, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a');
GO

--SELECT * FROM Medecine

BULK INSERT EmployeeDepartment
FROM 'C:\Users\Rin\Desktop\DB_RK2\1_VAR\1_VAR\EmployeeDepartment.txt' 
WITH (DATAFILETYPE = 'char', FIRSTROW = 1, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a');
GO

--SELECT * FROM EmployeeDepartment

BULK INSERT MedecineEmployee
FROM 'C:\Users\Rin\Desktop\DB_RK2\1_VAR\1_VAR\MedecineEmployee.txt' 
WITH (DATAFILETYPE = 'char', FIRSTROW = 1, FIELDTERMINATOR = '|', ROWTERMINATOR = '0x0a');
GO

--SELECT * FROM MedecineEmployee