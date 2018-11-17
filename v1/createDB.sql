USE master
GO

IF NOT EXISTS(
SELECT name
FROM sys.databases
WHERE name = 'RK2'
)
CREATE DATABASE RK2
GO

USE RK2
GO

IF (OBJECT_ID('Employee', 'U') IS NULL)
CREATE TABLE Employee
(
	EmployeeID int IDENTITY(1, 1),
	Department nvarchar(20) NOT NULL,
	Post nvarchar(20) NOT NULL,
	Initials nvarchar(40) NOT NULL,
	Salary int NOT NULL
)
GO

IF (OBJECT_ID('Medecine', 'U') IS NULL)
CREATE TABLE Medecine
(
	MedecineID int IDENTITY(1, 1),
	[Name] nvarchar(20) NOT NULL,
	Instruction text,
	Cost int NOT NULL 
)
GO

IF (OBJECT_ID('MedecineEmployee', 'U') IS NULL)
CREATE TABLE MedecineEmployee
(
	MedecineID int,
	EmployeeID int
)
GO

IF (OBJECT_ID('Department', 'U') IS NULL)
CREATE TABLE Department
(
	DepartmentID int IDENTITY(1, 1),
	[Name] nvarchar(20) NOT NULL,
	PhoneNumber text NOT NULL,
	Employee nvarchar(40) NOT NULL
)
GO

IF (OBJECT_ID('EmployeeDepartment', 'U') IS NULL)
CREATE TABLE EmployeeDepartment
(
	EmployeeID int,
	DepartmentID int
)