use Boreas6;

-- 1
select convert(varchar, cast(avg(p.Цена) as money), 1) as [Ср. цена],
  sum(p.НаСкладе * p.Цена) as [Запас]
from Товары as p
  inner join Типы as t ON p.КодТипа = t.КодТипа
group by t.Категория with rollup;



-- 2
select cl.Клиент_Id, cl.Название,
  convert(varchar, cast(sum(r.Количество * r.Цена) as money), 1) as [без скидки],
  convert(varchar, cast(sum(r.Количество * (r.Цена - r.Цена * r.Скидка)) as money), 1) as [со скидкой]
from Заказано as r
  inner join Заказы as rq on r.КодЗаказа = rq.КодЗаказа
  inner join Клиенты as cl on rq.Клиент_ID = cl.Клиент_Id
group by cl.Клиент_Id, cl.Название
having sum(r.Количество * (r.Цена - r.Цена * r.Скидка)) < (sum(r.Количество * r.Цена) * 90 / 100);



-- 3
select e1.Фамилия, e1.Имя, e2.Фамилия, e2.Имя
from Сотрудники as e1
  inner join Сотрудники as e2 on e1.Фамилия = e2.Фамилия 
    and e1.КодСотрудника < e2.КодСотрудника
  
  

 
 
-- View
-- 1
create view View1
as
select t.Категория, cl.Клиент_ID, cl.Название,
  sum(r.Количество) as [количество],
  convert(varchar, cast(sum(r.Количество * r.Цена) as money), 1) as [объем]
from Заказано as r
  inner join Товары as p on r.КодТовара = p.КодТовара
  inner join Типы as t on p.КодТипа = t.КодТипа
  inner join Заказы as rq on r.КодЗаказа = rq.КодЗаказа
  inner join Клиенты as cl on rq.Клиент_ID = cl.Клиент_Id
group by t.Категория, cl.Клиент_Id,  cl.Название;


-- 2
set language english;

create view View2
as
select top(100) percent datename(month, rq.[ДатаРазмещения]) as [месяц],
  e.КодСотрудника, e.Фамилия + ' ' + e.Имя as [Ф.И.],
  sum(rs.[Количество]) as [количество]
from Заказы as rq
  inner join Сотрудники as e on rq.КодСотрудника = e.КодСотрудника
  inner join Заказано as rs on rq.[КодЗаказа] = rs.[КодЗаказа]
where year(rq.[ДатаРазмещения]) = 1994 
group by datename(month, rq.[ДатаРазмещения]), datepart(month, rq.[ДатаРазмещения]),
  e.КодСотрудника, e.Фамилия + ' ' + e.Имя
order by datepart(month, rq.[ДатаРазмещения]);