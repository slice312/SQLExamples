USE krsu_3;




-- 1
-- Сформировать запрос на выборку данных о превышающих 100 у.е. суммарных объемах (количество*цена)
-- закупок сырья типа «Прочие» по первым субботам каждого месяца. В заголовке поля, определяющего месяц,
-- вывести английское название месяца, дату первой субботы каждого месяца  вывести в немецком формате,
-- значение объема выводить округленным до 2 знаков после запятой.
set language english
set language russian

SELECT YEAR(s.Датадвижения) AS year, CONCAT(DATENAME(month, s.Датадвижения), ' 1st') AS month,
   FORMAT(s.Датадвижения, 'dd/MM/yyyy'), ROUND(SUM(s.Количество * s.Цена), 2) as summ
FROM Склад AS s
  INNER JOIN Сырье AS p ON s.КодСырья = p.КодСырья
WHERE s.ПризнакДвижения = 'Поступление'
  AND p.КодТипаСырья = 10
  AND DATEPART(weekday, s.Датадвижения) = 7  -- в англ. формате воскресенте 1 день недели
  AND DAY(s.Датадвижения) <= 7
GROUP BY YEAR(s.Датадвижения), DATEPART(month, s.Датадвижения), DATEPART(weekday, s.Датадвижения), s.Датадвижения
HAVING  SUM(s.Количество * s.Цена) > 100
ORDER BY year, s.Датадвижения;




select DATEPART(week, getdate());

SELECT DATEPArt(DAY, datediff(day, 0, '2019.04.08')/7 * 7)/7 + 1

select datepart(day, datediff(day, 0, GETDATE())/7 * 7)/7 + 1




















-------------------------------------------------------------
SELECT DATEPART(weekday, '2019.04.08'); //воскресенье считается 1 днем недели
SELECT DATENAME(weekday, '08.11.2019');
SELECT FORMAt(getdate(), 'dddd')
SELECT CONVERT(varchar(10), GETDATE(),101);


SELECT DATEPART(day, DATEDIFF(day, 0, GETDATE())/7 * 7)/7 + 1
