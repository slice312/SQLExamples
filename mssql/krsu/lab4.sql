USE krsu_3

-- 1
SELECT TOP(10) p.НаимСырья, p.ЦенаСырья 
FROM Сырье AS p
INNER JOIN Типы_сырья AS t ON p.КодТипаСырья = t.КодТипаСырья
WHERE t.НаимТипаСырья = 'Напитки'
ORDER BY p.ЦенаСырья DESC


SELECT TOP(10) НаимСырья, ЦенаСырья
FROM Сырье
WHERE КодТипаСырья IN(
  SELECT КодТипаСырья FROM Типы_сырья
  WHERE НаимТипаСырья = 'Напитки'
)
ORDER BY ЦенаСырья DESC




-- 2 ПРОВЕРИТЬ, НЕПРАВИЛЬНО
SELECT * FROM Сырье AS mn
INNER JOIN Ед_изм AS ee ON mn.КодЕдИзм = ee.КодЕдИзм
WHERE ee.НаимЕдИзм != 'Шт.' AND  mn.ЦенаСырья > ANY(
    SELECT p.ЦенаСырья FROM Сырье AS p
    INNER JOIN Ед_изм AS e ON p.КодЕдИзм = e.КодЕдИзм
    WHERE e.НаимЕдИзм = 'Шт.'
)
ORDER BY mn.ЦенаСырья DESC







-- 3
SELECT COUNT(*) AS 'кол-во'
FROM Сырье AS p
INNER JOIN Типы_сырья AS t ON p.КодТипаСырья = t.КодТипаСырья
INNER JOIN Ед_изм AS e ON p.КодЕдИзм = e.КодЕдИзм
WHERE e.НаимЕдИзм = 'Бут.' AND t.НаимТипаСырья = 'Напитки'


-- 4
SELECT TOP(10) MAX(p.ЦенаСырья) AS макс, ROUND(AVG(p.ЦенаСырья), 2) AS сред
FROM Сырье AS p
INNER JOIN [Ед_изм] AS t ON p.КодЕдИзм = t.КодЕдИзм
WHERE t.НаимЕдИзм = 'Килограмм'
