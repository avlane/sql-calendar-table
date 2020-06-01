# sql-calendar-table

A date dimension (calendar) table for SQL Server, built with set-based T-SQL. Handy for reports that need every date, gap filling, business-day math and fiscal periods.

Works on SQL Server 2016 and later. A SQL Server 2022 variant using `GENERATE_SERIES` is added in a later commit and the recursive CTE version stays.

## Files

- `01_create_calendar.sql` creates the `CalendarDemo` database and the `dbo.Calendar` table.
- `02_populate_recursive.sql` loads 2000 to 2049 with a recursive CTE.
- `03_names_and_quarters.sql` adds names, quarter and month boundaries.
