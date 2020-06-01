USE CalendarDemo;
GO


IF COL_LENGTH(N'dbo.Calendar', N'CalQuarter') IS NULL
    ALTER TABLE dbo.Calendar ADD CalQuarter  TINYINT     NULL,
                                 MonthName   VARCHAR(10) NULL,
                                 DayName     VARCHAR(10) NULL,
                                 DayOfYear   SMALLINT    NULL,
                                 FirstOfMonth DATE       NULL,
                                 LastOfMonth  DATE       NULL;
GO

UPDATE dbo.Calendar
SET CalQuarter   = DATEPART(QUARTER, CalendarDate),
    MonthName    = DATENAME(MONTH, CalendarDate),
    DayName      = CHOOSE(DayOfWeekNo, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    DayOfYear    = DATEPART(DAYOFYEAR, CalendarDate),
    FirstOfMonth = DATEFROMPARTS(CalYear, CalMonth, 1),
    LastOfMonth  = EOMONTH(CalendarDate);
GO

-- MonthName comes from DATENAME and follows the session language; DayName is hard-coded
-- English on purpose so the table does not change with SET LANGUAGE.
