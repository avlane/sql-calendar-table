USE CalendarDemo;
GO


-- Fills 2000-01-01 .. 2049-12-31 (18,263 rows). Re-runnable.
DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate   DATE = '2049-12-31';

TRUNCATE TABLE dbo.Calendar;

WITH d AS
(
    SELECT @StartDate AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt) FROM d WHERE dt < @EndDate
)
INSERT INTO dbo.Calendar (CalendarDate, CalYear, CalMonth, CalDay, DayOfWeekNo)
SELECT dt,
       YEAR(dt),
       MONTH(dt),
       DAY(dt),
       -- 1900-01-01 was a Monday, so this does not depend on SET DATEFIRST
       (DATEDIFF(DAY, '1900-01-01', dt) % 7) + 1
FROM d
OPTION (MAXRECURSION 0);   -- default limit is 100 levels

SELECT COUNT(*) AS rows_loaded, MIN(CalendarDate) AS first_date, MAX(CalendarDate) AS last_date
FROM dbo.Calendar;
