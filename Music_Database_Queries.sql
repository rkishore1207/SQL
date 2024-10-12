-----------------------
SELECT 
	AR.Artist, 
	COUNT(AL.Album_ID) AS Albums, 
	FORMAT(SUM([US_sales_(m)]),'0.00') AS UsSales, 
	FORMAT(AVG([US_sales_(m)]),'0.00') AS AvgUsSales
FROM
	Album AL 
	INNER JOIN Artist AR ON AR.Artist_ID = AL.Artist_ID
WHERE 
	AL.US_Billboard_200_peak = 1
GROUP BY 
	Artist
HAVING 
	AVG([US_sales_(m)]) > 10
ORDER BY 
	COUNT(AL.Album_ID) DESC


--------------------
SELECT 
	CON.Continent,
	CO.Country,
	C.City,
	V.Venue,
	COUNT(Show_ID) AS NumberOfShows, 
	SUM(S.Tickets_sold) AS TotalTicketsSold, 
	FORMAT(
		AVG(
			CAST(S.Revenue_$ AS FLOAT) 
		),
		'0.00'
	) AS AverageRevenue
FROM 
	Venue V 
	INNER JOIN Show S ON S.Venue_ID = V.Venue_ID
	INNER JOIN City C ON C.City_ID = V.City_ID
	INNER JOIN Country CO ON CO.Country_ID = C.Country_ID
	INNER JOIN Continent CON On CON.Continent_ID = CO.Continent_ID
GROUP BY 
	Continent,
	Country,
	City,
	Venue
ORDER BY 
	COUNT(Show_ID) DESC


-----------------------
SELECT 
	RL.Record_label,
	COUNT(AL.Album_ID) AS Albums,
	FORMAT(
		AVG(
			CAST(AL.[US_sales_(m)] AS FLOAT)
		),
		'0.00'
	) AS AverageSales
FROM 
	Record_Label RL 
	INNER JOIN Album AL ON AL.Record_label_ID = RL.Record_label_ID
GROUP BY RL.Record_label

----------

ALTER FUNCTION fnFirstLineOfAddress
(
	@Address NVARCHAR(MAX)
)
RETURNS 
	NVARCHAR(MAX)
BEGIN
	DECLARE 
		@FirstLine NVARCHAR(MAX)
	SELECT 
		@FirstLine = value 
	FROM 
		STRING_SPLIT(@Address,',')
	RETURN 
		@FirstLine
END

CREATE FUNCTION fnNumberOfOtherNames
(
	@Names NVARCHAR(MAX)
)
RETURNS 
	INT
BEGIN
	DECLARE 
		@Count INT
	SELECT 
		@Count = COUNT(value )
	FROM 
		STRING_SPLIT(@Names, ';')
	RETURN 
		@Count
END

SELECT 
	Venue,
	[Address],
	dbo.fnFirstLineOfAddress([Address]) AS AddressLine_1,
	Other_names,
	dbo.fnNumberOfOtherNames(Other_names) AS [Count]
FROM 
	Venue

-------------