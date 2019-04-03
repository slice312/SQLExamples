USE krsu_3;




-- 1
-- Сформировать запрос на выборку данных о превышающих 100 у.е. суммарных объемах (количество*цена)
-- закупок сырья типа «Прочие» по первым субботам каждого месяца. В заголовке поля, определяющего месяц,
-- вывести английское название месяца, дату первой субботы каждого месяца  вывести в немецком формате,
-- значение объема выводить округленным до 2 знаков после запятой.
SELECT  YEAR(s.Датадвижения) AS year, MONTH(s.Датадвижения) AS month, -- (s.Количество * s.Цена) AS 'объем', FORMAT(s.Датадвижения, 'dd/MM/yyyy')
   s.Датадвижения, DATEPART(weekday, s.Датадвижения) AS weeks,  (s.Количество * s.Цена)  AS 'объем'
FROM Склад AS s
  INNER JOIN Сырье AS p ON s.КодСырья = p.КодСырья
WHERE s.ПризнакДвижения = 'Поступление'
  AND p.КодТипаСырья = 10
  AND (s.Количество * s.Цена) > 100
  AND DATEPART(weekday, s.Датадвижения) = 7
  AND (DATEPART(DAY, DATEDIFF(day, 0, s.Датадвижения) / 7 * 7) / 7 + 1) = 1
GROUP BY YEAR(s.Датадвижения), MONTH(s.Датадвижения), DATEPART(weekday, s.Датадвижения),
         (s.Количество * s.Цена)
ORDER BY year, month;





select DATEPART(week, getdate());

SELECT DATEPArt(DAY, datediff(day, 0, '2019.04.08')/7 * 7)/7 + 1

select datepart(day, datediff(day, 0, GETDATE())/7 * 7)/7 + 1




















-------------------------------------------------------------
SELECT DATEPART(weekday, '2019.04.08'); //воскресенье считается 1 днем недели
SELECT DATENAME(weekday, '08.11.2019');
SELECT FORMAt(getdate(), 'dddd')
SELECT CONVERT(varchar(10), GETDATE(),101);


SELECT DATEPART(day, DATEDIFF(day, 0, GETDATE())/7 * 7)/7 + 1
