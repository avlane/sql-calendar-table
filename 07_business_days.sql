USE CalendarDemo;
GO


DROP FUNCTION IF EXISTS dbo.fn_AddBusinessDays;
GO

-- Returns the date that is @Days business days after @From (negative moves back).
-- A business day is a weekday that is not an observed holiday.
CREATE FUNCTION dbo.fn_AddBusinessDays (@From DATE, @Days INT)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE;

    IF @Days >= 0
        SELECT @Result = MAX(CalendarDate)
        FROM (SELECT TOP (@Days) CalendarDate
              FROM dbo.Calendar
              WHERE CalendarDate > @From AND IsWeekend = 0 AND IsHolidayObserved = 0
              ORDER BY CalendarDate) AS x;
    ELSE
        SELECT @Result = MIN(CalendarDate)
        FROM (SELECT TOP (-@Days) CalendarDate
              FROM dbo.Calendar
              WHERE CalendarDate < @From AND IsWeekend = 0 AND IsHolidayObserved = 0
              ORDER BY CalendarDate DESC) AS x;

    RETURN ISNULL(@Result, @From);
END
GO

-- 2020-12-23 plus 3 business days skips Christmas (Fri 12-25) and the weekend: Mon 12-28.
SELECT dbo.fn_AddBusinessDays('2020-12-23', 3) AS due_date;
