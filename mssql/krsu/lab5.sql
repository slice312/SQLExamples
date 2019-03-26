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




-----------------------------------------------
/****** Script for SelectTopNRows command from SSMS  ******/
use krsu_3
--SELECT ПризнакДвижения, КодСырья, sum(Количество) 'кол-во'
--FROM krsu_3.dbo.Склад
--group by  КодСырья, ПризнакДвижения 
--order by КодСырья, ПризнакДвижения


select t1.КодСырья, t2.КодСырья,
  t1.amount  'приход', t2.amount 'уход', (t1.amount - t2.amount) as diff
from (
    select ПризнакДвижения, КодСырья, sum(Количество) as amount
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Поступление'
    group by  КодСырья, ПризнакДвижения
    --order by КодСырья, ПризнакДвижения
  ) AS t1
inner join (
    select ПризнакДвижения, КодСырья, sum(Количество) as amount
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Выдача'
    group by  КодСырья, ПризнакДвижения
    --order by КодСырья, ПризнакДвижения
  ) AS t2
  on t1.КодСырья = t2.КодСырья
where t1.diff > 0
order by t1.КодСырья



select t1.КодСырья, ROUND(t1.amount, 2)  'приход',
    ROUND(t2.amount, 2) 'уход', ROUND(t1.amount - t2.amount, 5) as diff
from (
    select ПризнакДвижения, КодСырья, sum(Количество) as amount
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Поступление'
    group by  КодСырья, ПризнакДвижения
    --order by КодСырья, ПризнакДвижения
  ) AS t1
inner join (
       select ПризнакДвижения, КодСырья, sum(Количество) as amount
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Выдача'
    group by  КодСырья, ПризнакДвижения
    --order by КодСырья, ПризнакДвижения
  ) AS t2
  on t1.КодСырья = t2.КодСырья
-- where (t1.amount - t2.amount) > 0
order by t1.КодСырья



select st.КодСырья, st.ПризнакДвижения, sum(st.Количество)
from Склад as st
group by st.КодСырья, st.ПризнакДвижения
order by st.КодСырья, st.ПризнакДвижения


    select ПризнакДвижения, КодСырья, sum(Количество) as amount
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Поступление'
    group by  КодСырья, ПризнакДвижения

    select ПризнакДвижения, КодСырья, sum(Количество) as amount
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Поступление'
    group by  КодСырья, ПризнакДвижения






select t1.КодСырья, t1.ПризнакДвижения, t1.minn
from (
    select ПризнакДвижения, КодСырья, min(Датадвижения) as minn, count(*)
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Поступление'
    group by  КодСырья, ПризнакДвижения
    order by КодСырья

  ) AS t1
inner join (
   select ПризнакДвижения, КодСырья, min(Датадвижения) as minn, count(*)
    FROM krsu_3.dbo.Склад
    where ПризнакДвижения = 'Выдача'
    group by  КодСырья, ПризнакДвижения
    order by КодСырья

  ) AS t2
  on t1.КодСырья = t2.КодСырья
order by t1.КодСырья











-- ЧАСТЬ
select count(p.КодСырья)
from Сырье as p


select count(distinct p.КодСырья)
from Склад as p


select count(*)
from (
    select КодСырья
    from Сырье
    EXCEPT
    select КодСырья
    from Склад
  ) as t


  --есть на складе
select distinct p.КодСырья, p.НаимСырья
from Сырье as p
inner join Склад as s ON p.КодСырья = s.КодСырья
order by p.КодСырья



--нет на складе
select p.КодСырья, p.НаимСырья
from Сырье as p
left join Склад as s ON p.КодСырья = s.КодСырья
where s.КодСырья is null
order by p.КодСырья



-- средняя и макс цена по типу сырья и ед. измерения
SELECT p.НаимСырья, p.КодТипаСырья, p.КодЕдИзм, ROUND(AVG(s.Цена), 2) 'сред.', ROUND(MAX(s.Цена), 2) 'макс.'
FROM Склад AS s
  INNER JOIN Сырье AS p ON s.КодСырья = p.КодСырья
GROUP BY  p.КодТипаСырья, p.КодЕдИзм, p.НаимСырья WITH ROLLUP
ORDER BY  p.КодТипаСырья, p.КодЕдИзм, p.НаимСырья





-- Вывести данные обо всех кодах сырья с указанием  общего
-- объема сырья, поступившего на основной склад  за 2002 год
select s.КодСырья, sum(s.Количество) 'объем'
from Склад as s
where s.КодСкладаДвиж = 1 AND s.ПризнакДвижения = 'Поступление'
  and year(s.Датадвижения) = 2002
group by s.КодСырья with ROLLUP
order by s.КодСырья
