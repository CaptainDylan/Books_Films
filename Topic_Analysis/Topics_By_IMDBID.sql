
select imdbid, 
  group_concat(cleaned ORDER BY review_seq SEPARATOR ' ') AS MovieDesc
from movie_review_TopA_xT
group by imdbid
limit 99;


CREATE TABLE `movie_topics_by_imdb` (
  `imdbid` varchar(10) COLLATE utf8_unicode_ci,
  `topicid` int(10) DEFAULT NULL,
  `topicprob` double DEFAULT NULL,
  KEY `ix_reviews_movie_topics_by_imdb_topicid` (`topicid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

select * from movie_topics_by_imdb limit 99;
