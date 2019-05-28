-------------------------------FUNCTION------------------------------------
source script.sql  --загрузить из скрипта
show warnings
show databases
show tables
show columns from employee  --описание таблицы
desc bank.employee          --описание таблицы



EXPLAIN --?????

CAST(obj AS INT)  -- приведение типов;


COALESCE(args...) -- возвращает первый не null аргумент;
IFNULL(obj, alternative) -- если obj null, возвращает 2-ой параметр alternative;



--------------------------------NUMBER FUNCTIONS-----------------------------------------
MOD(float N, float M) -- остаток от деления N на M;
POW(float N, float M) -- возведение в степень;

CEIL(), FLOOR() -- округление 1)вверх, 2)вниз;

ROUND(float N, int digits) -- округление с указанием числа разрядов справа от точки,
    -- до которого проводится округление (2 арг. не обязательный);
TRUNCATE(float N, int digits) -- просто отсекает, оставляя только указанное число 
    -- разрядов после точки;
-- В ROUND() и TRUNCATE() можно передать 2-ой аргумент с минусом,
-- означает округление/усечение слева от точки.

SIGN(float N) -- -> 1 если N > 0, -1 если N < 0, 0 если N = 0;
ABS(float N)  -- -> абсолютное значение;



--------------------------------STRING FUNCTIONS-----------------------------------------
LOWER(string)   -- -> low-case строка;
UPPER(string)   -- -> up-case строка;
LENGTH(string)  -- -> длина строки (или кол-во цифр);
QUOTE(string)   -- -> строка в кавычках;
ASCII(char ch)  -- -> код символа;
CHAR(int... codes)  -- -> строка по кодам символов;
CONCAT(string... strs)  -- конкатенация строк;
POSITION(string IN str_field) -- -> позиция подстроки в строке (нумерация с 1);
LOCATE(string, str_field, int pos) -- как POSITION(), но можно задать нач. позицию;
STRCMP(string, string) -- как в Си работает, но без учета регистра;
INSERT(string, int pos, int count, string) -- заменяет в строке с позиции pos, count
    -- символов, новой строкой. Если count = 0, то старая строка расширяется;
SUBSTR(string, int pos, int count) -- -> подстроку из строки; 


LEFT() -- с числами тоже
RIGHT()


---------------------------------DATE FUNCTIONS------------------------------------------
utc_timestamp()
SELECT @@global.time_zone, @@session.time_zone;
SET time_zone = 'Europe/Zurich';
select * from mysql.time_zone_name;

CAST('2012-05-26' AS DATETIME)  -- приведение типов;
STR_TO_DATE()

NOW(), CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP()

DATE_ADD()



YEAR()
MONTH()
MONTHNAME()

EXTRACT(YEAR FROM start_date)


-------------------------------AGGREGATING FUNCTIONS-------------------------------------
COUNT(), SUM(), MIN(), MAX(), AVG()



---------------------------------------------------------------------------



----------------------------------- SAMPLES-------------------------------
-- Показать FK ограничения таблицы:
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME,
  REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'bank'
  AND (REFERENCED_TABLE_NAME = 'employee' OR TABLE_NAME = 'employee');


-- Показать комментарий к таблице:
SELECT TABLE_COMMENT
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bank' AND TABLE_NAME = 'individual';


--Размеры баз
SELECT table_schema "DB Name",
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables 
GROUP BY table_schema; 



---------------------------------------------------------------------------

SHOW PROCEDURE STATUS;
SHOW FUNCTION STATUS;
---------------------------------------------------------------------------

-- Создание юзера
CREATE USER 'slice'@'localhost' IDENTIFIED BY 'qwe';
GRANT ALL PRIVILEGES ON * . * TO 'slice'@'localhost';
FLUSH PRIVILEGES;

-- Показать юзеров и их привелегии
SELECT user FROM mysql.user;
SHOW GRANTS FOR slice@localhost;

-- Подключение JDBC на винде:
String url = "jdbc:mysql://localhost:3306/bank?autoReconnect=true&useSSL=false";
---------------------------------------------------------------------------







