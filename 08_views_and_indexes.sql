USE CalendarDemo;
GO


CREATE OR ALTER VIEW dbo.vw_BusinessDays
AS
SELECT CalendarDate,
       CalYear,
       CalMonth,
       ROW_NUMBER() OVER (PARTITION BY CalYear, CalMonth ORDER BY CalendarDate) AS BusinessDayOfMonth,
       ROW_NUMBER() OVER (PARTITION BY CalYear ORDER BY CalendarDate)           AS BusinessDayOfYear
FROM dbo.Calendar
WHERE IsWeekend = 0 AND IsHolidayObserved = 0;
GO

-- Lookups by month and by fiscal period
CREATE NONCLUSTERED INDEX IX_Calendar_YearMonth ON dbo.Calendar (CalYear, CalMonth) INCLUDE (CalendarDate);
CREATE NONCLUSTERED INDEX IX_Calendar_Fiscal    ON dbo.Calendar (FiscalYear, FiscalQuarter) INCLUDE (CalendarDate);
GO

-- Which business day of the month is today?
SELECT BusinessDayOfMonth FROM dbo.vw_BusinessDays WHERE CalendarDate = CONVERT(DATE, GETDATE());
