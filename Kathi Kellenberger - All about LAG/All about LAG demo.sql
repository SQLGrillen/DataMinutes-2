/*
All about LAG examples

*/
--DEMO 1
USE Demo;
GO
SELECT *
FROM StockHistory
WHERE TradeDate BETWEEN '2017-01-03' AND '2017-01-05' 
	AND TickerSymbol BETWEEN 'Z1' AND 'Z5'
ORDER BY TickerSymbol,
         TradeDate;

--Using window functions
SELECT TickerSymbol,
       TradeDate,
       ClosePrice,
       LAG(ClosePrice) OVER (PARTITION BY TickerSymbol ORDER BY TradeDate) AS LastPrice,
       ClosePrice - LAG(ClosePrice) OVER (PARTITION BY TickerSymbol ORDER BY TradeDate) AS Diff
FROM StockHistory
WHERE TradeDate BETWEEN '2017-01-03' AND '2017-01-10'
ORDER BY TickerSymbol,
         TradeDate;


--DEMO 2
--Days between  customer orders
SELECT TOP(20)  soh.SalesOrderID, soh.CustomerID, soh.OrderDate 
FROM AdventureWorks2019.Sales.SalesOrderHeader AS soh
ORDER BY CustomerID;

SELECT soh.SalesOrderID, soh.CustomerID, soh.OrderDate,
	LAG(OrderDate) OVER	(PARTITION BY CustomerID ORDER BY soh.OrderDate) AS PrevOrder,
	DATEDIFF(DAY,LAG(OrderDate) OVER(PARTITION BY soh.CustomerID ORDER BY soh.OrderDate),soh.OrderDate) AS DaysBetweenOrders
FROM AdventureWorks2019.Sales.SalesOrderHeader AS soh 
ORDER BY soh.CustomerID, soh.OrderDate;

--Average days between customer orders
WITH DaysBetweenOrders AS (
	SELECT soh.SalesOrderID, soh.CustomerID, soh.OrderDate,
		LAG(OrderDate) OVER	(PARTITION BY CustomerID ORDER BY soh.OrderDate) AS PrevOrder,
		DATEDIFF(DAY,LAG(OrderDate) OVER(PARTITION BY soh.CustomerID ORDER BY soh.OrderDate),soh.OrderDate) AS DaysBetweenOrders
	FROM AdventureWorks2019.Sales.SalesOrderHeader AS soh 
)
SELECT DBO.SalesOrderID, DBO.CustomerID, DBO.OrderDate, DBO.DaysBetweenOrders, 
	AVG(DBO.DaysBetweenOrders) OVER(PARTITION BY DBO.CustomerID) AS AvgDaysBetweenOrders
FROM DaysBetweenOrders AS DBO;


--Subset of the StockHistory Table
SELECT * FROM vw_SmallHistory
ORDER BY TickerSymbol, TradeDate;



--LEAD
SELECT TickerSymbol, TradeDate, ClosePrice, 
	LEAD(ClosePrice) OVER(PARTITION BY TickerSymbol ORDER BY TradeDate) AS LEADExample
FROM vw_smallHistory 
ORDER BY TickerSymbol, TradeDate;

--eliminate nulls with default value
SELECT TickerSymbol, TradeDate, ClosePrice, 
	LAG(ClosePrice,1,0) OVER(PARTITION BY TickerSymbol ORDER BY TradeDate) AS DefaultValue
FROM vw_smallHistory
ORDER BY TickerSymbol, TradeDate;

--OFFSET
SELECT TickerSymbol, TradeDate, ClosePrice, 
	LAG(ClosePrice,2) OVER(PARTITION BY TickerSymbol ORDER BY TradeDate) AS Back2Days
FROM vw_smallHistory
ORDER BY TickerSymbol, TradeDate;