-- Упражнения из "Алан Бьюли - Изучаем SQL (2007)":

/*----------------------3 ГЛАВА--------------------*/

-- 3.1
SELECT emp_id, fname, lname FROM employee ORDER BY lname, fname;

-- 3.2
SELECT account_id, cust_id, avail_balance FROM account
WHERE status = 'ACTIVE' AND avail_balance > 2500;

-- 3.3
SELECT DISTINCT open_emp_id FROM account;

-- 3.4
SELECT p.product_cd, a.cust_id, a.avail_balance
FROM product p 
INNER JOIN account a ON p.product_cd = a.product_cd
WHERE p.product_type_cd = 'ACCOUNT';



/*----------------------4 ГЛАВА--------------------*/

-- 4.3
SELECT * FROM account WHERE YEAR(open_date) = 2002;
SELECT * FROM account WHERE open_date BETWEEN '2002-01-01' AND '2002-12-31';

-- 4.4
SELECT * FROM individual WHERE lname LIKE '_a%e%';
SELECT * FROM individual WHERE lname REGEXP '^.a.*e';



/*----------------------5 ГЛАВА--------------------*/

-- 5.1
SELECT e.emp_id, e.fname, e.lname, b.name
FROM employee e 
  INNER JOIN branch b ON e.assigned_branch_id = b.branch_id;

-- 5.2
SELECT a.account_id, c.fed_id, p.name product_name
FROM account a
  INNER JOIN customer c ON a.cust_id = c.cust_id
  INNER JOIN product p ON a.product_cd = p.product_cd
WHERE c.cust_type_cd = 'I';

-- 5.3
SELECT e1.emp_id, e1.fname, e1.lname
FROM employee e1
  INNER JOIN employee e2 ON e1.superior_emp_id = e2.emp_id
WHERE e1.dept_id != e2.dept_id;



/*----------------------6 ГЛАВА--------------------*/

-- 6.1
/*
 A = {L M N O P}
 B = {P Q R S T}

 A union B = {L M N O P Q R S T}
 A union all B = {L M N O P P Q R S T}
 A intersect B = {P}
 A expect B = {L M N O}
*/

-- 6.2
SELECT fname, lname FROM individual
UNION
SELECT fname, lname FROM employee;

-- 6.3
SELECT fname, lname FROM individual
UNION ALL
SELECT fname, lname FROM employee
ORDER BY lname;



/*----------------------7 ГЛАВА--------------------*/

-- 7.1
SELECT SUBSTR('Please find the substring in this string', 17, 9);
SELECT POSITION('substring' IN 'Please find the substring in this string');

-- 7.2
SELECT ABS(-25.76823), SIGN(-25.76823), ROUND(-25.76823, 2);

-- 7.3
SELECT MONTH(NOW()), MONTHNAME(NOW());
SELECT EXTRACT(MONTH FROM CURRENT_DATE());





/*----------------------8 ГЛАВА--------------------*/

-- 8.1
-- Создайте запрос для подсчета числа строк в таблице account.
SELECT COUNT(*) `rows` FROM account;

-- 8.2
-- Измените свой запрос из упражнения 8.1 для подсчета числа счетов,
-- имеющихся у каждого клиента. Для каждого клиента выведите ID клиента и количество счетов.
SELECT cust_id, COUNT(*) accounts
FROM account
GROUP BY cust_id;

-- 8.2* (Мой вариант, дополнительно выводит имена владельцев)
SELECT a.cust_id id, i.fname fname, i.lname lname, COUNT(*) accounts
FROM account AS a
  INNER JOIN individual AS i ON a.cust_id = i.cust_id
GROUP BY a.cust_id
UNION
SELECT a.cust_id, o.fname fname, o.lname lname, COUNT(*) accounts
FROM account AS a
  INNER JOIN officer AS o ON a.cust_id = o.cust_id
GROUP BY a.cust_id, o.fname, o.lname
ORDER BY id;


-- 8.3
-- Измените запрос из упражнения 8.2 так, чтобы в результирующий набор
-- были включены только клиенты, имеющие не менее двух счетов.
SELECT cust_id, COUNT(*) accounts
FROM account
GROUP BY cust_id
HAVING accounts >= 2;

