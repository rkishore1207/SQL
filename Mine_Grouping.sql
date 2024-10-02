--Write a query to list out for each author and doctor the number of episodes made, but restrict your output to show only the author/doctor combinations for which more than 5 episodes have been written.
SELECT A.AuthorName, D.DoctorName, COUNT(E.EpisodeId) AS Episodes
FROM tblAuthor A
INNER JOIN tblEpisode E ON E.AuthorId = A.AuthorId
INNER JOIN tblDoctor D ON D.DoctorId = E.DoctorId
GROUP BY A.AuthorName, D.DoctorName
HAVING COUNT(E.EpisodeId) > 5

-- Optimized
WITH AuthorDoctorEpisodes AS
(
	SELECT 
		A.AuthorName, 
		D.DoctorName, 
		COUNT(E.EpisodeId) OVER(PARTITION BY A.AuthorId, D.DoctorId) AS Episodes
	FROM 
		tblAuthor A
		INNER JOIN tblEpisode E ON E.AuthorId = A.AuthorId
		INNER JOIN tblDoctor D ON D.DoctorId = E.DoctorId
)
SELECT 
	DISTINCT AuthorName, 
			 DoctorName, 
			 Episodes
FROM 
	AuthorDoctorEpisodes
WHERE 
	Episodes > 5
ORDER BY 
	Episodes DESC

--Write a query to list out for each episode year and enemy the number of episodes made, but in addition:
--Only show episodes made by doctors born before 1970; and
--Omit rows where an enemy appeared in only one episode in a particular year.
SELECT 
	YEAR(EP.EpisodeDate) AS EpisodeYear, 
	EN.EnemyName, 
	COUNT(EP.EpisodeId) AS Episodes 
FROM 
	tblEpisode EP
	INNER JOIN tblEpisodeEnemy EE ON EE.EpisodeId = EP.EpisodeId
	INNER JOIN tblEnemy EN ON EN.EnemyId = EE.EnemyId
	INNER JOIN tblDoctor D ON D.DoctorId = EP.DoctorId
WHERE 
	YEAR(D.BirthDate) < 1970
GROUP BY 
	YEAR(EP.EpisodeDate), 
	EN.EnemyName
HAVING 
	COUNT(EP.EpisodeId) > 1