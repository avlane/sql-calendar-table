USE CalendarDemo;
GO


-- Daily sales report that shows days with no sales as zero.
IF OBJECT_ID(N'dbo.DemoSales', N'U') IS NOT NULL DROP TABLE dbo.DemoSales;
CREATE TABLE dbo.DemoSales (SaleDate DATE NOT NULL, Amount DECIMAL(10,2) NOT NULL);
INSERT INTO dbo.DemoSales VALUES ('2020-12-01', 100), ('2020-12-01', 50), ('2020-12-03', 75), ('2020-12-07', 20);
GO

SELECT c.CalendarDate, c.DayName, ISNULL(SUM(s.Amount), 0) AS Total
FROM dbo.Calendar AS c
LEFT JOIN dbo.DemoSales AS s ON s.SaleDate = c.CalendarDate
WHERE c.CalendarDate BETWEEN '2020-12-01' AND '2020-12-07'
GROUP BY c.CalendarDate, c.DayName
ORDER BY c.CalendarDate;
