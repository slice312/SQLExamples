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