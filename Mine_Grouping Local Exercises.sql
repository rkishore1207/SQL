--Create a query listing out for each continent and country the number of events taking place therein:
SELECT CT.ContinentName,CY.CountryName,COUNT(E.EventID) AS [Events]
FROM tblContinent CT
INNER JOIN tblCountry CY ON CT.ContinentID = CY.ContinentID
INNER JOIN tblEvent E ON E.CountryID = CY.CountryID
GROUP BY CT.ContinentName,CY.CountryName
ORDER BY CY.CountryName

--Now change your query so that it omits events taking place in the continent of Europe:
SELECT CT.ContinentName,CY.CountryName,COUNT(E.EventID) AS [Events]
FROM tblContinent CT
INNER JOIN tblCountry CY ON CT.ContinentID = CY.ContinentID
INNER JOIN tblEvent E ON E.CountryID = CY.CountryID
GROUP BY CT.ContinentName,CY.CountryName
HAVING CT.ContinentName != 'Europe'
ORDER BY CY.CountryName

--Finally, change your query so that it only shows countries having 5 or more events:
SELECT CT.ContinentName,CY.CountryName,COUNT(E.EventID) AS [Events]
FROM tblContinent CT
INNER JOIN tblCountry CY ON CT.ContinentID = CY.ContinentID
INNER JOIN tblEvent E ON E.CountryID = CY.CountryID
GROUP BY CT.ContinentName,CY.CountryName
HAVING CT.ContinentName != 'Europe' AND COUNT(E.EventID) >= 5
ORDER BY CY.CountryName

--Statto(To find total Events and first and last date)
SELECT COUNT(*) AS TotalEvents, MIN(EventDate) As FirstDate, MAX(EventDate) AS LastDate
FROM tblEvent

--Create a query which shows two statistics for each category initial:
--The number of events for categories beginning with this letter; and
--The average length in characters of the event name for categories beginning with this letter.
WITH CategoryInitialLetter (Category, [Event], EventLength)
AS 
(
	SELECT UPPER(LEFT(CategoryName,1)) AS Category, 
		   E.EventID AS [Event], 
		   CAST(LEN(EventName) AS FLOAT) AS EventLength
	FROM tblCategory C
	INNER JOIN tblEvent E ON E.CategoryID = C.CategoryID
)

SELECT Category , 
	   COUNT([Event]) AS NumberOfEvents, 
	   FORMAT(AVG(EventLength),'0.00') AS AverageEventNameLength
FROM CategoryInitialLetter
GROUP BY Category
ORDER BY Category


--You'll need to calculate the century for each event date, and group by this.
WITH tblCentury AS (
	SELECT 
		(LEFT(YEAR(EventDate),2) + 1) AS Century, 
		COUNT(*) AS NumberOfEvents
	FROM 
		tblEvent
	GROUP BY 
		LEFT(YEAR(EventDate),2) WITH CUBE
)
SELECT 
	CASE
		WHEN RIGHT(Century,1) = 1 THEN CONCAT(Century,'st Century')
		WHEN RIGHT(Century,1) = 2 THEN CONCAT(Century,'nd Century')
		WHEN RIGHT(Century,1) = 3 THEN CONCAT(Century,'rd Century')
		WHEN Century IS NULL THEN 'Grand Total'
		ELSE CONCAT(Century,'th Century')
	END AS Century,
	NumberOfEvents
FROM 
	tblCentury