SELECT mr.imdbid, mr.id, 
    (SELECT AVG(EUCLIDEAN_DISTANCE(mr.embedding, mr2.embedding))
    FROM movies.movie_reviews mr2
  WHERE mr.imdbid = mr2.imdbid AND mr.id != mr2.id
) AS intra_cluster_distance
FROM movies.movie_reviews mr
WHERE mr.imdbid IN (SELECT imdbid FROM movies.movie_silhouette_score)
ORDER BY mr.id