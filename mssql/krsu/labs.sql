-- LAB 2:

--The standard convention in SQL Server is:
--FK_ForeignKeyTable_PrimaryKeyTable

CREATE TABLE [Страны]
( 
  [Код страны] INT NOT NULL IDENTITY(1, 1),
  [Наименование страны] NVARCHAR(30) NOT NULL,
  CONSTRAINT [pk_Страны] PRIMARY KEY ([Код страны])
);



CREATE TABLE [Города]
( 
  [Код города] INT NOT NULL IDENTITY(1, 1),
  [Наименование города] NVARCHAR(30) NOT NULL,
  [Код страны] INT NOT NULL,
  CONSTRAINT [pk_Города] PRIMARY KEY ([Код города]),
  CONSTRAINT [fk_Города_Страны] FOREIGN KEY ([Код страны])
    REFERENCES [dbo].[Страны] ([Код страны])
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE [Сотрудники]
( 
  [Код сотрудника] INT NOT NULL IDENTITY(1, 1),
  [Фамилия] NVARCHAR(20),
  [Имя] NVARCHAR(20),
  [Отчество] NVARCHAR(20),
  [Дата рождения] DATE,
  [Зарплата] DECIMAL(19, 4),  
  [Код города] INT NOT NULL,
  CONSTRAINT [pk_Сотрудники] PRIMARY KEY ([Код сотрудника]),
  CONSTRAINT [CHK_Сотрудники_Зарплата] CHECK  ([Зарплата] >= 200),
  CONSTRAINT [fk_Сотрудники_Города] FOREIGN KEY ([Код города])
    REFERENCES [dbo].[Города] ([Код города])
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


--------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[Сотрудники]  
WITH CHECK ADD  CONSTRAINT [CHK_Сотрудники_Зарплата] CHECK  (([Зарплата]>=(200)))




-- DROP:
USE [krsuEdu_1]
GO
DROP TABLE [dbo].[Страны]
GO

-- сбросить Foreign Key
ALTER TABLE [dbo].[Города] 
DROP CONSTRAINT [fk_Города_Страны]




SELECT TOP (1000) [Код города], [Наименование города], [Код страны]
FROM [krsuEdu_1].[dbo].[Города]