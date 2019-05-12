SELECT VERSION(), USER(), DATABASE(), NOW();

SELECT DISTINCT cust_id FROM account;

SELECT emp_id, 'ACTIVE', emp_id * 2, UPPER(fname) FROM employee;

-- псевдонимы
SELECT emp_id, 'ACTIVE' status, emp_id * 3.14159 empid_x_pi,
  UPPER(lname) last_name_upper FROM employee;

SELECT emp_id AS id, 'ACTIVE' AS status FROM employee;

-- подзапросы
SELECT t.open_date
FROM (SELECT * FROM account WHERE avail_balance > 5000) AS t;

SELECT t.emp_id, t.fname, t.lname
FROM (SELECT emp_id, fname, lname, start_date, title FROM employee) t;

-- Представления (виртуальные таблицы)
CREATE VIEW employee_vw AS SELECT emp_id, fname, lname,
  YEAR(start_date) start_year FROM employee;
SELECT emp_id, start_year FROM employee_vw;
DROP VIEW employee_vw;





 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔
⛔                            ФИЛЬТРАЦИЯ (WHERE)                            ⛔
 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔

SELECT emp_id, fname, lname, start_date, title FROM employee
WHERE title = 'Head Teller' AND start_date > '2002-01-01';

SELECT emp_id, fname, lname, start_date, title FROM employee
WHERE (title = 'Head Teller' AND start_date > '2002-01-01') OR
  (title = 'Teller' AND start_date > '2003-01-01');

-- поиск по длине имени
SELECT emp_id, fname, lname FROM employee WHERE LENGTH(lname) = 5;
-- поиск по первой букве
SELECT emp_id, fname, lname FROM employee WHERE LEFT(lname, 1) = 'T';

-- ORDER BY
SELECT emp_id, title, start_date, fname, lname FROM employee ORDER BY 2, 5;
SELECT emp_id, title, start_date, fname, lname FROM employee ORDER BY title, lname;
SELECT * FROM account ORDER BY open_date DESC;
-- сортировка по последним трем разрядам fed_id
SELECT cust_id, cust_type_cd, city, state, fed_id FROM customer
ORDER BY RIGHT(fed_id, 3);

-- LIMIT
SELECT * FROM account LIMIT 5;    --count
SELECT * FROM account LIMIT 8, 3; --offset, count

-- BETWEEN
SELECT account_id, product_cd, cust_id, avail_balance FROM account
WHERE avail_balance BETWEEN 3000 AND 5000;

SELECT * FROM account WHERE open_date BETWEEN '2002-01-01' AND '2002-12-31';

-- IN
SELECT account_id, product_cd, cust_id, avail_balance FROM account
WHERE product_cd IN ('CHK','SAV','CD','MM');

-- в подзапросе должен быть 1 столбец
SELECT account_id, product_cd, cust_id, avail_balance FROM account
WHERE product_cd IN (SELECT product_cd FROM product WHERE product_type_cd = 'ACCOUNT');

-- сравнение кортежей
SELECT * FROM account
WHERE (product_cd, account_id) IN (('CHK', 1), ('MM', 8), ('SAV', 4));

-- NOT IN
SELECT account_id, product_cd, cust_id, avail_balance FROM account
WHERE product_cd NOT IN ('CHK','SAV','CD','MM');

-- LIKE (поиск по маске)
SELECT emp_id, fname, lname FROM employee 
WHERE lname LIKE 'F%' OR lname LIKE 'G%';

SELECT lname FROM employee WHERE lname LIKE '_a%e%';

SELECT cust_id, fed_id FROM customer
WHERE fed_id LIKE '___-__-____';

-- REGEXP (поиск по регулярному выражению) (в MySQL POSIX)
SELECT emp_id, fname, lname FROM employee WHERE lname REGEXP '^[FG]';

SELECT emp_id, fname, lname FROM employee 
WHERE lname REGEXP 'ing$' OR LOWER(lname) REGEXP '^p.+an$';

--NULL
SELECT * FROM employee WHERE superior_emp_id IS NULL;
SELECT * FROM employee WHERE superior_emp_id IS NOT NULL;





 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔
⛔                           СОЕДИНЕНИЕ (INNER JOIN)                        ⛔
 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔

-- CROSS JOIN (декартово произведение)
SELECT e.fname, e.lname, d.name FROM employee e JOIN department d;

-- INNER JOIN
SELECT e.fname, e.lname, d.name
FROM employee AS e
  INNER JOIN department AS d ON e.dept_id = d.dept_id
ORDER BY e.emp_id;

-- старый синтаксиc
SELECT e.fname, e.lname, d.name 
FROM employee e
  INNER JOIN department d WHERE e.dept_id = d.dept_id;

-- USING
SELECT e.fname, e.lname, d.name 
FROM employee e 
  INNER JOIN department d USING (dept_id);

-- соединение 3 таблиц
SELECT e.fname, e.lname, d.name department, b.name branch, b.city
FROM employee e
  INNER JOIN department d ON e.dept_id = d.dept_id
  INNER JOIN branch b ON e.assigned_branch_id = b.branch_id
ORDER BY e.emp_id;


-- Запрос, по которому возвращаются все счета, открытые
-- операционистами (нанятыми до 2003-года), в настоящее время приписанными
-- к отделению Woburn (1 вариант).
SELECT a.account_id, a.cust_id, a.open_date, a.product_cd
FROM account a 
  INNER JOIN employee e ON a.open_emp_id = e.emp_id
  INNER JOIN branch b ON e.assigned_branch_id = b.branch_id
WHERE e.start_date <= '2003-01-01'
  AND (e.title = 'Teller' OR e.title = 'Head Teller')
  AND b.name = 'Woburn Branch';


-- Запрос, возвращающий работника открывшего счет, ID счета и идентификационный номер
-- федерального налога для всех бизнес-счетов.
SELECT a.account_id, c.fed_id, e.fname, e.lname
FROM customer c 
  INNER JOIN account a ON c.cust_id = a.cust_id
  INNER JOIN employee e ON a.open_emp_id = e.emp_id
WHERE c.cust_type_cd = 'B';


-- Запрос, по которому возвращаются все счета, открытые опытными
-- операционистами (нанятыми до 2003-года), в настоящее время приписанными
-- к отделению Woburn (2 вариант).
SELECT a.account_id, a.cust_id, a.open_date, a.product_cd
FROM account a 
  INNER JOIN (
      SELECT emp_id, assigned_branch_id
      FROM employee
      WHERE start_date <= '2003-01-01'
        AND (title = 'Teller' OR title = 'Head Teller')
    ) AS e
    ON a.open_emp_id = e.emp_id
  INNER JOIN (
      SELECT branch_id
      FROM branch
        WHERE name = 'Woburn Branch'
    ) AS b
    ON e.assigned_branch_id = b.branch_id;


--------------- ПОВТОРНОЕ ВКЛЮЧЕНИЕ ОДНОЙ ТАБЛИЦЫ С РАЗНЫМИ ПСЕВДОНИМАМИ---------
-- Этот запрос показывает, кто открыл каждый текущий счет,
-- в каком от делении это произошло и к какому отделению приписан в настоящее
-- время сотрудник, открывший счет.
SELECT a.account_id, e.emp_id, b_a.name open_branch, b_e.name emp_branch
FROM account AS a
  INNER JOIN branch AS b_a ON a.open_branch_id = b_a.branch_id
  INNER JOIN employee AS e ON a.open_emp_id = e.emp_id
  INNER JOIN branch  AS b_e ON e.assigned_branch_id = b_e.branch_id
WHERE a.product_cd = 'CHK';


-------------------- РЕКУРСИВНОЕ ВКЛЮЧЕНИЕ ТАБЛИЦЫ ------------------------------
-- У работника есть начальник (другой работник), ключ superior_emp_id является
-- внешним ключом, который ссылается на эту же таблицу к первичному ключу, id работника.
SELECT e.fname, e.lname, chief.fname chief_fname, chief.lname chief_lname
FROM employee e 
  INNER JOIN employee chief ON e.superior_emp_id = chief.emp_id;


---------------NO-EUIV-JOINS:
SELECT e.emp_id, e.fname, e.lname, e.start_date, p.product_cd
FROM employee e
INNER JOIN product p
  ON e.start_date >= p.date_offered
  AND YEAR(e.start_date) <= 2003;


-- Управляющий операциями решил провести шахматный турнир между всеми
-- операционистами банка. Требуется создать список всех пар игроков.
SELECT e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
FROM employee e1 
  INNER JOIN employee e2 ON e1.emp_id < e2.emp_id
WHERE e1.title = 'Teller'
  AND e2.title = 'Teller';





 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔
⛔                           ОПЕРАЦИИ С МНОЖЕСТВАМИ                         ⛔
 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔

-- UNION (без дублей)
SELECT 1 num, 'abc' str UNION SELECT 9 num, 'xyz' str;

SELECT cust_id, lname name FROM individual
UNION
SELECT cust_id, name FROM business;

-- UNION ALL (с дублями)
SELECT cust_id, lname name FROM individual
UNION ALL
SELECT cust_id, name FROM business
UNION ALL
SELECT cust_id, name FROM business;


-- Найти работников которые работают отделе 2 (Woburn Branch),
-- и работников которые открывали счета в этом отделе.
SELECT emp_id FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
UNION
SELECT open_emp_id FROM account
WHERE open_branch_id = 2;


-- INTSERSECT (ALL) (нет в MySQL)
-- Найти работников которые открывали счета в отделе 2 и сейчас работают там же.
SELECT emp_id FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
INTERSECT
SELECT DISTINCT open_emp_id FROM account
WHERE open_branch_id = 2;


-- EXCEPT (ALL) (нет в MySQL)
-- Найти работников которые сейчас в отделе 2, и никогда не открывали счета в этом отделе.
SELECT emp_id FROM employee
WHERE assigned_branch_id = 2
  AND (title = 'Teller' OR title = 'Head Teller')
EXCEPT
SELECT DISTINCT open_emp_id FROM account
WHERE open_branch_id = 2;





 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔
⛔                 ГРУППИРОВКА И АГРЕГАТЫ (GROUP BY, HAVING)                ⛔
 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔

-- Сколько счетов открыл каждый сотрудник.
-- Группирует акк-ы по id открывающего, и функция COUNT() считает
-- кол-во строк в каждой группе.
SELECT open_emp_id, COUNT(*) how_many 
FROM account
GROUP BY open_emp_id;

-- Можно посчитать по 1 столбцу для каждой группы, если значение
-- столбца NULL, то не считает.
SELECT open_emp_id, COUNT(cust_id) how_many
FROM account
GROUP BY open_emp_id;

-- Сколько счетов открыл каждый сотрудник для разных клиентов.
-- Число уникальных значений столбца в группе.
SELECT open_emp_id, COUNT(DISTINCT cust_id) how_many
FROM account
GROUP BY open_emp_id;

-- Необязательно GROUP BY, по умолчанию всегда есть 1 неявная группа,
-- к которой можно применить агрегатную функцию.
-- Вычисляет сумму столбца для всех строк.
SELECT SUM(avail_balance) how_many FROM account;
-- Можно помещать выражения в функции.
SELECT MAX(pending_balance - avail_balance) max_uncleared FROM account;


-- HAVING.
-- Блок GROUP BY выполняется после WHERE, поэтому в нем нельзя использовать
-- агрегатные функции. Для фильтрации по группам есть HAVING.
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
HAVING how_many > 4;
-- Вариант запроса без HAVING.🡇
SELECT t.open_emp_id, t.how_many
FROM (SELECT open_emp_id, COUNT(*) how_many FROM account GROUP BY open_emp_id) AS t
WHERE t.how_many > 4;


-- Статистическая инфа по счетам разных типов (разные product_cd).
SELECT product_cd, MAX(avail_balance) max_balance, MIN(avail_balance) min_balance,
  AVG(avail_balance) avg_balance, SUM(avail_balance) tot_balance, COUNT(*) num_accs
FROM account
GROUP BY product_cd
ORDER BY avg_balance;


-- Группировка по нескольким столбцам.
SELECT product_cd, open_branch_id, SUM(avail_balance) tot_balance
FROM account
GROUP BY product_cd, open_branch_id;


-- Группировка сотрудников по году начала их работы.
SELECT YEAR(start_date) year, COUNT(*) how_many
FROM employee
GROUP BY year
ORDER BY year;


-- Фильтрация до включения в группу и после.
-- Вывести для каждого типа счета (product_cd) кол-во счетов и их баланс.
-- Причем где баланс для одного типа превышает 10_000,
-- а счета имеют статус 'ACTIVE'.
SELECT product_cd, SUM(avail_balance) prod_balance, COUNT(*) `count`
FROM account
WHERE status = 'ACTIVE'
GROUP BY product_cd
HAVING prod_balance >= 10000
ORDER BY prod_balance;


-- В блоке HAVING не обязательно должны быть функции из SELECT.
SELECT product_cd, SUM(avail_balance) prod_balance
FROM account
WHERE status = 'ACTIVE'
GROUP BY product_cd
HAVING MIN(avail_balance) >= 1000
  AND MAX(avail_balance) <= 10000
ORDER BY prod_balance;


-- Каков общий остаток для всех текущих счетов, открытых в отделении Woburn?
SELECT product_cd, open_branch_id, SUM(avail_balance) tot_balance
FROM account AS a
  INNER JOIN branch AS b ON a.open_branch_id = b.branch_id
WHERE b.name = 'Woburn Branch'
GROUP BY product_cd, open_branch_id;


-- Список начальников и кол-во подчиненных.
SELECT chief.emp_id, chief.fname, chief.lname, COUNT(*) `count`
FROM employee chief
  INNER JOIN employee e ON chief.emp_id = e.superior_emp_id
GROUP BY chief.emp_id
ORDER BY `count`;


-- Список всех работников и сколько у них подчиненных (даже если 0).
SELECT chief.emp_id, chief.fname, chief.lname, COUNT(e.emp_id) subordinates
FROM employee chief
  LEFT JOIN employee e ON chief.emp_id = e.superior_emp_id
GROUP BY chief.emp_id
ORDER BY subordinates DESC;





 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔
⛔                              ПОДЗАПРОСЫ                                  ⛔
 ⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔

-- Какие бывают?
-- Связанные (correlated subqueries);
-- Несвязанные (nested subqueries);

-- скалярный   - возвращает 1 строку и 1 столбец;
-- список      - 1 столбец  и больше 1 строки;
-- кортеж      - 1 строку   и больше 1 столбца;
-- таблица     - больше 1 строки и больше 1 столбца;




-----------------------------------------------------
⛔               НЕСВЯЗАННЫЕ ПОДЗАПРОСЫ             ⛔
-----------------------------------------------------
-- Выполняются перед содержащим выражением и один раз.
-- Не зависит от внешнего запроса.



-- 9.1
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE account_id = (SELECT MAX(account_id) FROM account);


-- 9.2
-- Если тут подзапрос вернет > 1 строки, то будет ошибка.
SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE open_emp_id != (
    SELECT e.emp_id
    FROM employee AS e
      INNER JOIN branch AS b ON e.assigned_branch_id = b.branch_id
    WHERE e.title = 'Head Teller' AND b.city = 'Woburn'
 );


-- 9.3
-- Руководящий состав банка.
-- Тут подзапрос возвращает несколько строк.
SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id IN (SELECT superior_emp_id FROM employee);


-- 9.4
-- В эти 2 подзапросах обязательна фильтрация NULL.
-- Потому что при сравнении значения с NULL, результат NULL.
-- НЕруководящий состав банка. (NOT IN)
SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id NOT IN (
    SELECT superior_emp_id
    FROM employee
    WHERE superior_emp_id IS NOT NULL
  );
-- 9.5
-- НЕруководящий состав банка. (!= ALL)
-- Тот же результат, что и у 9.4.
SELECT emp_id, fname, lname, title
FROM employee
WHERE emp_id != ALL (
    SELECT superior_emp_id
    FROM employee
    WHERE superior_emp_id IS NOT NULL
  );


-- 9.6
-- Список счетов на которых доступный баланс
-- меньше чем на любом из счетов Фрэнка Такера.     (< ALL)
SELECT account_id, cust_id, product_cd, avail_balance
FROM account
WHERE avail_balance < ALL (
    SELECT a.avail_balance
    FROM account AS a
      INNER JOIN individual AS i ON a.cust_id = i.cust_id
    WHERE i.fname = 'Frank' AND i.lname = 'Tucker'
  );

-- 9.7
-- Список счетов на которых доступный баланс больше
-- чем хотя бы на 1 из счетов Фрэнка Такера.        (> ANY)
SELECT account_id, cust_id, product_cd, avail_balance
FROM account
WHERE avail_balance > ANY (
    SELECT a.avail_balance
    FROM account AS a
      INNER JOIN individual AS i ON a.cust_id = i.cust_id
    WHERE i.fname = 'Frank' AND i.lname = 'Tucker'
  );



-- 9.8
-- Счета открытые всеми операцианистами в Woburn Branch
SELECT account_id, product_cd, cust_id
FROM account
WHERE open_branch_id = (
    SELECT branch_id
    FROM branch
    WHERE name = 'Woburn Branch'
  )
  AND open_emp_id IN (
    SELECT emp_id
    FROM employee
    WHERE title = 'Teller' OR title = 'Head Teller'
  );


-- ⛔9.9
-- Условие вхождения кортежа.
-- (val, val) IN (select ...)
-- Тот же результат, что и у 9.8.
-- Этот запрос не учитывает, что у работника мог поменяться отдел.
-- Результат у него такой же, но логика другая.
SELECT account_id, product_cd, cust_id
FROM account
WHERE (open_branch_id, open_emp_id) IN (
    SELECT b.branch_id, e.emp_id
    FROM branch AS b
      INNER JOIN employee AS e ON b.branch_id = e.assigned_branch_id
    WHERE b.name = 'Woburn Branch'
      AND (e.title = 'Teller' OR e.title = 'Head Teller')
  );

-- 9.10
-- Вариант без подзапросов.
-- Тот же результат, что и у 9.8.
SELECT a.account_id, a.product_cd, a.cust_id
FROM account a
  INNER JOIN branch b ON a.open_branch_id = b.branch_id
  INNER JOIN employee e ON a.open_emp_id = e.emp_id
WHERE b.name = 'Woburn Branch'
  AND (e.title = 'Teller' OR e.title = 'Head Teller');




-----------------------------------------------------
⛔              СВЯЗАННЫЕ ПОДЗАПРОСЫ                ⛔
-----------------------------------------------------
-- Выполняется для каждой строки содержащего выражения.
-- Зависит от внешнего запроса.



-- 9.11
-- Подзапрос считает кол-во счетов у каждого клиента.
-- Затем основной запрос выбирает тех, у которых по 2 счета.
-- И так для каждой строки внешнего запроса.
SELECT c.cust_id, c.cust_type_cd, c.city
FROM customer c
WHERE 2 = (
    SELECT COUNT(*)
    FROM account a
    WHERE a.cust_id = c.cust_id
  );


-- 9.12
-- Находит всех клиентов, чей общий доступный остаток по всем
-- счетам находится в диапазоне от 5000 до 10_000 долларов.
SELECT c.cust_id, c.cust_type_cd, c.city
FROM customer c
WHERE (
    SELECT SUM(a.avail_balance)
    FROM account a
    WHERE a.cust_id = c.cust_id
  )
  BETWEEN 5000 AND 10000;

-- 9.13
-- Вариант без подзапроса, запроса 9.12.
SELECT c.cust_id, c.cust_type_cd, c.city
FROM customer c
  INNER JOIN account a ON c.cust_id = a.cust_id
GROUP BY a.cust_id
HAVING SUM(a.avail_balance) BETWEEN 5000 AND 10000;


-- 9.14
-- Находит все счета, для которых транзакция была
-- выполнена в определенный день.
-- EXISTS применяется чтобы показать что связь есть, и не важно
-- что подзапрос возвращает.
SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account a
WHERE EXISTS (
    SELECT 1 FROM transaction t
    WHERE t.account_id = a.account_id
      AND t.txn_date = '2004-06-30'
  );


-- 9.15
-- Этот запрос выявляет акк-ы всех клиентов, ID которых нет в таблице business.
SELECT a.account_id, a.product_cd, a.cust_id
FROM account a
WHERE NOT EXISTS (
    SELECT 1
    FROM business b
    WHERE b.cust_id = a.cust_id
  );


-- ⛔9.16
-- В дату последней активности счета устанавливается дата последней (по времени)
-- транзакции. Проверка нужна на тот случай если нет никаких транзакций для
-- определенного счета, иначе установится null.
UPDATE account a
SET a.last_activity_date = (
    SELECT MAX(t.txn_date)
    FROM transaction t
    WHERE t.account_id = a.account_id
  )
WHERE EXISTS (
    SELECT 1
    FROM transaction t
    WHERE t.account_id = a.account_id
  );


-- ⛔9.17
-- Удаляет из таблицы department данные, не имеющие до
-- черних строк в таблице employee.
-- В MySQL в связанных запросах с DELETE, нельзя использовать псевдонимы.
DELETE FROM department
WHERE NOT EXISTS (
    SELECT 1
    FROM employee
    WHERE employee.dept_id = department.dept_id
  );











⛔⛔⛔⛔⛔
----------------------НЕСВЯЗАННЫЕ ПОДЗАПРОСЫ

