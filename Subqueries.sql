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