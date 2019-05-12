USE krsu_2_copy;

-- Перевести в отдел 1 всех сотрудников 3-его отдела, заработная плата которых
-- не превышает 300 у.е., а в отдел 2 перевести всех сотрудников 3-его отдела,
-- заработная плата которых превышает 300 у.е.
UPDATE Сотрудники
SET Отдел = 1
WHERE Отдел = 3 AND Зарплата <= 300;

UPDATE Сотрудники
SET Отдел = 2
WHERE Отдел = 3 AND Зарплата > 300;


-- Увеличить на 100 у.е. заработную плату сотрудников 1-ого отдела, родившихся в 1985г.
UPDATE Сотрудники
SET Зарплата += 100
WHERE Отдел = 1 AND YEAR([Дата рождения]) = 1985;

-- Удалить все записи, соответствующие сотрудникам 2-ого отдела с заработной платой, превышающей 450 у.е.
DELETE FROM Сотрудники
WHERE Отдел = 2 AND Зарплата > 450;

-- Удалить все строки из таблицы.
TRUNCATE TABLE Сотрудники;



-- Создать индекс по полям [Номер отдела] и [ФИО сотрудника] в табл. Сотрудники.
CREATE INDEX IX_Сотрудники_Отдел_ФИО
ON Сотрудники (Отдел, Фамилия, Имя, Отчество);

-- Создать индекс на уникальность [Наименование страны] в табл. Страны.
CREATE UNIQUE INDEX IX_Страны_НаименованиеСтраны
ON Страны ([Наименование страны]);

-- Создать индекс на уникальность города в пределах одной страны.
CREATE UNIQUE INDEX IX_Города_НаименованиеГорода_КодСтраны
ON Города ([Наименование города], [Код страны]);

-- Удалить индекс по полям [Номер отдела] и [ФИО сотрудника]
IF EXISTS (SELECT * FROM sys.indexes WHERE NAME = 'IX_Сотрудники_Отдел_ФИО')
  DROP INDEX IX_Сотрудники_Отдел_ФИО ON Сотрудники;