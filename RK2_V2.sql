-- VAR2

-- TASK 1
-- Создать бд RK2. Создать в ней структуру, соотв. указанной на ER-диаг.:
-- 1* Водитель - Штраф (многие ко многим [Водитель.ИД - Штраф.ИД])
-- 2* Водитель - Автомобиль (один ко многим [Водитель.АвтоИД - Авто.ИД])
-- 
-- Автомобиль [ID(PK), Марка, Модель, Дата выпуска, Дата рег-ции в ГАИ]
-- Водитель [ID(PK), Номер водительского, Телефон, ФИО, Авто]
-- Штраф [ID(PK), Вид нарушения, Штраф, Предупреждение]s

CREATE DATABASE DB_2_2
GO

USE DB_2_2
GO

-- BASE TABLES
CREATE TABLE Cars
	(CarID int PRIMARY KEY IDENTITY(1, 1),
	Brand nvarchar(20) NOT NULL,
	Model nvarchar(20) NOT NULL,
	ReleaseDate date NOT NULL,
	RegistrationDate date NOT NULL)
GO

CREATE TABLE Drivers
	(DriverID int PRIMARY KEY IDENTITY(1, 1),
	License int NOT NULL,
	PhoneNumber int NOT NULL,
	FullName nvarchar(100) NOT NULL)
GO

CREATE TABLE Penalties
	(PenaltyID int PRIMARY KEY IDENTITY(1, 1),
	AbuseType  nvarchar(100) NOT NULL,
	Cost int NOT NULL,
	Warning nvarchar(3) NOT NULL)
GO

-- RELATION TABLES
CREATE TABLE DriversPenalties
	(DriverID int,
	 PenaltyID int)

CREATE TABLE DriversCars
	(CarID int,
	DriverID int)

-- ADDING CONSTRAINTS
ALTER TABLE DriversCars
ADD CONSTRAINT FK_DC_CarID FOREIGN KEY (CarID)
		REFERENCES Cars (CarID)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	CONSTRAINT FK_DC_DriverID FOREIGN KEY (DriverID)
		REFERENCES Drivers (DriverID)
			ON DELETE CASCADE
			ON UPDATE CASCADE;

ALTER TABLE DriversPenalties
ADD CONSTRAINT FK_DP_DriverID FOREIGN KEY (DriverID)
		REFERENCES Drivers (DriverID)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	CONSTRAINT FK_DP_PenaltyID FOREIGN KEY (PenaltyID)
		REFERENCES Penalties (PenaltyID)
			ON DELETE CASCADE
			ON UPDATE CASCADE;

ALTER TABLE Penalties
ADD CONSTRAINT penalties_warning_limit CHECK (Warning = 'Yes' OR Warning = 'No');
GO

-- INSERTING DATA
SET IDENTITY_INSERT Penalties ON
SET IDENTITY_INSERT Drivers ON
SET IDENTITY_INSERT Cars ON

INSERT Drivers (License, PhoneNumber, FullName)
	VALUES
	(88880001, 85553535, 'Karamazov Ivan Fedorovich'),
	(88880002, 85553536, 'Karamazov Dmitriy Fedorovich'),
	(88880003, 85553537, 'Karamazov Alexey Fedorovich'),
	(88880004, 85553538, 'Smerdyakov Pavel'),
	(88880005, 85553539, 'Zosima the Oldman'),
	(88880006, 85553540, 'Rakitin Mihail'),
	(88880007, 85553541, 'Hohlakova Ekaterina Osipovna'),
	(88880008, 85553542, 'Hohlakova Liza'),
	(88880009, 85553543, 'Grushenka'),
	(88880010, 85553544, 'Dostoevskiy Fedor Mihaylovich');

INSERT Cars (Brand, Model, ReleaseDate, RegistrationDate)
	VALUES
	('Kolesnica', 'Prototype-I', '1800-01-01', '1800-03-05'),
	('Kolesnica', 'Prototype-II', '1800-01-01', '1800-09-18'),
	('Kolesnica', 'Prototype-III', '1800-01-01', '1802-03-05'),
	('Kolesnica', 'Prototype-IV', '1800-01-01', '1803-01-01'),
	('Kolesnica', 'Prototype-V', '1800-01-01', '1804-03-05'),
	('Kolesnica', 'Prototype-VI', '1800-01-01', '1805-08-21'),
	('Troyka', 'Legkoupryajnie', '1500-03-05', '1802-06-12'),
	('Troyka', 'Tyajeloupryajnie', '1510-10-08', '1801-01-12'),
	('Kolesnica', 'Prototype-VII', '1800-01-01', '1806-03-05'),
	('Kolesnica', 'S telegoy', '1800-01-01', '1805-10-10');

