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

--SIMPLE CASE
SELECT * FROM Medecine

INSERT Medecine([Name], Instruction, Cost)
VALUES('Progidron', NULL, 234) 

SELECT [Name],
CASE 
WHEN Instruction IS NULL
THEN 'MISSED'
ELSE CAST(Instruction AS text)
END Instruction
FROM Medecine

-- Window func AVG Salary in department & expensive medecine for buchgalter
SELECT Employee.EmployeeID, Employee.Post,
AVG(Employee.Salary) OVER(PARTITION BY Employee.Post) AS AVGPostSalary,
Medecine.MedecineID,
MAX(Medecine.Cost) OVER(PARTITION BY Medecine.Cost) AS MAXMedecineCost,
Medecine.[Name]
FROM (Employee JOIN MedecineEmployee ON Employee.EmployeeID = MedecineEmployee.EmployeeID) JOIN
	Medecine ON MedecineEmployee.MedecineID = Medecine.MedecineID

-- SELECT with GROUP BY AND HAVING
SELECT Employee.Department, Department.Employee
FROM (Department JOIN EmployeeDepartment ON Department.DepartmentID = EmployeeDepartment.DepartmentID)
	  JOIN Employee ON EmployeeDepartment.EmployeeID = Employee.EmployeeID
GROUP BY Employee.Department, Department.Employee
HAVING AVG(Employee.Salary) > (SELECT AVG(Employee.Salary) AS AVGSalary FROM Employee)

---  
-- 

/*procedure*/
CREATE PROCEDURE test(@db varchar(100), @tbl varchar(100)) AS
BEGIN

	/*use @db;*/

	SELECT * 
	FROM sys.indexes as i
	WHERE i.object_id = OBJECT_ID(@tbl);  

END;
go

/*test*/
exec test 'RK_2', 'Medecine';
go

/*cleanup*/
drop procedure test;
go

-- predicat cravnenia s kvantorom
SELECT EmployeeID
FROM Employee
WHERE Department = 'IT'
    AND EXISTS(SELECT *
      FROM Employee EMP1
      WHERE Employee.Department = EMP1.Department
        AND Employee.Salary > EMP1.Salary)

-- SELECT agr func v stolbc
SELECT AVG(TotalSalary) AS 'AVGSalary without NDS'
FROM (SELECT EmployeeID, SUM(Salary*0.8) AS TotalSalary
FROM Employee
GROUP BY EmployeeID) AS TotSalaries
-- create new non-permament local table from SELECT res grSELECT Employee.Department, Employee.SalaryINTO TestTableFROM Employee SELECT * FROM TestTable-- /*procedure*/
CREATE PROCEDURE test(@result INT OUTPUT) AS
BEGIN

	SELECT @result = count(*)
	FROM sys.all_objects
	WHERE type = 'FN' AND name like 'ufn%'
	
	SELECT name, object_id, OBJECT_DEFINITION(object_id) as text from sys.all_objects
	WHERE type = 'FN' AND name like 'ufn%'
	
END;
go

/*test_function*/
CREATE FUNCTION ufn_func() RETURNS INT AS BEGIN RETURN 0 END; go
CREATE FUNCTION ufn_func2() RETURNS INT AS BEGIN RETURN 0 END; go

/*test*/
declare @func_count INT;
exec test @func_count OUTPUT;
PRINT('We have ' + CAST(@func_count AS VARCHAR) + ' ufn_* funcions');
go

/*cleanup*/
drop function ufn_func2;
drop function ufn_func;
drop procedure test;
go