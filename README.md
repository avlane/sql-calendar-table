# sql-calendar-table

A date dimension (calendar) table for SQL Server, built with set-based T-SQL. Handy for reports that need every date, gap filling, business-day math and fiscal periods.

Works on SQL Server 2016 and later. A SQL Server 2022 variant using `GENERATE_SERIES` is added in a later commit and the recursive CTE version stays.

## Files

- `01_create_calendar.sql` creates the `CalendarDemo` database and the `dbo.Calendar` table.
- `02_populate_recursive.sql` loads 2000 to 2049 with a recursive CTE.
- `03_names_and_quarters.sql` adds names, quarter and month boundaries.
- `04_iso_week_fiscal.sql`, `05_holidays_fixed.sql`, `09_easter.sql` add week, fiscal and holiday columns.
- `07_business_days.sql` has `fn_AddBusinessDays`.
- `10_example_gap_fill.sql` shows the table used to fill gaps in a report.

## Sample output

```
CalendarDate  DayName    Total
------------  ---------  ------
2020-12-01    Tuesday    150.00
2020-12-02    Wednesday  0.00
2020-12-03    Thursday   75.00
2020-12-04    Friday     0.00
2020-12-05    Saturday   0.00
2020-12-06    Sunday     0.00
2020-12-07    Monday     20.00
```
