WITH SCORES AS
(
    SELECT imdbid, AVG(silhouette_score.silhouette_score) AS silhouette_score
    FROM {{ref('silhouette_score')}}
    GROUP BY imdbid
)
SELECT SCORES.imdbid, SCORES.silhouette_score, M.title
FROM SCORES
INNER JOIN Movies.Movies M
ON SCORES.imdbid = M.imdbid