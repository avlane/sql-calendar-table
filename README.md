# sql-calendar-table

A date dimension (calendar) table for SQL Server, built with set-based T-SQL. Handy for reports that need every date, gap filling, business-day math and fiscal periods.

Works on SQL Server 2016 and later. Scripts numbered 22 and up are variants for SQL Server 2022 that use `GENERATE_SERIES` and `DATETRUNC`; the recursive CTE version is kept for older servers.

## Which script do I run

| Server | Populate with | Then |
|---|---|---|
| SQL Server 2016 to 2019 | `02_populate_recursive.sql` | `03_names_and_quarters.sql` |
| SQL Server 2022+ | `22_populate_generate_series.sql` | `23_names_dateTrunc.sql` |

After either path run `04_iso_week_fiscal.sql`, `05_holidays_fixed.sql`, `07_business_days.sql`, `08_views_and_indexes.sql` and `09_easter.sql`. `01_create_calendar.sql` always comes first.

`24_compare_populate_methods.sql` times both methods (SQLCMD mode, 2022 only). Roughly: the recursive CTE loads 18,263 rows in about 400 ms on a laptop; `GENERATE_SERIES` is closer to 100 ms.

## Files

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
