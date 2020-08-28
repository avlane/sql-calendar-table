USE CalendarDemo;
GO


-- Expect 2021: 11 observed weekdays in the US federal schedule (Juneteenth added in 2021).
SELECT CalYear, COUNT(*) AS holidays
FROM dbo.Calendar
WHERE IsHoliday = 1
GROUP BY CalYear
HAVING CalYear IN (2020, 2021, 2022)
ORDER BY CalYear;

SELECT CalendarDate, DayName, HolidayName
FROM dbo.Calendar
WHERE CalYear = 2020 AND IsHoliday = 1
ORDER BY CalendarDate;
