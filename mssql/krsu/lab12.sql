USE Boreas;
GO

--------------- DML триггеры ---------------
-- 1.0
-- Создать копию таблицы Клиенты с именем Клиенты_1.
SELECT * INTO dbo.Клиенты_1 FROM dbo.Клиенты;
GO



-- 1.1
-- Создать триггер на обработку вставки записи в таблицу Клиенты_1.
-- Условие успешной вставки – уникальность аббревиатуры клиента (поле КодКлиента).
CREATE TRIGGER TR_Клиенты_1__Insert
ON dbo.Клиенты_1
AFTER INSERT
AS
BEGIN
  DECLARE @code nvarchar(5);
  SET @code = (SELECT КодКлиента FROM inserted);
  IF ((SELECT COUNT(КодКлиента) FROM dbo.Клиенты_1 WHERE КодКлиента = @code) > 1)
  BEGIN
    RAISERROR('Такой ''КодКлиента'' уже существует', 1, 16);
    ROLLBACK TRANSACTION;
  END;
END;
GO



-- 1.2
-- Создать триггер на обработку удаления записей из таблицы Клиенты_1.
-- Условием запрета на удаление является принадлежность клиента стране Италия.
CREATE TRIGGER TR_Клиенты_1__Delete
ON dbo.Клиенты_1
AFTER DELETE
AS
IF EXISTS(SELECT 1 FROM deleted WHERE deleted.Страна = 'Италия')
BEGIN
  RAISERROR('Запрет на удаление, Страна = ''Италия''', 1, 16);
  ROLLBACK TRANSACTION;
END;
GO

DELETE FROM Клиенты_1 WHERE Клиент_Id = 1;
GO



-- 1.3
-- Создать триггер на обработку изменения записей в таблице Клиенты_1.
-- Запретить изменение любых данных, касающихся главных менеджеров.
CREATE TRIGGER TR_Клиенты_1__Update
ON dbo.Клиенты_1
INSTEAD OF UPDATE
AS
IF EXISTS(SELECT 1 FROM deleted WHERE deleted.Должность = 'Главный менеджер')
BEGIN
  RAISERROR('Запрет на изменение, Должность = ''Главный менеджер''', 1, 16);
  ROLLBACK TRANSACTION;
END;
GO


UPDATE dbo.Клиенты_1
SET ОбращатьсяК = 'Sun'
WHERE Должность = 'Главный менеджер';

UPDATE dbo.Клиенты_1
SET ОбращатьсяК = 'Sun'
WHERE Должность = 'Продавец';
GO



--------------- DDL триггеры ---------------
-- 3.1
-- Создать триггер  для запрета создания или изменения любой таблицы базы данных.
CREATE TRIGGER TR_BoreasDB_CreateAlter
ON DATABASE
AFTER CREATE_TABLE, ALTER_TABLE
AS
BEGIN
  RAISERROR('Запрет на создание и изменение', 1, 16);
  ROLLBACK TRANSACTION;
END;
GO

CREATE TABLE NewTable (id int);
GO



-- 3.2
-- Создать триггер для запрета удаления любого триггера базы данных.
CREATE TRIGGER TR_BoreasDB_DropTrigger
ON DATABASE
AFTER DROP_TRIGGER
AS
BEGIN
  RAISERROR('Запрет на удаление триггера', 1, 16);
  ROLLBACK TRANSACTION;
END;
GO

DROP TRIGGER TR_Клиенты_1__Insert;
GO

DISABLE TRIGGER TR_BoreasDB_DropTrigger ON DATABASE;
ENABLE TRIGGER TR_BoreasDB_DropTrigger ON DATABASE;