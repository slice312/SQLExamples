SET NOCOUNT ON;


/*
Enter your query below.
Please append a semicolon ";" at the end of the query
*/
/*
Enter your query below.
Please append a semicolon ";" at the end of the query
-- */
-- select c.algorithm, "q2"
-- from coins as c
-- inner join transactions as t, 
--     on c.code = t.coin_code
-- GROUP by c.algorithm

-- select c.algorithm, cast(t.dt as datetime), t.volume
-- from coins as c
-- inner join transactions as t
--     on c.code = t.coin_code
-- where datepart(year, t.dt) = 2020


-- select c.algorithm, SUM(t.volume), SUM(t.volume)
-- from coins as c
-- inner join transactions as t
--     on c.code = t.coin_code
-- where datepart(year, t.dt) >= 2020
-- group by c.algorithm;



select c.algorithm,
    SUM(case when datepart(quarter, t.dt) = 1 then t.volume else 0 end) as 'q1',
    SUM(case when datepart(quarter, t.dt) = 2 then t.volume else 0 end) as 'q2',
    SUM(case when datepart(quarter, t.dt) = 3 then t.volume else 0 end) as 'q3',
    SUM(case when datepart(quarter, t.dt) = 4 then t.volume else 0 end) as 'q4'
from coins as c
inner join transactions as t
    on c.code = t.coin_code
where datepart(year, t.dt) = 2020
group by c.algorithm
order by c.algorithm;





-- select datepart(quarter, t.dt) from transactions as t;
go















------------------------------------------------------------
SET NOCOUNT ON;


/*
Enter your query below.
Please append a semicolon ";" at the end of the query
SET NOCOUNT ON;


/*
Enter your query below.
Please append a semicolon ";" at the end of the query

WITH hours_worked as (
  
select emp_id,
    case when datepart(minute, timestamp) >= datepart(minute,lag(timestamp) over(partition by cast(timestamp as date),emp_id order by timestamp)) 
    then datepart(hour,timestamp) - datepart(hour,lag(timestamp) over(partition by cast(timestamp as date),emp_id order BY timestamp)) 
    else datepart(hour,timestamp) - datepart(hour,lag(timestamp) over(partition by cast(timestamp as date),emp_id order by timestamp)) - 1
    end as hours_worked
from attendance
where datepart(weekday, timestamp) IN(7,1)
)
select
   emp_id,
      sum(hours_worked) as hours_worked
from  hours_worked
group by emp_id
order by hours_worked desc

go