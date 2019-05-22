USE krsu_3;
GO

-- 1.1
-- Cоздать функцию, определяющую для заданного месяца заданного года
-- максимальный объем поставки одним внешним поставщиком.
CREATE FUNCTION dbo.MaxDeliveryVolume(@month int, @year int)
RETURNS real
AS
BEGIN
  DECLARE @ret real;
  SET @ret = (SELECT MAX(st.Цена * st.Количество) AS vol
    FROM dbo.Склад AS st
    WHERE st.ПризнакДвижения = 'Поступление'
     AND DATEPART(month, st.Датадвижения) = @month
     AND DATEPART(year, st.Датадвижения) = @year);

  IF (@ret IS NULL)
    SET @ret = 0.0;
  RETURN @ret;
END;
GO

PRINT dbo.MaxDeliveryVolume(11, 2002);
GO



-- 1.2
-- Cоздать функцию, определяющую для заданного месяца заданного года наименование
-- самого эффективного внешнего поставщика (см. предыдущий пункт).
CREATE FUNCTION dbo.BestSupplier(@month int, @year int)
RETURNS nvarchar(25)
AS
BEGIN
  DECLARE @name nvarchar(25);

  SELECT @name = supplier.НаимПоставщика
  FROM dbo.Склад AS st
    INNER JOIN dbo.Поставщики AS supplier ON st.КодПоставщика = supplier.КодПоставщика
  GROUP BY supplier.НаимПоставщика
  HAVING CAST(MAX(st.Цена * st.Количество) AS decimal(19, 4)) = (
      SELECT CAST(MAX(Цена * Количество) AS decimal(19, 4))
      FROM dbo.Склад
      WHERE ПризнакДвижения = 'Поступление'
        AND DATEPART(month, Датадвижения) = @month
        AND DATEPART(year, Датадвижения) = @year
    );

  RETURN @name;
END;
GO

PRINT dbo.BestSupplier(11, 2002);
GO



-- 1.3
-- Cоздать функцию, определяющую для заданного месяца заданного года состав поставщиков,
-- обеспечивших поставку сырья заданного типа с объемом в денежном выражении не меньше заданного.
-- Выводимая информация должна содержать данные о коде поставщика, его наименовании и объеме поставки.
CREATE FUNCTION dbo.GetSuppliers(@typename nvarchar(25) = 'Напитки',
  @minvolume money = 2000.0, @month int, @year int)
RETURNS TABLE
AS
  RETURN (SELECT supl.КодПоставщика, supl.НаимПоставщика,
    SUM(CAST(st.Цена * st.Количество AS money)) AS [Объем]
  FROM dbo.Склад AS st
    INNER JOIN Сырье AS prod ON st.КодСырья = prod.КодСырья
    INNER JOIN Типы_сырья AS type ON prod.КодТипаСырья = type.КодТипаСырья
    INNER JOIN Поставщики AS supl ON st.КодПоставщика = supl.КодПоставщика
  WHERE st.ПризнакДвижения = 'Поступление'
    AND type.НаимТипаСырья = @typename
    AND DATEPART(month, st.Датадвижения) = @month
    AND DATEPART(year, st.Датадвижения) = @year
    AND CAST(st.Цена * st.Количество AS money) >= @minvolume
  GROUP BY supl.КодПоставщика, supl.НаимПоставщика);
GO

SELECT * FROM dbo.FOOOO(DEFAULT, DEFAULT, 11, 2002);
GO