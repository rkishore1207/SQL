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