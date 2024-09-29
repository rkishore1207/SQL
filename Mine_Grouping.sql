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
	SELECT A.AuthorName, D.DoctorName, COUNT(E.EpisodeId) OVER(PARTITION BY A.AuthorId, D.DoctorId) AS Episodes
	FROM tblAuthor A
	INNER JOIN tblEpisode E ON E.AuthorId = A.AuthorId
	INNER JOIN tblDoctor D ON D.DoctorId = E.DoctorId
)
SELECT DISTINCT AuthorName, DoctorName, Episodes
FROM AuthorDoctorEpisodes
WHERE Episodes > 5
ORDER BY Episodes DESC