USE CalendarDemo;
GO


-- SQL Server 2022 variant of 03_names_and_quarters.sql. Run after 22_populate_generate_series.sql.
IF COL_LENGTH(N'dbo.Calendar', N'CalQuarter') IS NULL
    ALTER TABLE dbo.Calendar ADD CalQuarter   TINYINT     NULL,
                                 MonthName    VARCHAR(10) NULL,
                                 DayName      VARCHAR(10) NULL,
                                 DayOfYear    SMALLINT    NULL,
                                 FirstOfMonth DATE        NULL,
                                 LastOfMonth  DATE        NULL;
GO

UPDATE dbo.Calendar
SET CalQuarter   = DATEPART(QUARTER, CalendarDate),
    MonthName    = DATENAME(MONTH, CalendarDate),
    DayName      = CHOOSE(DayOfWeekNo, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    DayOfYear    = DATEPART(DAYOFYEAR, CalendarDate),
    FirstOfMonth = CONVERT(DATE, DATETRUNC(MONTH, CalendarDate)),
    LastOfMonth  = EOMONTH(CalendarDate);
GO

-- DATETRUNC(ISO_WEEK, ...) also gives the Monday of each ISO week.
IF COL_LENGTH(N'dbo.Calendar', N'WeekStart') IS NULL
    ALTER TABLE dbo.Calendar ADD WeekStart DATE NULL;
GO
UPDATE dbo.Calendar SET WeekStart = CONVERT(DATE, DATETRUNC(ISO_WEEK, CalendarDate));
GO
