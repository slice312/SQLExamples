USE BookLibrary;
GO

-- TRIGGERS
-------------------------------------------------------------------------------------
CREATE TRIGGER TR_События
ON dbo.События
AFTER INSERT, UPDATE
AS
BEGIN
  DECLARE @bookCode int,
          @customerCode int,
          @type nvarchar(10);
  SELECT @bookCode = КодКниги, @type = Признак, @customerCode = КодЧитателя FROM inserted;
  if (@type = N'Взял')
  BEGIN
    UPDATE dbo.Склад 
    SET КолвоНаличие = КолвоНаличие - 1
    WHERE КодКниги = @bookCode;

    INSERT INTO dbo.ЧитателиДолг (КодЧитателя, КодКниги)
    VALUES (@customerCode, @bookCode);
  END
  ELSE
  BEGIN
    UPDATE dbo.Склад 
    SET КолвоНаличие = КолвоНаличие + 1
    WHERE КодКниги = @bookCode;

    DELETE FROM dbo.ЧитателиДолг
    WHERE КодКниги = @bookCode AND КодЧитателя = @customerCode;
  END
  
END
GO

-- PRODCEDURE
-------------------------------------------------------------------------------------
CREATE PROC dbo.GetBook
  @bookName nvarchar(50), @customerName nvarchar(50)
AS
BEGIN
  DECLARE @bookCode int,
          @customerCode int;
  SET @bookCode = (SELECT КодКниги FROM dbo.Книги WHERE Название = @bookName);
  SET @customerCode = (SELECT КодЧитателя FROM dbo.Читатели WHERE ФИО = @customerName);

  INSERT INTO dbo.События (КодКниги, КодЧитателя, Признак)
  VALUES (@bookCode, @customerCode, N'Взял');
END
GO


CREATE PROC dbo.ReturnBook
  @bookName nvarchar(50), @customerName nvarchar(50)
AS
BEGIN
  DECLARE @bookCode int,
          @customerCode int;
  SET @bookCode = (SELECT КодКниги FROM dbo.Книги WHERE Название = @bookName);
  SET @customerCode = (SELECT КодЧитателя FROM dbo.Читатели WHERE ФИО = @customerName);

  INSERT INTO dbo.События (КодКниги, КодЧитателя, Признак)
  VALUES (@bookCode, @customerCode, N'Вернул');
END
GO


CREATE PROC dbo.BooksByAuthor
  @fname nvarchar(50), @lname nvarchar(50)
AS
BEGIN
  SELECT books.Название, books.КодИздательства, books.Год
  FROM dbo.Авторы AS author
    INNER JOIN dbo.КнигиАвторы AS ba ON author.КодАвтора = ba.КодАвтора
    INNER JOIN dbo.Книги AS books ON books.КодКниги = ba.КодКниги
  WHERE author.Имя = @fname AND author.Фамилия = @lname;
END
GO


CREATE PROC dbo.ClearOldHistory
AS
BEGIN
  DELETE FROM dbo.События
  WHERE YEAR(GETDATE() - Дата) > 2;
END
GO


CREATE PROC dbo.ShowPromisers
AS
BEGIN
  SELECT customer.ФИО AS [читатель], books.Название AS [книга]
  FROM dbo.ЧитателиДолг AS promiser
    INNER JOIN dbo.Читатели AS customer ON promiser.КодЧитателя = customer.КодЧитателя
    INNER JOIN dbo.Книги AS books ON promiser.КодКниги = books.КодКниги;
END
GO