USE CalendarDemo;
GO


-- SQL Server 2022 (compatibility level 160) and later only.
-- The recursive CTE in 02_populate_recursive.sql still works everywhere and stays as is.
DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate   DATE = '2049-12-31';
DECLARE @DayCount  INT  = DATEDIFF(DAY, @StartDate, @EndDate);   -- 18262, so 18263 rows with a 0 start

TRUNCATE TABLE dbo.Calendar;

INSERT INTO dbo.Calendar (CalendarDate, CalYear, CalMonth, CalDay, DayOfWeekNo)
SELECT d.dt,
       YEAR(d.dt),
       MONTH(d.dt),
       DAY(d.dt),
       (DATEDIFF(DAY, '1900-01-01', d.dt) % 7) + 1
FROM GENERATE_SERIES(0, @DayCount) AS gs
CROSS APPLY (SELECT DATEADD(DAY, CONVERT(INT, gs.value), @StartDate) AS dt) AS d;

SELECT COUNT(*) AS rows_loaded, MIN(CalendarDate) AS first_date, MAX(CalendarDate) AS last_date
FROM dbo.Calendar;
