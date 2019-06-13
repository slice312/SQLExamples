USE BookLibrary;
GO

CREATE TABLE dbo.Авторы
(
  КодАвтора int IDENTITY(1, 1) NOT NULL,
  Фамилия nvarchar(50) NULL,
  Имя nvarchar(50) NULL,
  Отчество nvarchar(50) NULL,
  Псевдоним nvarchar(100) NULL,
  Email nvarchar(50) NULL,
  Телефон nvarchar(30) NULL,
  Сайт nvarchar(200) NULL,
  CONSTRAINT PK_Авторы PRIMARY KEY (КодАвтора)
);
GO

CREATE TABLE dbo.Издательства
(
  КодИздательства int IDENTITY(1, 1) NOT NULL,
  Название nvarchar(50) NOT NULL,
  Страна nvarchar(30) NULL,
  Телефон nvarchar(30) NULL,
  Сайт nvarchar(200) NULL,
  Email nvarchar(50) NULL,
  CONSTRAINT PK_Издательства PRIMARY KEY (КодИздательства)
);
GO

CREATE TABLE dbo.Книги
(
  КодКниги int IDENTITY(1, 1) NOT NULL,
  Название nvarchar(200) NOT NULL,
  КодИздательства int NULL,
  Год smallint NULL,
  ISBN nvarchar(20) NULL,
  ЧислоСтраниц smallint NULL,
  CONSTRAINT PK_Книги PRIMARY KEY (КодКниги),
  CONSTRAINT FK_Книги_Издательства FOREIGN KEY (КодИздательства)
    REFERENCES dbo.Издательства (КодИздательства)
    ON UPDATE SET NULL
    ON DELETE SET NULL
);
GO

CREATE TABLE dbo.Читатели
(
  КодЧитателя int IDENTITY(1, 1) NOT NULL,
  НомерПаспорта nvarchar(30) NOT NULL,
  ФИО nvarchar(200) NOT NULL,
  ДатаРождения date NULL,
  Адрес nvarchar(20) NOT NULL,
  Город nvarchar(20) NOT NULL,
  Email nvarchar(50) NULL,
  Телефон nvarchar(30) NULL,
  CONSTRAINT PK_Читатели PRIMARY KEY (КодЧитателя)
);
GO

CREATE TABLE dbo.Жанры
(
  КодЖанра int IDENTITY(1, 1) NOT NULL,
  Название nvarchar(50) NULL,
  CONSTRAINT PK_Жанры PRIMARY KEY (КодЖанра)
); 
GO

CREATE TABLE dbo.КнигиЖанры
(
  КодКниги int NOT NULL,
  КодЖанра int NOT NULL,
  CONSTRAINT PK_КнигиЖанры PRIMARY KEY (КодКниги, КодЖанра),
  CONSTRAINT FK_КнигиЖанры_Жанры FOREIGN KEY (КодЖанра)
    REFERENCES dbo.Жанры (КодЖанра),
  CONSTRAINT FK_КнигиЖанры_Книги FOREIGN KEY (КодКниги)
    REFERENCES dbo.Книги (КодКниги)
);
GO

CREATE TABLE dbo.КнигиАвторы
(
  КодКниги int NOT NULL,
  КодАвтора int NOT NULL,
  CONSTRAINT PK_КнигиАвторы PRIMARY KEY (КодКниги, КодАвтора),
  CONSTRAINT FK_КнигиАвторы_Авторы FOREIGN KEY (КодАвтора)
    REFERENCES dbo.Авторы (КодАвтора),
  CONSTRAINT FK_КнигиАвторы_Книги FOREIGN KEY (КодКниги)
    REFERENCES dbo.Книги (КодКниги) 
);
GO

CREATE TABLE dbo.Склад
(
  КодКниги int NOT NULL,
  ОбщееКоличество int NOT NULL,
  КолвоНаличие int NOT NULL,
  CONSTRAINT PK_Склад PRIMARY KEY (КодКниги),
  CONSTRAINT FK_Склад_Книги FOREIGN KEY (КодКниги)
    REFERENCES dbo.Книги (КодКниги)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT CHK_Склад__КолвоНаличие CHECK (КолвоНаличие <= ОбщееКоличество),
  CONSTRAINT CHK_Склад__Колво CHECK (ОбщееКоличество >= 0 OR КолвоНаличие >= 0)

);
GO

CREATE TABLE dbo.События
(
  КодСобытия int IDENTITY(1, 1) NOT NULL,
  КодЧитателя int NOT NULL,
  КодКниги int NOT NULL,
  Признак nvarchar(10) NOT NULL,
  Дата datetime NOT NULL DEFAULT(GETDATE()),
  CONSTRAINT PK_События PRIMARY KEY (КодСобытия),
  CONSTRAINT FK_События_Книги FOREIGN KEy (КодКниги)
    REFERENCES dbo.Книги (КодКниги)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT FK_События_Читатели FOREIGN KEY (КодЧитателя)
    REFERENCES dbo.Читатели (КодЧитателя),
  CONSTRAINT CHK_События_Признак CHECK (Признак = N'Взял' OR Признак = N'Вернул')
);
GO

CREATE TABLE dbo.ЧитателиДолг
(
  КодЧитателя int NOT NULL,
  КодКниги int NOT NULL,
  CONSTRAINT PK_ЧитателиДолг PRIMARY KEY (КодЧитателя, КодКниги),
  CONSTRAINT FK_ЧитателиДолг_Книги FOREIGN KEY (КодКниги)
    REFERENCES dbo.Книги (КодКниги)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT FK_ЧитателиДолг_Читатели FOREIGN KEY (КодЧитателя)
   REFERENCES dbo.Читатели (КодЧитателя)
);
GO