USE CalendarDemo;
GO


IF COL_LENGTH(N'dbo.Calendar', N'IsWeekend') IS NULL
    ALTER TABLE dbo.Calendar ADD IsWeekend     BIT NULL,
                                 IsHoliday     BIT NULL,
                                 HolidayName   VARCHAR(40) NULL;
GO

UPDATE dbo.Calendar
SET IsWeekend   = CASE WHEN DayOfWeekNo IN (6, 7) THEN 1 ELSE 0 END,
    IsHoliday   = 0,
    HolidayName = NULL;

UPDATE dbo.Calendar
SET IsHoliday = 1,
    HolidayName = CASE WHEN CalMonth = 1  AND CalDay = 1  THEN 'New Year''s Day'
                       WHEN CalMonth = 6  AND CalDay = 19 AND CalYear >= 2021 THEN 'Juneteenth'
                       WHEN CalMonth = 7  AND CalDay = 4  THEN 'Independence Day'
                       WHEN CalMonth = 11 AND CalDay = 11 THEN 'Veterans Day'
                       WHEN CalMonth = 12 AND CalDay = 25 THEN 'Christmas Day' END
WHERE (CalMonth = 1  AND CalDay = 1)
   OR (CalMonth = 6  AND CalDay = 19 AND CalYear >= 2021)
   OR (CalMonth = 7  AND CalDay = 4)
   OR (CalMonth = 11 AND CalDay = 11)
   OR (CalMonth = 12 AND CalDay = 25);
GO
