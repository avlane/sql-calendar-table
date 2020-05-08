IF DB_ID(N'CalendarDemo') IS NULL
    CREATE DATABASE CalendarDemo;
GO
USE CalendarDemo;
GO

DROP TABLE IF EXISTS dbo.Calendar;
GO

CREATE TABLE dbo.Calendar
(
    CalendarDate DATE     NOT NULL CONSTRAINT PK_Calendar PRIMARY KEY CLUSTERED,
    CalYear      SMALLINT NOT NULL,
    CalMonth     TINYINT  NOT NULL,
    CalDay       TINYINT  NOT NULL,
    DayOfWeekNo  TINYINT  NOT NULL   -- 1 = Monday ... 7 = Sunday, independent of SET DATEFIRST
);
GO
