USE krsu_3;


-- 1
-- Сформировать запрос на вывод данных о сырье и материалах, включающих тип (1-ый уровень сортировки),
-- наименование (2-ой уровень сортировки) и ед. измерения. Дополнить запрос условием запрета
-- вывода данных о сырье и материалах, измеряемых пачками.
CREATE VIEW View_1
  WITH SCHEMABINDING
AS
SELECT t.НаимТипаСырья AS [Тип],
  p.НаимСырья AS [Сырье1], e.НаимЕдИзм AS [Ед.]
FROM dbo.Сырье AS p
  INNER JOIN dbo.Типы_сырья AS t ON p.КодТипаСырья = t.КодТипаСырья
  INNER JOIN dbo.Ед_изм AS e ON p.КодЕдИзм = e.КодЕдИзм
WHERE e.НаимЕдИзм != 'Пачка';





SELECT s.КодДвижения, st.НаимСклада AS [Склад], s.ПризнакДвижения,
  p.НаимСырья AS [Сырье],
  FORMAT(s.Датадвижения, 'MM.dd.yyyy') AS [Дата],
  s.Количество * s.Цена [Объем],
  CASE s.ПризнакДвижения
    WHEN 'Поступление' THEN pr.НаимПоставщика
    WHEN 'Выдача' THEN b.НаимПокупателя
  END AS [producer]
FROM Склад AS s
  INNER JOIN Список_складов AS st ON s.КодСкладаДвиж = st.КодСклада
  INNER JOIN Сырье AS p ON s.КодСырья = p.КодСырья
  LEFT JOIN Покупатели AS b ON s.КодПокупателя = b.КодПокупателя
  LEFT JOIN Поставщики AS pr ON s.КодПоставщика = pr.КодПоставщика
WHERE YEAR(s.Датадвижения) = 2002
  AND DATEPART(month, s.Датадвижения) > 9
ORDER BY st.НаимСклада, [Объем];



select sum(объем_со_скидкой), sum(объем)
From clients
group by client
having sum(объем_со_скидкой) < (sum(объем) * 90 / 100)



select *
from person p1
  inner join person p2

SELECT convert(varchar,cast(541777367.100000 as money), 1) as 'Budget'