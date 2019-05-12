/* 

psql -h localhost -d database -U username     -- connect via terminal;

\c DBname             - connect DB (like 'use' in MySQL)
\l                    - show databases;
\dn                   - show schemas;
\dt                   - show tables;
\d или \d+ tablename  - describe table;
\du                   - show users and roles;
\s file               - save history on file;



SET search_path TO name    - select schema;


\e                    - use nano for edit query;
CTRL + C              - cancel input query;

*/
В DataGrip в VM options добавить: -Duser.timezone=Asia/Almaty
SELECT * FROM pg_timezone_names; -- показать всем таймзоны%



COALESCE --????

SELECT VERSION(), NOW();

CREATE USER username WITH PASSWORD 'qwerty123'; -- new user;
ALTER USER username WITH PASSWORD 'qwerty123';  -- change password;
ALTER USER username WITH SUPERUSER;             -- grant privileges;
DROP USER username;


CREATE DATABASE test OWNER 'slice' ENCODING = 'UTF8'
  LC_COLLATE = 'en_US.UTF8'  LC_CTYPE = 'en_US.UTF8' template template0;
DROP DATABASE test;





SELECT pid, usename, state FROM pg_stat_activity;   -- показать выполняющиеся запросы






Стороквые литералы:
$$строка '23'$$ (кавычки не надо экранировать);
E'pgday\'17'  - строка в стиле Си;


Привидение типов (CAST и ::)
CAST ('10.2' AS DOUBLE PRECISION);

'01-OCT-2015'::DATE;
'100'::INTEGER;


---------------------------------DATE FUNCTIONS------------------------------------------
Формат по умолчанию 'yyyy-mm-dd'
SELECT '2016-09-12'::date;
SELECT 'Sep 12, 2016'::date;
SELECT 'September 12, 2016'::date;
SELECT '21:15'::time;
SELECT '21:15:42'::time;
SELECT '10:15:16 am'::time;
SELECT '10:15:16 pm'::time;
SELECT '2016-09-21 22:25:35'::timestamp;




SELECT TO_CHAR(current_date, 'dd:mm:yyyy');

NOW()                -- ??? 
current_date         -- текущая дата, без скобок вызывается;
current_time         -- текущее время, без скобок вызывается;
current_timestamp    -- ??
TO_CHAR()            -- ???





















SELECT *
  FROM mytable
 WHERE (group_id, group_type) IN (
                                  VALUES ('1234-567', 2), 
                                         ('4321-765', 3), 
                                         ('1111-222', 5)
                                 );









CREATE TABLE courses
(
  c_no TEXT PRIMARY KEY,
  title TEXT,
  hours INTEGER
);


CREATE TABLE students
(
  s_id INTEGER PRIMARY KEY,
  name TEXT,
  start_year INTEGER
);


CREATE TABLE exams
(
  s_id INTEGER REFERENCES students(s_id),
  c_no TEXT REFERENCES courses(c_no),
  score INTEGER,
  CONSTRAINT PK_exams PRIMARY KEY(s_id, c_no)
);



INSERT INTO courses(c_no, title, hours)
VALUES ('CS301', 'Базы данных', 30), ('CS305', 'Сети ЭВМ', 60);

INSERT INTO students(s_id, name, start_year)
VALUES (1451, 'Анна', 2014), (1432, 'Виктор', 2014), (1556, 'Нина', 2015);

INSERT INTO exams(s_id, c_no, score)
VALUES (1451, 'CS301', 5), (1556, 'CS301', 5),
  (1451, 'CS305', 5), (1432, 'CS305', 4);


-- ЗАПРОСЫ
SELECT title AS course_title, hours FROM courses;
SELECT DISTINCT start_year FROM students;
SELECT * FROM courses WHERE hours > 45;

-------------------------------
SELECT * FROM courses 
  CROSS JOIN exams;

SELECT s.name, c.title, e.score
FROM exams e
INNER JOIN courses c ON e.c_no = c.c_no
INNER JOIN students s ON e.s_id = s.s_id;


SELECT s.name, e.score
FROM students s
INNER JOIN exams e ON s.s_id = e.s_id
  AND e.c_no = 'CS305';

SELECT s.name, e.score
FROM students s
LEFT JOIN exams e ON s.s_id = e.s_id
  AND e.c_no = 'CS305';
-------------------------------


-- ПОДЗАПРОСЫ
SELECT name, (
    SELECT score
    FROM exams
    WHERE exams.s_id = students.s_id
      AND exams.c_no = 'CS305'
  ) 
FROM students;


SELECT * FROM exams
WHERE (
    SELECT start_year
    FROM students
    WHERE students.s_id = exams.s_id
  ) > 2014;


SELECT name, start_year
FROM students
WHERE s_id IN (
    SELECT s_id
    FROM exams
    WHERE c_no = 'CS305'
  );


SELECT name, start_year
FROM students
WHERE s_id NOT IN (
    SELECT s_id
    FROM exams
    WHERE score < 5
  );


SELECT name, start_year
FROM students
WHERE NOT EXISTS (
    SELECT 1
    FROM exams
    WHERE exams.s_id = students.s_id
      AND score < 5
  );


SELECT s.name, ce.score
FROM students s
JOIN (
    SELECT exams.*
    FROM courses, exams
    WHERE courses.c_no = exams.c_no
      AND courses.title = 'Базы данных'
  ) ce
  ON s.s_id = ce.s_id;


SELECT s.name, e.score
FROM students s, courses c, exams e
WHERE c.c_no = e.c_no
  AND c.title = 'Базы данных'
  AND s.s_id = e.s_id;






  --- ТРАНЗАКЦИИ
CREATE TABLE groups
(
  g_no TEXT PRIMARY KEY,
  monitor INTEGER NOT NULL REFERENCES students(s_id)
);



ALTER TABLE students
  ADD g_no TEXT REFERENCES groups(g_no);