-- 9.18
-- Список отделов с указанием количества сотрудников,
-- приписанных к каждому отделу.
SELECT d.dept_id, d.name, e.how_many num_employees
FROM department AS d
  INNER JOIN (
      SELECT dept_id, COUNT(*) how_many
      FROM employee
      GROUP BY dept_id
    ) AS e
    ON d.dept_id = e.dept_id;

-- 9.18.1
-- Вариант попроще запроса 9.18, без подзапроса.
SELECT d.dept_id, d.name, COUNT(*)
FROM employee AS e
  INNER JOIN department d ON e.dept_id = d.dept_id
GROUP BY e.dept_id;


-- 9.19
-- Чтобы не создавать в базе лишнюю таблицу для отчета например.
-- Можно использовать подзапрос, для формирования групп.
--
-- Этот запрос разбивает клиентов по группам на основе баланса,
-- и считает сколько в каждой группе.
SELECT `groups`.name, COUNT(*) num_customers
FROM (
    SELECT SUM(a.avail_balance) cust_balance
    FROM account AS a
      INNER JOIN product AS p ON a.product_cd = p.product_cd
    WHERE p.product_type_cd = 'ACCOUNT'
    GROUP BY a.cust_id
  ) AS cust_rollup

  INNER JOIN (
      SELECT 'Small Fry' name, 0 low_limit, 4999.99 high_limit
      UNION ALL
      SELECT 'Average Joes' name, 5000 low_limit, 9999.99 high_limit
      UNION ALL
      SELECT 'Heavy Hitters' name, 10000 low_limit, 9999999.99 high_limit
    ) AS `groups`
    ON cust_rollup.cust_balance BETWEEN `groups`.low_limit AND `groups`.high_limit
GROUP BY `groups`.name;


-- 9.20
-- Этот запрос суммирует все остатки депозитных счетов по типу счета,
-- отделениям в которых были открыты счета и сотруднику открывшему их.
SELECT p.name product, b.name branch,
  CONCAT(e.fname, ' ', e.lname) employer,
  SUM(a.avail_balance) deposits
FROM account AS a
  INNER JOIN employee AS e ON a.open_emp_id = e.emp_id
  INNER JOIN branch AS b ON a.open_branch_id = b.branch_id
  INNER JOIN product AS p ON a.product_cd = p.product_cd
WHERE p.product_type_cd = 'ACCOUNT'
GROUP BY p.name, b.name, e.fname, e.lname;


-- 9.20.1
-- Как запрос 9.20 но с подзапросом.
-- Тут подзапрос формирует группы, а джойны нужны
-- для представления данных.
-- И тут группировка по числам, что явно быстрее чем по строкам.
SELECT p.name product, b.name branch,
  CONCAT(e.fname, ' ', e.lname) name,
  account_groups.deposits
FROM (
    SELECT product_cd, open_branch_id branch_id,
      open_emp_id emp_id, SUM(avail_balance) deposits
    FROM account
    GROUP BY product_cd, open_branch_id, open_emp_id
  ) AS account_groups

  INNER JOIN employee AS e ON account_groups.emp_id = e.emp_id
  INNER JOIN branch AS b ON account_groups.branch_id = b.branch_id
  INNER JOIN product AS p ON account_groups.product_cd = p.product_cd
WHERE p.product_type_cd = 'ACCOUNT';


-- 9.21
-- Найти сотрудников у которых число открытых счетов выше среднего.
SELECT open_emp_id, COUNT(*) how_many
FROM account
GROUP BY open_emp_id
HAVING COUNT(*) > (
    SELECT AVG(emp_cnt.how_many)
    FROM (
        SELECT COUNT(*) how_many
        FROM account
        GROUP BY open_emp_id
      ) AS emp_cnt
  );


-- 9.22
-- Скалярные запросы можно использовать в блоке SELECT.
-- Вариант запроса 9.20.1, но тут есть ошибка.
-- Первый подзапрос возвращает null.
SELECT (
    SELECT p.name
    FROM product p
    WHERE a.product_cd = p.product_cd
      AND p.product_type_cd = 'ACCOUNT'
  ) AS product,

  (
    SELECT b.name FROM branch b
    WHERE a.open_branch_id = b.branch_id
  ) AS branch,

  (
    SELECT CONCAT(e.fname, ' ', e.lname)
    FROM employee e
    WHERE  a.open_emp_id = e.emp_id
  ) AS name,

  SUM(a.avail_balance) AS deposits
FROM account AS a
GROUP BY a.product_cd, a.open_branch_id, a.open_emp_id;


-- 9.23
-- Исправленный запрос 9.22.
-- Точнее запрос 9.22 вложен внутрь запроса,
-- который просто отбрасывает группы с null-ями.
SELECT prod.product, prod.branch,
  prod.name, prod.deposits
FROM (
    SELECT (
      SELECT p.name
      FROM product p
      WHERE a.product_cd = p.product_cd
        AND p.product_type_cd = 'ACCOUNT'
    ) AS product,

    (
      SELECT b.name
      FROM branch b
      WHERE a.open_branch_id = b.branch_id
    ) AS branch,

    (
      SELECT CONCAT(e.fname, ' ', e.lname)
      FROM employee e
      WHERE a.open_emp_id = e.emp_id
    ) AS name,

    SUM(a.avail_balance) AS deposits

    FROM account AS a
    GROUP BY a.product_cd, a.open_branch_id, a.open_emp_id
  ) AS prod
WHERE prod.product IS NOT NULL;


-- 9.24
-- Работники и их начальники.
SELECT emp.emp_id, CONCAT(emp.fname, ' ', emp.lname) emp_name,
  (
    SELECT CONCAT(boss.fname, ' ', boss.lname)
    FROM employee AS boss
    WHERE boss.emp_id = emp.superior_emp_id
  ) AS boss_name

FROM employee AS emp
WHERE emp.superior_emp_id IS NOT NULL
ORDER BY emp.emp_id;


-- 9.25
-- Формирует значения из подзапросов.
INSERT INTO account (account_id, product_cd, cust_id, open_date, last_activity_date,
  status, open_branch_id, open_emp_id, avail_balance, pending_balance)
VALUES
  (
    NULL, (SELECT product_cd FROM product WHERE name = 'savings account'),
    (SELECT cust_id FROM customer WHERE fed_id = '555-55-5555'),
    NOW(), NOW(), 'ACTIVE',
    (SELECT branch_id FROM branch WHERE name = 'Quincy Branch'),
    (SELECT emp_id FROM employee WHERE lname = 'Portman' AND fname = 'Frank'),
    0, 0
  );











ТИПЫ, приведение, даты
-------------7 ГЛАВА------------------
SELECT LENGTH(char_fld) char_length,
LENGTH(vchar_fld) varchar_length,
LENGTH(text_fld) text_length
FROM string_tbl;



SELECT CONCAT(fname, ' ', lname, ' has been a ',
    title, ' since ', start_date) emp_narrative
FROM employee
WHERE title = 'Teller' OR title = 'Head Teller';


SELECT POW(2, 10) kilobyte, POW(2, 20) megabyte, POW(2, 30) gigabyte, POW(2, 40) terabyte;


SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3);
SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2), TRUNCATE(72.0909, 3);
SELECT ROUND(155, -1), TRUNCATE(155, -1), ROUND(155, -2), TRUNCATE(155, -2);

SELECT account_id, SIGN(avail_balance), ABS(avail_balance)
FROM account;


SELECT CAST('2005-03-27' AS DATE) date_field,
CAST('108:17:57' AS TIME) time_field;


INSERT INTO ch (date) 
VALUES (STR_TO_DATE('March 27, 2005', '%M %d, %Y'));

SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP(), NOW();

SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);









☛разобрать ALL, ANY, IN, SOME, EXISTS
☛ (IN)        и      (= ANY)  эквивалентны
☛ (NOT IN)    и      (!= ALL) эквивалентны
☛ (val, val) IN (select ...)
☛ EXISTS - true если подзапрос возвращает хотя бы 1 строку, не важно какие столбцы,
          (используется в связанных запросах).

-- КАК ЭТО РАБОТАЕТ  ☟
⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔


SELECT product_cd, open_branch_id,
SUM(avail_balance) tot_balance
FROM account
GROUP BY product_cd  , open_branch_id WITH ROLLUP;


SELECT 'ALERT! : Account #1 Has Incorrect Balance!'
FROM account
WHERE (avail_balance, pending_balance) <>
(SELECT SUM(<expression to generate available balance>),
SUM(<expression to generate pending balance>)
FROM transaction
WHERE account_id = 1)
⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔⛔