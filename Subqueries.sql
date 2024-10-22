---------------------------------
SELECT 
	EventName, 
	EventDate, 
	CountryName
FROM 
	tblEvent E
INNER JOIN 
	tblCountry C ON C.CountryID = E.CountryID
WHERE 
	EventDate > (
		SELECT 
			TOP 1 EventDate 
		FROM 
			tblEvent 
		WHERE 
			CountryID = 21 
		ORDER BY 
			EventDate DESC
		)
ORDER BY 
	EventDate DESC
-------------------------------
SELECT 
	EventName 
FROM 
	tblEvent 
WHERE 
	LEN(EventName) > 
	(
		SELECT 
			AVG(TotalLength)
		FROM 
		(
			SELECT 
				LEN(EventName) AS TotalLength 
			FROM tblEvent
		) AS TotalLength
	)
--------------------------------
SELECT 
	C.CountryName 
FROM 
	tblCountry C
WHERE 
	(
		SELECT 
			COUNT(E.EventID) 
		FROM 
			tblEvent E 
		WHERE 
			E.CountryID = C.CountryID
	) > 8
ORDER BY 
	C.CountryName
-----------------------------------
SELECT 
	Tour_name, 
	Attendance, 
	(Attendance - ( SELECT 
						AVG(Attendance) AS AvgAttendance 
					FROM Tour)) AS Differences  
FROM 
	Tour
WHERE 
	Attendance > ( SELECT 
						AVG(Attendance) AS AvgAttendance 
				   FROM Tour)
ORDER BY 
	Attendance

-----------------------------

SELECT 
	Title, 
	Album_mins, 
	Album_secs, 
	(dbo.TotalLength(Album_mins, Album_secs) - (SELECT 
													AVG(dbo.TotalLength(Album_mins, Album_secs)) 
												 FROM Album)) AS LongerThanAverage
FROM 
	Album
WHERE 
	((dbo.TotalLength(Album_mins, Album_secs) - (SELECT 
													AVG(dbo.TotalLength(Album_mins, Album_secs)) 
												FROM Album)) BETWEEN 0 AND 60)
ORDER BY LongerThanAverage DESC

CREATE FUNCTION TotalLength(@Minutes INT, @Seconds INT)
RETURNS INT
AS
BEGIN
	RETURN (@Minutes * 60 + @Seconds)
END

-----------------
SELECT 
	EventName, 
	EventDetails 
FROM 
	tblEvent
WHERE 
	CountryID IN (  SELECT CountryID FROM tblCountry
					ORDER BY CountryName DESC
					OFFSET 30 ROWS) 
AND 
	CategoryID IN ( SELECT CategoryID FROM tblCategory
					ORDER BY CategoryName DESC
					OFFSET 15 ROWS)
ORDER BY 
	EventDate
------------------