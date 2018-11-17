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

ALTER TABLE Employee 
ADD CONSTRAINT RK2_Employee_primarykey PRIMARY KEY (EmployeeID)
GO

ALTER TABLE Medecine 
ADD CONSTRAINT RK2_Medecine_primarykey PRIMARY KEY (MedecineID)
GO

ALTER TABLE Department 
ADD CONSTRAINT RK2_Department_primarykey PRIMARY KEY (DepartmentID)
GO

ALTER TABLE EmployeeDepartment ADD
CONSTRAINT RK2_EmployeeDepartment_EmployeeID_foreign_key FOREIGN KEY (EmployeeID)
REFERENCES Employee(EmployeeID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE EmployeeDepartment ADD
CONSTRAINT RK2_EmployeeDepartment_DepartmentID_foreign_key FOREIGN KEY (DepartmentID)
REFERENCES Department(DepartmentID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE MedecineEmployee ADD
CONSTRAINT RK2_MedecineEmployee_EmployeeID_foreign_key FOREIGN KEY (EmployeeID)
REFERENCES Employee(EmployeeID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE MedecineEmployee ADD
CONSTRAINT RK2_MedecineEmployee_MedecineID_foreign_key FOREIGN KEY (MedecineID)
REFERENCES Medecine(MedecineID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO