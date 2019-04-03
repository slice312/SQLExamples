LEN(string) -- -> длина строки;
CHARINDX(), -- -аналог locate и position из mysql;
вместо CONCAT(), оператор +
вместо MOD(), оператор %
POWER() -- как pow()

CEILING(), FLOOR(), ROUND() -- округление 1)вверх, 2)вниз, 3)куда ближе;
ROUND() -- с тремя аргументами как TRUNCATE() в mysql



REPLACE(string, string substr, string replace);
STUFF() -- как INSERT() в MySQL

SUBSTR или SUBSTRING

CAST()



getutcdate() 
current_timestamp() 
dateadd()
YEAR()
GETDATE()
FORMAT(date, "pattern")
datepart(week, '2019.01.12');



CURRENT_TIMESTAMP   Returns the current date and time
DATEADD Adds a time/date interval to a date and then returns the date
DATEDIFF    Returns the difference between two dates
DATEFROMPARTS   Returns a date from the specified parts (year, month, and day values)
DATENAME    Returns a specified part of a date (as string)
DATEPART    Returns a specified part of a date (as integer)
DAY Returns the day of the month for a specified date
GETDATE Returns the current database system date and time
GETUTCDATE  Returns the current database system UTC date and time
ISDATE  Checks an expression and returns 1 if it is a valid date, otherwise 0
MONTH   Returns the month part for a specified date (a number from 1 to 12)
SYSDATETIME Returns the date and time of the SQL Server
YEAR    Returns the year part for a specified date









-- ПОСМОТРЕТЬ РАЗМЕРЫ БАЗ
SELECT      sys.databases.name,
            CONVERT(VARCHAR,SUM(size)*8/1024)+' MB' AS [Total disk space]
FROM        sys.databases   
JOIN        sys.master_files  
ON          sys.databases.database_id=sys.master_files.database_id
GROUP BY    sys.databases.name
ORDER BY    sys.databases.name


-- Посмотреть индексы (является ли таблица кучей).
use krsu_2;
SELECT * FROM sys.indexes
WHERE object_id = (
        SELECT object_id FROM sys.tables
        WHERE name = 'Города'
    )

--как в MySQL: show tables
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'