
-- 1.1
-- Создать процедуру для вывода данных (Марка, Цена, НаСкладе) о товарах заданного типа.
-- Сортировать данные по марке товаров. Предусмотреть возможность задания типа товаров по умолчанию,
-- а также диагностики (с использованием оператора Return) ситуации, когда товаров заданного типа не существует.
ALTER PROC dbo.showByType
  @type nvarchar(100) = 'Напитки'
AS
BEGIN
  SELECT p.Марка, ROUND(p.Цена, 2), p.НаСкладе
  FROM dbo.Товары AS p
    INNER JOIN dbo.Типы AS t ON p.КодТипа = t.КодТипа
  WHERE t.Категория = @type
  ORDER BY p.Марка

  RETURN CAST(@@ROWCOUNT AS bit)
END
GO


DECLARE @check bit
EXEC @check = dbo.showByType 'Фрукты'

IF (@check = 0) PRINT 'Нет' 
ELSE PRINT 'Есть'
PRINT CONCAT('check = ', @check)

EXEC dbo.showByType
GO





-- 1.2 
-- Создать процедуру, которая реализует следующие функции:
-- создает копию (Заказы_1) таблицы Заказы;
-- увеличивает в таблице Заказы_1 на заданное количество процентов стоимость доставки с заданным
--    именем для всех заказов, дата исполнения которых находится в заданном интервале времени;
-- выводит данные (КодЗаказа, СтоимостьДоставки (с двумя знаками после запятой), 
--    ДатаИсполнения (в немецком формате)) всех измененных записей таблицы Заказы_1;
-- определяет количество измененных записей в таблице Заказы_1 (как параметр типа output).
ALTER PROC dbo.copyOrders
  @percent real,
  @name nvarchar(20),
  @startdate date,
  @enddate date,
  @rowCount int OUTPUT
AS
BEGIN
  IF (OBJECT_ID('dbo.Заказы_1') IS NOT NULL)
    DROP TABLE dbo.Заказы_1
  SELECT * INTO dbo.Заказы_1 FROM dbo.Заказы

  UPDATE dbo.Заказы_1
  SET СтоимостьДоставки = СтоимостьДоставки + СтоимостьДоставки * @percent
  WHERE КодЗаказа IN (
      SELECT o.КодЗаказа
	  FROM dbo.Заказы_1 AS o
	    INNER JOIN dbo.Доставка AS n ON o.Доставка = n.КодДоставки
	  WHERE (o.ДатаИсполнения BETWEEN @startdate AND @enddate)
	    AND n.Название = @name  	
    )
  
  SET @rowcount = @@ROWCOUNT


  SELECT o.КодЗаказа, ROUND(o.СтоимостьДоставки, 2) AS [СтоимостьДоставки],
    CONVERT(varchar, o.ДатаИсполнения, 104) AS [ДатаИсполнения]
  FROM dbo.Заказы_1 AS o
  WHERE КодЗаказа IN (
      SELECT o.КодЗаказа 
	  FROM dbo.Заказы_1 AS o
	    INNER JOIN dbo.Доставка AS n ON o.Доставка = n.КодДоставки
	  WHERE (o.ДатаИсполнения BETWEEN @startdate AND @enddate)
	    AND n.Название = @name  	
    )
END
GO


DECLARE @count int = 0
EXEC dbo.copyOrders 0.7, 'Почта', '1993-03-07', '1994-03-07', @count OUTPUT
PRINT CONCAT('Записей измененно = ', @count)




-- 1.3
-- Создать процедуру, которая реализует следующие функции:
-- выводит информацию (КодЗаказа, ДатаИсполнения, Марка, Стоимость товара с учетом скидки) о
-- заказах клиента с заданным кодом (строковый тип данных) за заданный интервал времени. 
-- В выводимой информации должны содержаться данные о стоимости каждого заказа (с учетом скидки);
-- определяет суммарную стоимость всех заказов заданного клиента за заданный интервал времени (как параметр типа output).
ALTER PROC dbo.totalSum
  @clienCode nvarchar(10),
  @startdate date,
  @enddate date,
  @sumCost decimal OUTPUT
AS
BEGIN
  SELECT o.КодЗаказа,
    CONVERT(varchar, o.ДатаИсполнения, 104) AS [ДатаИсполнения],
    prod.Марка,
	prod.Цена - prod.Цена * done.Скидка AS [со скидкой]
  FROM dbo.Заказы AS o
    INNER JOIN dbo.Заказано AS done ON o.КодЗаказа = done.КодЗаказа
    INNER JOIN dbo.Товары AS prod ON done.КодТовара = prod.КодТовара
    INNER JOIN dbo.Клиенты AS client ON o.Клиент_ID = client.Клиент_Id
  WHERE client.КодКлиента = @clienCode
    AND (o.ДатаРазмещения BETWEEN @startdate and @enddate)

  SELECT @sumCost = SUM(prod.Цена - prod.Цена * done.Скидка)
  FROM dbo.Заказы AS o
    INNER JOIN dbo.Заказано AS done ON o.КодЗаказа = done.КодЗаказа
    INNER JOIN dbo.Товары AS prod ON done.КодТовара = prod.КодТовара
    INNER JOIN dbo.Клиенты AS client ON o.Клиент_ID = client.Клиент_Id
  WHERE client.КодКлиента = @clienCode
    AND (o.ДатаРазмещения BETWEEN @startdate and @enddate)
END
GO




DECLARE @cost decimal(19, 4) = 0.0
EXEC dbo.totalSum 'BERGS', '1993-03-07', '1994-03-07', @cost OUTPUT
PRINT CONCAT('Общая сумма = ', @cost)




-- 2.1
-- Создать пакет для вызова процедуры п.1.1, предусмотрев возможность выдачи
-- сообщения об отсутствии товаров заданного типа.


-- 2.2
-- Создать пакет для вызова процедуры п.1.2 и вывода информации о количестве измененных записей.


-- 2.3
-- Создать пакет для вызова процедуры п.1.3 и вывода информации о суммарной стоимости всех заказов
-- заданного клиента за заданный интервал времени.


-----------------------------------------------------------------------------------

IF (@percent > 1.0)
  THROW 51000, 'wowowo ' , 16

DECLARE @count int = 0, @str nvarchar, @dat date
BEGIN TRY
  EXEC dbo.copy 2.5, '2000-03-07', '2003-03-07', @count OUTPUT
  PRINT CONCAT('ds = ', @count);
END TRY
BEGIN CATCH
    PRINT 'cathc'
END CATCH

