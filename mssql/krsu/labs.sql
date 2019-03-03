--The standard convention in SQL Server is:
-- PRIMARY KEY:       PK_Tablename
-- FOREIGN KEY:       FK_ForeignKeyTable_PrimaryKeyTable
-- UNIQUE:            UQ_TableName>_ColumnName(s)
-- CHECK CONSTRAINT:  CHK_TableName_ColumnName
-- INDEX:             IX_TableName_Column(s)

-- LAB 2:

USE [krsu_1]

CREATE TABLE [Страны]
( 
  [Код страны] INT NOT NULL IDENTITY(1, 1),
  [Наименование страны] NVARCHAR(30) NOT NULL,
  CONSTRAINT [PK_Страны] PRIMARY KEY ([Код страны])
);



CREATE TABLE [Города]
( 
  [Код города] INT NOT NULL IDENTITY(1, 1),
  [Наименование города] NVARCHAR(30) NOT NULL,
  [Код страны] INT NOT NULL,
  CONSTRAINT [PK_Города] PRIMARY KEY ([Код города]),
  CONSTRAINT [FK_Города_Страны] FOREIGN KEY ([Код страны])
    REFERENCES [dbo].[Страны] ([Код страны])
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX [IX_Города_НаименованиеГорода_КодСтраны]
    UNIQUE ([Наименование города], [Код страны]),
);



CREATE TABLE [Сотрудники]
( 
  [Код сотрудника] INT NOT NULL IDENTITY(1, 1),
  [Фамилия] NVARCHAR(20),
  [Имя] NVARCHAR(20),
  [Отчество] NVARCHAR(20),
  [Дата рождения] DATE,
  [Отдел] INT,
  [Зарплата] DECIMAL(19, 4),  
  [Код города] INT NOT NULL,
  CONSTRAINT [PK_Сотрудники] PRIMARY KEY ([Код сотрудника]),
  CONSTRAINT [CHK_Сотрудники_Зарплата] CHECK ([Зарплата] >= 200),
  CONSTRAINT [FK_Сотрудники_Города] FOREIGN KEY ([Код города])
    REFERENCES [dbo].[Города] ([Код города])
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

ALTER TABLE [dbo].[Сотрудники]
  ADD [Семейное положение] BIT;



INSERT INTO [dbo].[Страны] ([Наименование страны])
VALUES ('Россия'), ('Кыргызстан'), ('Казахстан')

INSERT INTO [dbo].[Города] ([Наименование города], [Код страны])
VALUES ('Бишкек', 2), ('Ош', 2)

INSERT INTO [dbo].[Сотрудники] ([Фамилия], [Имя], [Отчество], [Дата рождения], [Зарплата], [Код города])
VALUES 
  ('Петров', 'Игорь', 'Михайлович', '25-03-1987', 265.0, 1),
  ('Петров', 'Юлий', 'Андреев', '07-05-1985', 255.0, 1),
  ('Сашков', 'Юрий', 'Юриевич', '13-12-1990', 645.0, 1),
  ('Иванов', 'Михаил', 'Александрович', '14-07-1992', 553.0, 2),
  ('Недов', 'Александр', 'Анич', '25-12-1993', 323.0, 2)


ALTER TABLE [dbo].[Сотрудники]
  DROP CONSTRAINT [CHK_Сотрудники_Зарплата]
ALTER TABLE [dbo].[Сотрудники]
  ADD CONSTRAINT [CHK_Сотрудники_Зарплата] CHECK ([Зарплата] >= 200 AND [Зарплата] <= 1200)


-- уникальность сочетания полей
CREATE UNIQUE INDEX [IX_Сотрудники_ФИО_ДатаРождения]
ON [dbo].[Сотрудники] ([Фамилия], [Имя], [Отчество], [Дата рождения])


ALTER TABLE [dbo].[Сотрудники]
  ADD CONSTRAINT [CHK_Сотрудники_ДатаРождения] CHECK (YEAR(GETDATE()) - YEAR([Дата рождения]) <= 60)
----------------------------------------------------------------------------------------------------------------


-- DROP с условием, если нет вывести дату:
IF OBJECT_ID('dbo.Страны') IS NOT NULL
  DROP TABLE [dbo].[Страны];
ELSE
  SELECT GETDATE()


-- ОЧИСТКА
-- перед очисткой надо сбросить foreign key, потом возвращаю
ALTER TABLE [dbo].[Города]
  DROP CONSTRAINT [FK_Города_Страны]
TRUNCATE TABLE [dbo].[Страны]

ALTER TABLE [dbo].[Города]
  ADD CONSTRAINT [FK_Города_Страны] FOREIGN KEY ([Код страны])
    REFERENCES [dbo].[Страны] ([Код страны])
    ON DELETE CASCADE
    ON UPDATE CASCADE


-- UNIQUE KEY
ALTER TABLE [dbo].[Сотрудники]
  ADD CONSTRAINT [UQ_Сотрудники_ФИО_ДатаРождения] UNIQUE ([Фамилия], [Имя], [Отчество], [Дата рождения])


-- DROP с условием, если нет вывести дату:
IF OBJECT_ID('dbo.Страны') IS NOT NULL
  DROP TABLE [dbo].[Страны];
ELSE
  SELECT GETDATE()


-- ВЫВОД
SELECT TOP (1000) [Код города], [Наименование города], [Код страны]
FROM [krsuEdu_1].[dbo].[Города]