USE CalendarDemo;
GO


IF COL_LENGTH(N'dbo.Calendar', N'IsEaster') IS NULL
    ALTER TABLE dbo.Calendar ADD IsEaster BIT NULL, IsGoodFriday BIT NULL;
GO

DROP FUNCTION IF EXISTS dbo.fn_EasterSunday;
GO

-- Anonymous Gregorian algorithm (Meeus/Jones/Butcher).
CREATE FUNCTION dbo.fn_EasterSunday (@Year INT)
RETURNS TABLE
AS
RETURN
(
    SELECT DATEFROMPARTS(@Year, s9.mth, s9.dy) AS EasterDate
    FROM (SELECT @Year % 19 AS a, @Year / 100 AS b, @Year % 100 AS c) AS s1
    CROSS APPLY (SELECT s1.b / 4 AS d, s1.b % 4 AS e, (s1.b + 8) / 25 AS f) AS s2
    CROSS APPLY (SELECT (s1.b - s2.f + 1) / 3 AS g) AS s3
    CROSS APPLY (SELECT (19 * s1.a + s1.b - s2.d - s3.g + 15) % 30 AS h) AS s4
    CROSS APPLY (SELECT s1.c / 4 AS i, s1.c % 4 AS k) AS s5
    CROSS APPLY (SELECT (32 + 2 * s2.e + 2 * s5.i - s4.h - s5.k) % 7 AS l) AS s6
    CROSS APPLY (SELECT (s1.a + 11 * s4.h + 22 * s6.l) / 451 AS m) AS s7
    CROSS APPLY (SELECT s4.h + s6.l - 7 * s7.m + 114 AS n) AS s8
    CROSS APPLY (SELECT s8.n / 31 AS mth, s8.n % 31 + 1 AS dy) AS s9
);
GO

UPDATE dbo.Calendar SET IsEaster = 0, IsGoodFriday = 0;

UPDATE c SET c.IsEaster = 1
FROM dbo.Calendar AS c
CROSS APPLY dbo.fn_EasterSunday(c.CalYear) AS e
WHERE c.CalendarDate = e.EasterDate;

UPDATE dbo.Calendar SET IsGoodFriday = 1
WHERE CalendarDate IN (SELECT DATEADD(DAY, -2, CalendarDate) FROM dbo.Calendar WHERE IsEaster = 1);
GO

-- Known Easter dates: 2020-04-12, 2021-04-04, 2022-04-17.
SELECT CalendarDate FROM dbo.Calendar WHERE IsEaster = 1 AND CalYear BETWEEN 2020 AND 2022;
