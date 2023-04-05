--our first query
SELECT *
FROM dbo.Customers AS c;
GO 20

--retrieving the plan from QS
SELECT CAST(qsp.query_plan AS XML)
FROM sys.query_store_query AS qsq
    JOIN sys.query_store_query_text AS qsqt
        ON qsqt.query_text_id = qsq.query_text_id
    JOIN sys.query_store_plan AS qsp
        ON qsq.query_id = qsp.query_id
WHERE qsqt.query_sql_text = 'SELECT *
FROM dbo.Customers AS c';

--change the table
ALTER TABLE dbo.Customers
ADD TestingSelectStar VARCHAR(50) NULL;


--recompile the proc
DECLARE @PlanHandle VARBINARY(64);

SELECT  @PlanHandle = deqs.plan_handle
FROM    sys.dm_exec_query_stats AS deqs
CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
WHERE dest.text = 'SELECT *
FROM dbo.Customers AS c;'

IF @PlanHandle IS NOT NULL
    BEGIN
        DBCC FREEPROCCACHE(@PlanHandle);
    END
GO


DBCC FREEPROCCACHE()

--next query
SELECT *
FROM dbo.Orders AS o
WHERE o.CustomerID = 'WARTH'
      AND o.EmployeeID = 2;
GO 50

--pulling it from cache
SELECT CAST(qsp.query_plan AS XML)
FROM sys.query_store_query AS qsq
    JOIN sys.query_store_query_text AS qsqt
        ON qsqt.query_text_id = qsq.query_text_id
    JOIN sys.query_store_plan AS qsp
        ON qsq.query_id = qsp.query_id
WHERE qsqt.query_sql_text LIKE 'SELECT *
FROM dbo.Orders AS o
WHERE o.CustomerID = ''WARTH''
      AND o.EmployeeID = 2';


--really altering the table
ALTER TABLE dbo.Orders
ADD UniqueColumn VARCHAR(20) NULL CONSTRAINT UniqueColumnConstraint
                                  DEFAULT 'Hmmm...',
    NotherColumn INT NULL,
    OneMore INT CONSTRAINT OneMoreDefault
                DEFAULT 42;