INSERT Penalties(AbuseType, Cost, Warning)
	VALUES
	('High speed over 20 km/ch', 2, 'Yes'),
	('High speed over 25 km/ch', 4, 'Yes'),
	('High speed over 30 km/ch', 8, 'Yes'),
	('High speed over 35 km/ch', 16, 'No'),
	('High speed over 40 km/ch', 30, 'No'),
	('Parking in the wrong place', 1, 'Yes'),
	('Horse theft', 1000, 'No'),
	('Riding under the influence of alcohol', 10, 'Yes'),
	('Riding under the influence of drugs', 100, 'No'),
	('Riding under the influence of lunacy', 50, 'No');

INSERT DriversCars(CarID, DriverID)
	VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 1),
	(5, 1),
	(6, 1),
	(2, 7),
	(10, 8),
	(10, 9),
	(10, 10);

INSERT DriversPenalties(DriverID, PenaltyID)
	VALUES
	(2, 8),
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 5),
	(2, 6),
	(2, 7),
	(1, 1),
	(1, 5),
	(1, 10);

-- 1) SELECT с предикатом сравнения
SELECT *
FROM Penalties
WHERE Cost > 10

 -- 2) Инструкция, использующая оконную функцию
SELECT DISTINCT
	Warning,
	MIN(Cost) OVER(PARTITION BY Warning) AS MinCost,
	MAX(cost) OVER(PARTITION BY Warning) AS MaxCost
FROM Penalties

-- 3) Инструкция SELECT, использующая вложенные коррелированные подзапросы в
--	  качестве производных таблиц в предложениях FROM
SELECT DISTINCT
	T.DriverID,
	T.FullName
	,(SELECT COUNT(*) FROM DriversPenalties WHERE DriversPenalties.DriverID = T.DriverID) AS 'Penalties'
	,(SELECT SUM(Cost) FROM DriversPenalties JOIN Penalties ON DriversPenalties.PenaltyID = Penalties.PenaltyID
	  WHERE DriversPenalties.DriverID = T.DriverID) AS 'Sum'
FROM 
	(
	SELECT a.DriverID, a.FullName FROM Drivers a
	WHERE a.DriverID IN
		(
		SELECT DriverID
		FROM DriversPenalties
		)
	) AS T JOIN DriversPenalties ON T.DriverID = DriversPenalties.DriverID
GO

-- 4) Создать хр. проц. с выходным параметром, которая уничтожает все SQL DML триггеры (триггеры типа 'TR')
--    в текущей базе данных. Выходной параметр возвращает количество уничноженных триггеров. Затестить

DROP PROCEDURE destroyDMLTR

CREATE PROCEDURE destroyDMLTR(@result int OUTPUT)
AS
BEGIN
	SELECT @result = 0
	DECLARE @Counter int = 0, @trigger_id int
	DECLARE @trigger_name nvarchar(50)
	DECLARE DMLTriggerCursor CURSOR
	FOR
		SELECT object_id, name
		FROM sys.all_objects
		WHERE type = 'TR'
	OPEN DMLTriggerCursor;
	FETCH NEXT FROM DMLTriggerCursor INTO @trigger_id, @trigger_name
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC('DROP TRIGGER ' + @trigger_name)
		SELECT @result = @result + 1
		FETCH NEXT FROM  DMLTriggerCursor INTO @trigger_id, @trigger_name
	END
	CLOSE DMLTriggerCursor
	DEALLOCATE DMLTriggerCursor
END;

select * from sys.all_objects
where type = 'TR'

declare @res int;
set @res = 0;

exec destroyDMLTR @res OUTPUT
print @res




CREATE TRIGGER NewPenalty1
ON DriversPenalties
AFTER INSERT
AS PRINT('SMTH HAPPEND')
GO

CREATE TRIGGER NewPenalty2
ON DriversPenalties
AFTER INSERT
AS PRINT('SMTH HAPPEND')
GO

-- VAR 4

-- 2) update with set
DROP TABLE TEST
CREATE TABLE TEST (latestCreatedObjId int)
INSERT INTO TEST VALUES (0)

UPDATE TEST
SET latestCreatedObjId = (SELECT object_id
						FROM sys.all_objects
						WHERE modify_date = (SELECT MAX(modify_date)
											FROM sys.all_objects))\
SELECT * FROM TEST