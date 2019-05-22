USE Boreas;
GO

-- 1.1
-- Создать процедуру для вывода данных (Марка, Цена, НаСкладе) о товарах заданного типа.
-- Сортировать данные по марке товаров. Предусмотреть возможность задания типа товаров по умолчанию,
-- а также диагностики (с использованием оператора Return) ситуации, когда товаров заданного типа не существует.
CREATE PROC dbo.showByType
  @type nvarchar(100) = 'Напитки'
AS
BEGIN
  SELECT p.Марка, ROUND(p.Цена, 2) AS [Цена], p.НаСкладе
  FROM dbo.Товары AS p
    INNER JOIN dbo.Типы AS t ON p.КодТипа = t.КодТипа
  WHERE t.Категория = @type
  ORDER BY p.Марка;

  RETURN CAST(@@ROWCOUNT AS bit);
END;
GO



-- 1.2 
-- Создать процедуру, которая реализует следующие функции:
-- создает копию (Заказы_1) таблицы Заказы;
-- увеличивает в таблице Заказы_1 на заданное количество процентов стоимость доставки с заданным
--    именем для всех заказов, дата исполнения которых находится в заданном интервале времени;
-- выводит данные (КодЗаказа, СтоимостьДоставки (с двумя знаками после запятой), 
--    ДатаИсполнения (в немецком формате)) всех измененных записей таблицы Заказы_1;
-- определяет количество измененных записей в таблице Заказы_1 (как параметр типа output).
CREATE PROC dbo.copyOrders
  @percent real,
  @name nvarchar(20),
  @startdate date = '1992-03-07',
  @enddate date = '1995-03-07',
  @rowCount int OUTPUT
AS
BEGIN
  IF (OBJECT_ID('dbo.Заказы_1') IS NOT NULL)
    DROP TABLE dbo.Заказы_1;
  SELECT * INTO dbo.Заказы_1 FROM dbo.Заказы;

  UPDATE dbo.Заказы_1
  SET СтоимостьДоставки = СтоимостьДоставки + СтоимостьДоставки * @percent
  OUTPUT INSERTED.КодЗаказа, ROUND(INSERTED.СтоимостьДоставки, 2) AS [СтоимостьДоставки],
     CONVERT(varchar, INSERTED.ДатаИсполнения, 104) AS [ДатаИсполнения]
  WHERE КодЗаказа IN (
      SELECT o.КодЗаказа
      FROM dbo.Заказы_1 AS o
        INNER JOIN dbo.Доставка AS n ON o.Доставка = n.КодДоставки
      WHERE (o.ДатаИсполнения BETWEEN @startdate AND @enddate)
        AND n.Название = @name      
    );
  
  SET @rowcount = @@ROWCOUNT;
END;
GO



-- 1.3
-- Создать процедуру, которая реализует следующие функции:
-- выводит информацию (КодЗаказа, ДатаИсполнения, Марка, Стоимость товара с учетом скидки) о
-- заказах клиента с заданным кодом (строковый тип данных) за заданный интервал времени. 
-- В выводимой информации должны содержаться данные о стоимости каждого заказа (с учетом скидки);
-- определяет суммарную стоимость всех заказов заданного клиента за заданный интервал времени (как параметр типа output).
CREATE PROC dbo.totalSum
  @clienCode nvarchar(5),
  @startdate date,
  @enddate date,
  @sumCost decimal(19, 4) OUTPUT
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
    AND (o.ДатаРазмещения BETWEEN @startdate and @enddate);

  SELECT @sumCost = SUM(prod.Цена - prod.Цена * done.Скидка)
  FROM dbo.Заказы AS o
    INNER JOIN dbo.Заказано AS done ON o.КодЗаказа = done.КодЗаказа
    INNER JOIN dbo.Товары AS prod ON done.КодТовара = prod.КодТовара
    INNER JOIN dbo.Клиенты AS client ON o.Клиент_ID = client.Клиент_Id
  WHERE client.КодКлиента = @clienCode
    AND (o.ДатаРазмещения BETWEEN @startdate and @enddate);
END;
GO



-- 2.1
-- Создать пакет для вызова процедуры п.1.1, предусмотрев возможность выдачи
-- сообщения об отсутствии товаров заданного типа.
DECLARE @check bit;
EXEC @check = dbo.showByType 'Фрукты';

IF (@check = 0) PRINT 'Нет' 
ELSE PRINT 'Есть';
PRINT CONCAT('check = ', @check);

EXEC dbo.showByType;
GO



-- 2.2
-- Создать пакет для вызова процедуры п.1.2 и вывода информации о количестве измененных записей.
DECLARE @count int = 0;
EXEC dbo.copyOrders 0.7, 'Почта', DEFAULT, '1994-03-07', @count OUTPUT;
PRINT CONCAT('Записей измененно = ', @count);
GO



-- 2.3
-- Создать пакет для вызова процедуры п.1.3 и вывода информации о суммарной стоимости всех заказов
-- заданного клиента за заданный интервал времени.
DECLARE @cost decimal(19, 4) = 0.0;
EXEC dbo.totalSum 'BERGS', '1993-03-07', '1994-03-07', @cost OUTPUT;
PRINT CONCAT('Общая сумма = ', @cost);
GO
----------------------------------------------------------------------------------------------


ALTER PROC dbo.totalSum
  @clienCode nvarchar(5),
  @startdate date,
  @enddate date,
  @sumCost decimal(19, 4) OUTPUT
AS
BEGIN
  SELECT o.КодЗаказа,
    prod.Марка,
   SUM( prod.Цена - prod.Цена * done.Скидка )AS [со скидкой]
  FROM dbo.Заказы AS o
    INNER JOIN dbo.Заказано AS done ON o.КодЗаказа = done.КодЗаказа
    INNER JOIN dbo.Товары AS prod ON done.КодТовара = prod.КодТовара
    INNER JOIN dbo.Клиенты AS client ON o.Клиент_ID = client.Клиент_Id
  WHERE client.КодКлиента = @clienCode
    AND (o.ДатаРазмещения BETWEEN @startdate and @enddate)
  GROUP BY ROLLUP(o.КодЗаказа, prod.Марка);

  SELECT @sumCost = SUM(prod.Цена - prod.Цена * done.Скидка)
  FROM dbo.Заказы AS o
    INNER JOIN dbo.Заказано AS done ON o.КодЗаказа = done.КодЗаказа
    INNER JOIN dbo.Товары AS prod ON done.КодТовара = prod.КодТовара
    INNER JOIN dbo.Клиенты AS client ON o.Клиент_ID = client.Клиент_Id
  WHERE client.КодКлиента = @clienCode
    AND (o.ДатаРазмещения BETWEEN @startdate and @enddate);
END;
GO