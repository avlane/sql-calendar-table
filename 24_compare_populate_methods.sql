USE CalendarDemo;
GO


-- Loads the table both ways and compares the elapsed time. SQLCMD mode (:r); SQL Server 2022 only.
-- Timings go through a temp table because variables do not survive the GO inside the included files.
CREATE TABLE #timing (step VARCHAR(30) NOT NULL, at_time DATETIME2(3) NOT NULL);
INSERT INTO #timing VALUES ('start', SYSDATETIME());
GO
:r 02_populate_recursive.sql
INSERT INTO #timing VALUES ('recursive done', SYSDATETIME());
GO
:r 22_populate_generate_series.sql
INSERT INTO #timing VALUES ('generate_series done', SYSDATETIME());
GO

SELECT step, DATEDIFF(MILLISECOND, LAG(at_time) OVER (ORDER BY at_time), at_time) AS elapsed_ms
FROM #timing
ORDER BY at_time;
