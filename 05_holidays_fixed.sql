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


-- Floating holidays: the Nth weekday of a month. DayOfWeekNo is 1 = Monday ... 7 = Sunday.
-- Week-of-month index for a given weekday: (CalDay - 1) / 7 + 1
UPDATE dbo.Calendar SET IsHoliday = 1, HolidayName = 'Martin Luther King Jr. Day'
WHERE CalMonth = 1 AND DayOfWeekNo = 1 AND (CalDay - 1) / 7 + 1 = 3 AND CalYear >= 1986;

UPDATE dbo.Calendar SET IsHoliday = 1, HolidayName = 'Presidents'' Day'
WHERE CalMonth = 2 AND DayOfWeekNo = 1 AND (CalDay - 1) / 7 + 1 = 3;

-- Memorial Day: last Monday in May
UPDATE dbo.Calendar SET IsHoliday = 1, HolidayName = 'Memorial Day'
WHERE CalMonth = 5 AND DayOfWeekNo = 1 AND CalDay > 24;

UPDATE dbo.Calendar SET IsHoliday = 1, HolidayName = 'Labor Day'
WHERE CalMonth = 9 AND DayOfWeekNo = 1 AND CalDay <= 7;

UPDATE dbo.Calendar SET IsHoliday = 1, HolidayName = 'Columbus Day'
WHERE CalMonth = 10 AND DayOfWeekNo = 1 AND (CalDay - 1) / 7 + 1 = 2;

-- Thanksgiving: fourth Thursday of November
UPDATE dbo.Calendar SET IsHoliday = 1, HolidayName = 'Thanksgiving'
WHERE CalMonth = 11 AND DayOfWeekNo = 4 AND (CalDay - 1) / 7 + 1 = 4;
GO
