SELECT p.КодСырья, p.НаимСырья
FROM Склад AS s
INNER JOIN Сырье p ON s.КодСырья = p.КодСырья


SELECT * FROM Склад AS s1
WHERE s1.ПризнакДвижения = 'Поступление'
ORDER BY s1.КодСырья

select t1.КодСырья, (t2.summ - t1.summ) from (
    SELECT КодСырья, SUM(Количество) as summ
    FROM Склад
    WHERE ПризнакДвижения = 'Выдача'
    GROUP BY КодСырья
    --ORDER BY s2.КодСырья
  ) as t1
inner join (
    SELECT КодСырья, SUM(Количество) as summ
    FROM Склад
    WHERE ПризнакДвижения = 'Поступление'
    GROUP BY КодСырья
    --ORDER BY s1.КодСырья
) as t2 on t1.КодСырья = t2.КодСырья