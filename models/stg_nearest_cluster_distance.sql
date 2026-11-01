SELECT mr.imdbid, mr.id, 
    (SELECT AVG(EUCLIDEAN_DISTANCE(mr.embedding, br.embedding))
    FROM movies.movies m
    INNER JOIN movies.book_reviews br ON m.book_id = br.book_id
  WHERE mr.imdbid = m.imdbid
) AS nearest_cluster_distance
FROM movies.movie_reviews mr
WHERE mr.imdbid IN ('tt0449010','tt0185183','tt0100240','tt1192620')
ORDER BY mr.id