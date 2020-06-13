USE CalendarDemo;
GO


IF COL_LENGTH(N'dbo.Calendar', N'IsoWeek') IS NULL
    ALTER TABLE dbo.Calendar ADD IsoWeek       TINYINT  NULL,
                                 IsoYear       SMALLINT NULL,
                                 FiscalYear    SMALLINT NULL,
                                 FiscalQuarter TINYINT  NULL;
GO

-- Fiscal year starts on the first of @FiscalStartMonth and is named for the year it ENDS in.
DECLARE @FiscalStartMonth INT = 7;

UPDATE dbo.Calendar
SET IsoWeek = DATEPART(ISO_WEEK, CalendarDate),
    -- The ISO year is the year of the Thursday in the same ISO week
    IsoYear = YEAR(DATEADD(DAY, 4 - DayOfWeekNo, CalendarDate)),
    FiscalYear = CASE WHEN @FiscalStartMonth = 1 THEN CalYear
                      WHEN CalMonth >= @FiscalStartMonth THEN CalYear + 1
                      ELSE CalYear END,
    FiscalQuarter = ((CalMonth - @FiscalStartMonth + 12) % 12) / 3 + 1;
GO

-- Check: 2020-12-31 is in ISO week 53 of 2020; 2021-01-01 is still ISO week 53 of 2020.
SELECT CalendarDate, IsoYear, IsoWeek, FiscalYear, FiscalQuarter
FROM dbo.Calendar
WHERE CalendarDate IN ('2020-12-31', '2021-01-01', '2021-07-01');
