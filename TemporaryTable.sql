
CREATE TABLE #EventsCount(
	Letter NVARCHAR(2) NULL,
	[Count] int NULL
)

INSERT INTO #EventsCount
	SELECT LEFT(EventName,1), COUNT(*) FROM tblEvent
	GROUP BY LEFT(EventName,1)

SELECT * FROM #EventsCount

INSERT INTO #EventsCount VALUES ('xz',57)

IF (OBJECT_ID('tempdb.dbo.#EventsCount','U') IS NOT NULL)
	DROP TABLE #EventsCount

SELECT OBJECT_ID('tempdb.dbo.#EventsCount','U') AS ObjectName

SELECT * FROM tblEvent

IF (OBJECT_ID('tempdb.dbo.#CountryWithEvents','U') IS NOT NULL)
	DROP TABLE #CountryWithEvents

CREATE 
	TABLE #CountryWithEvents
	(
		[Year] VARCHAR(4) NULL,
		[CountryId] int NOT NULL,
		EventsCount int NOT NULL
	)

DECLARE 
	@LeastYear INT = (SELECT MIN(YEAR(EventDate)) FROM tblEvent) ,
	@HighestYear INT = (SELECT MAX(YEAR(EventDate)) FROM tblEvent)

WHILE 
	(@LeastYear <= @HighestYear)
BEGIN
	INSERT 
		INTO #CountryWithEvents
	SELECT 
		TOP 1 
		YEAR(EventDate) AS Years, 
		CountryID, COUNT(*) AS EventsCount  
	FROM 
		tblEvent
	WHERE 
		YEAR(EventDate) = @LeastYear
	GROUP BY 
		YEAR(EventDate), CountryID
	ORDER BY 
		EventsCount DESC

	SET 
		@LeastYear += 1
END


SELECT 
	E.[Year] AS EventYear, 
	C.CountryName, 
	E.EventsCount 
FROM 
	#CountryWithEvents E
INNER JOIN 
	tblCountry C ON E.CountryId = C.CountryID