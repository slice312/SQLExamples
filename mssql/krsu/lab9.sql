USE krsu_3
GO

/*-- 1
  Создать пакет, реализующий следующие действия:
  a) проверить существование таблицы Сырье_1,
  b) если такая таблица существует, удалить ее из базы данных,
  c) создать копию таблицы Сырье под именем Сырье_1,
  d) вывести данные таблицы Сырье_1, относящиеся к типам сырья Посуда и Прочие,
  e) изменить в таблице  «Сырье_1» тип сырья Посуда на тип сырья  Прочие,
  f) вывести данные таблицы Сырье_1, относящиеся к типам сырья Посуда и Прочие.
*/
IF (OBJECT_ID('dbo.Сырье_1') IS NOT NULL)
  BEGIN
    DROP TABLE dbo.Сырье_1
    PRINT 'deleted dbo.Сырье_1'
  END
ELSE
  BEGIN
    SELECT * INTO dbo.Сырье_1 FROM dbo.Сырье
    PRINT 'created dbo.СЫрье_1'

    SELECT p.НаимСырья, type.НаимТипаСырья
    FROM dbo.Сырье_1 AS p
      INNER JOIN dbo.Типы_сырья AS type ON p.КодТипаСырья = type.КодТипаСырья
    WHERE type.НаимТипаСырья = 'Посуда'
      OR type.НаимТипаСырья = 'Прочие'

    UPDATE dbo.Сырье_1
    SET КодТипаСырья = (SELECT КодТипаСырья FROM dbo.Типы_сырья WHERE НаимТипаСырья = 'Прочие')
    WHERE КодТипаСырья = (SELECT КодТипаСырья FROM dbo.Типы_сырья WHERE НаимТипаСырья = 'Посуда')


    SELECT p.НаимСырья, type.НаимТипаСырья
    FROM dbo.Сырье_1 AS p
      INNER JOIN dbo.Типы_сырья AS type ON p.КодТипаСырья = type.КодТипаСырья
    WHERE type.НаимТипаСырья = 'Посуда'
      OR type.НаимТипаСырья = 'Прочие'
  END
GO





/*-- 2
  Создать пакет, реализующий следующие действия:
  a) проверить существование таблицы Сырье_1,
  b) если такая таблица существует, удалить ее из базы данных,
  c) создать копию таблицы Сырье под именем Сырье_1,
  d) вывести данные о средней цене продуктов и средней цене напитков
  e) Если средняя цена продуктов больше средней цены напитков, то уменьшая на каждом шаге цикла цену
        всех продуктов на 20%, определить количество шагов, необходимых для достижения ситуации, когда
        средняя цена продуктов не превышает среднюю цену напитков.
     Если средняя цена напитков, больше средней цены продуктов, то уменьшая на каждом шаге цикла цену
        всех напитков на 20%, определить количество шагов, необходимых для достижения ситуации, когда средняя
        цена продуктов превышает среднюю цену напитков.
  f) вывести данные о средней цене продуктов, средней цене напитков и количестве шагов цикла.
*/
SET ANSI_WARNINGS OFF
GO


IF (OBJECT_ID('dbo.calcAVG') IS NOT NULL)
  DROP PROC dbo.calcAVG
GO


CREATE PROC dbo.calcAVG
  @typeCode int,
  @costAVG decimal(10, 2) OUTPUT
AS
BEGIN
  SELECT @costAVG = CAST(AVG(p.ЦенаСырья) AS decimal(10, 2))
  FROM dbo.Сырье_1 AS p
  WHERE p.КодТипаСырья = @typeCode
END
GO


DECLARE @productCode int = (SELECT КодТипаСырья FROM dbo.Типы_сырья WHERE НаимТипаСырья = 'Продукты')
DECLARE @drinkCode int = (SELECT КодТипаСырья FROM dbo.Типы_сырья WHERE НаимТипаСырья = 'Напитки')

DECLARE @productAVG decimal(10, 2)
DECLARE @drinkAVG decimal(10, 2)
EXEC dbo.calcAVG @productCode, @productAVG OUTPUT
EXEC dbo.calcAVG @drinkCode, @drinkAVG OUTPUT

PRINT CONCAT('product ', @productAVG)
PRINT CONCAT('drinks ', @drinkAVG)


DECLARE @leftCode int, @rightCode int
DECLARE @leftAVG decimal(10, 2), @rightAVG decimal(10, 2)

IF (@drinkAVG > @productAVG)
  BEGIN
    SELECT @leftCode = @drinkCode, @rightCode = @productCode
    SELECT @leftAVG = @drinkAVG, @rightAVG = @productAVG
  END
ELSE
  BEGIN
    SELECT @leftCode = @productCode, @rightCode = @drinkCode
    SELECT @leftAVG = @productAVG, @rightAVG = @drinkAVG
  END


DECLARE @count int = 0
WHILE (@leftAVG > @rightAVG)
  BEGIN
    UPDATE dbo.Сырье_1
    SET ЦенаСырья = ЦенаСырья - ЦенаСырья * 0.20
    WHERE КодТипаСырья = @leftCode

    EXEC dbo.calcAVG @leftCode, @leftAVG OUTPUT
    EXEC dbo.calcAVG @rightCode, @rightAVG OUTPUT

    SET @count = @count + 1
  END

PRINT CONCAT('count = ', @count)
GO


SELECT p.НаимСырья, type.НаимТипаСырья
FROM dbo.Сырье_1 AS p
  INNER JOIN dbo.Типы_сырья AS type ON p.КодТипаСырья = type.КодТипаСырья
WHERE type.НаимТипаСырья = 'Посуда'
  OR type.НаимТипаСырья = 'Прочие'
GO