-- 8.3*
SELECT t.cust_id, t.fname, t.lname, t.accounts
FROM (
  SELECT a.cust_id, i.fname fname, i.lname lname, COUNT(*) accounts
  FROM account AS a
    INNER JOIN individual AS i ON a.cust_id = i.cust_id
  GROUP BY a.cust_id
  UNION
  SELECT a.cust_id, o.fname fname, o.lname lname, COUNT(*) accounts
  FROM account AS a
    INNER JOIN officer AS o ON a.cust_id = o.cust_id
  GROUP BY a.cust_id, o.fname, o.lname
) AS t
WHERE t.accounts >= 2
ORDER BY t.accounts;


-- 8.4
-- Найдите общий доступный остаток по типу счетов и отделению, где
-- на каждый тип и отделение приходится более одного счета.
-- Результаты должны быть упорядочены по общему остатку
-- (от наибольшего к наименьшему).
SELECT a.product_cd, b.name branch, SUM(a.avail_balance) balance
FROM account AS a
  INNER JOIN branch AS b ON a.open_branch_id = b.branch_id
GROUP BY a.product_cd, a.open_branch_id
HAVING COUNT(*) > 1
ORDER BY balance DESC;





/*----------------------9 ГЛАВА--------------------*/

-- 9.1
-- Создайте запрос к таблице account, использующий условие фильтрации
-- с несвязанным подзапросом к таблице product для поиска всех кредитных
-- счетов (product.product_type_cd = 'LOAN'). Должны быть выбраны
-- ID счета, код счета, ID клиента и доступный остаток.
SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account AS a
WHERE product_cd IN (
    SELECT product_cd
    FROM  product
    WHERE product_type_cd = 'LOAN'
  );


-- 9.2
-- Переработайте запрос из упражнения 9.1, используя связанный подзапрос
-- к таблице product для получения того же результата.
SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account AS a
WHERE 'LOAN' = (
    SELECT product_type_cd
    FROM product AS p
    WHERE a.product_cd = p.product_cd
  );

-- 9.2.1
SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account AS a
WHERE EXISTS (
    SELECT 1 FROM product AS p
    WHERE a.product_cd = p.product_cd
      AND p.product_type_cd = 'LOAN'
  );



-- 9.3
-- Соедините следующий запрос с таблицей employee, чтобы показать
-- уровень квалификации каждого сотрудника.
SELECT e.emp_id, CONCAT(e.fname, ' ', e.lname) name,
  (
    SELECT level.name
    FROM (
        SELECT 'trainee ' name, '2004-01-01' start_dt, '2005-12-31' end_dt
        UNION ALL
        SELECT 'worker ' name, '2002-01-01' start_dt, '2003-12-31' end_dt
        UNION ALL
        SELECT 'mentor ' name, '2000-01-01' start_dt, '2001-12-31' end_dt
      ) AS level
    WHERE e.start_date BETWEEN  level.start_dt AND level.end_dt
  ) AS 'level'
FROM employee AS e;

-- 9.3.1
SELECT e.emp_id, CONCAT(e.fname, ' ', e.lname) name, level.name 'level'
FROM employee AS e
  INNER JOIN (
      SELECT 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
      UNION ALL
      SELECT 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
      UNION ALL
      SELECT 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt
    ) AS level
    ON e.start_date BETWEEN level.start_dt and end_dt;



-- 9.4
-- Создайте запрос к таблице employee для получения ID, имени и фамилии
-- сотрудника вместе с названиями отдела и отделения, к которым
-- он приписан. Не используйте соединение таблиц.
SELECT e.emp_id, CONCAT(e.fname, ' ', e.lname) name,
  (
    SELECT d.name
    FROM department AS d
    WHERE e.dept_id = d.dept_id
  ) AS 'department',

  (
    SELECT b.name
    FROM branch AS b
    WHERE e.assigned_branch_id = b.branch_id
  ) AS 'branch'
FROM employee AS e;