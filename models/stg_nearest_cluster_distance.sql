SELECT mr.id, 
    (SELECT AVG(EUCLIDEAN_DISTANCE(mr.embedding, br.embedding))
    FROM movies.movies m
    INNER JOIN movies.book_reviews br ON m.book_id = br.book_id
  WHERE mr.imdbid = m.imdbid
) AS nearest_cluster_distance
FROM movies.movie_reviews mr
WHERE mr.imdbid = 'tt0449010'
ORDER BY mr.id