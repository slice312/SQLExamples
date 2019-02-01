----------------------------------- SAMPLES-------------------------------
-- просмотр ограничений таблицы
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'bank' AND TABLE_NAME = 'employee' 
      AND REFERENCED_COLUMN_NAME IS NOT NULL;

-- просмотр комментариев к таблице
SELECT TABLE_COMMENT
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bank' AND TABLE_NAME = 'individual';
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- 3.1
SELECT emp_id, fname, lname FROM employee ORDER BY lname, fname;

-- 3.2
SELECT account_id, cust_id, avail_balance FROM account  
WHERE status = 'ACTIVE' AND avail_balance > 2500;

-- 3.3
SELECT DISTINCT open_emp_id FROM account;

-- 3.4
SELECT p.product_cd, a.cust_id, a.avail_balance FROM product p 
INNER JOIN account a ON p.product_cd = a.product_cd WHERE p.product_type_cd = 'ACCOUNT';



-- 4.3
SELECT * FROM account WHERE YEAR(open_date) = 2002;
SELECT * FROM account WHERE open_date BETWEEN '2002-01-01' AND '2002-12-31';

-- 4.4
SELECT * FROM individual WHERE lname LIKE '_a%e%';
SELECT * FROM individual WHERE lname REGEXP '^.a.*e';



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