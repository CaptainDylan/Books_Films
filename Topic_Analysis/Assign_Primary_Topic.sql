-- Get top topic
select movie_review_topics.reviewid,
	movie_review_topics.topicid,
	movie_review_topics.topicprob
from movie_review_topics 
inner join (
select reviewid, max(topicprob) as maxprob
from movie_review_topics 
group by reviewid) AS MaxTopic
ON movie_review_topics.topicprob = MaxTopic.maxprob
order by movie_review_topics.reviewid limit 99;

ALTER TABLE movie_reviews ADD primary_topic_id smallint NULL;
ALTER TABLE movie_reviews ADD primary_topic_prob double NULL;
-- select * from movie_review_topics where reviewid = 15;
-- to reset:
-- UPDATE movie_reviews
-- SET primary_topic_id = NULL,
--    primary_topic_prob = NULL;

-- Update review with primary topic
UPDATE movie_reviews
INNER JOIN (
select movie_review_topics.reviewid,
	movie_review_topics.topicid,
	movie_review_topics.topicprob
from movie_review_topics 
inner join (
select reviewid, max(topicprob) as maxprob
from movie_review_topics 
group by reviewid) AS MaxTopic
ON movie_review_topics.reviewid = MaxTopic.reviewid
  AND movie_review_topics.topicprob = MaxTopic.maxprob
) AS TopTopic
ON movie_reviews.id = TopTopic.reviewid
SET primary_topic_id = TopTopic.topicid,
    primary_topic_prob = TopTopic.topicprob;

-- Get distribution of main topics for reviews:

SELECT primary_topic_id, count(*)
FROM movie_reviews
GROUP BY primary_topic_id
ORDER BY primary_topic_id;

select * from movie_reviews limit 99;

select * from movie_reviews where primary_topic_id = 28;

select rating, count(*)
from movie_reviews where primary_topic_id = 28
group by rating order by rating;

select primary_topic_id, avg(rating) as avgrating, count(*) as cnt
from movie_reviews
WHERE primary_topic_id is not null
group by primary_topic_id
order by primary_topic_id;

-- Comparison of Topic 28 vs non-Topic 28 and avg rating
select case when primary_topic_id = 0 then 'Books' else 'Not Books' end, 
avg(rating) as avgrating, count(*) as cnt
from movie_reviews
WHERE primary_topic_id is not null
group by case when primary_topic_id = 0 then 'Books' else 'Not Books' end
order by case when primary_topic_id = 0 then 'Books' else 'Not Books' end;

select cast(rating as unsigned), ifnull(topicprob,0) as topicprob
 from movie_reviews mr
left join movie_review_topics mrt 
on mr.id = mrt.reviewid
    and mrt.topicid = 0
where rating != '?';

select rating, avg(topicprob) as topicprob, count(*)
 from movie_reviews mr
inner join movie_review_topics mrt 
on mr.id = mrt.reviewid
    and mrt.topicid = 0
where rating != '?'
group by rating;

select count(*)
 from movie_reviews mr
inner join movie_review_topics mrt 
on mr.id = mrt.reviewid
    and mrt.topicid = 28
where rating != '?'

#SET SESSION group_concat_max_len = 1024;

CREATE TABLE movie_topic_descriptions
AS
select Topic, 
  group_concat(Word ORDER BY Prob DESC SEPARATOR ',') AS TopicDesc
from movie_topics t
group by Topic;

ALTER TABLE movie_topic_descriptions ADD ShortDesc varchar(100) NULL;

UPDATE movie_topic_descriptions
INNER JOIN
(select Topic, 
  group_concat(Word ORDER BY Prob DESC SEPARATOR ',') AS NewDesc
from movie_topics t
where t.WordOrder <= 3
group by Topic) AS t2
ON movie_topic_descriptions.topic = t2.topic
 SET ShortDesc = t2.NewDesc;

select * from movie_topic_descriptions;

#### Do update for book reviews:
ALTER TABLE book_reviews ADD primary_topic_id smallint NULL;
ALTER TABLE book_reviews ADD primary_topic_prob double NULL;

UPDATE book_reviews
INNER JOIN (
select book_review_topics.reviewid,
	book_review_topics.topicid,
	book_review_topics.topicprob
from book_review_topics 
inner join (
select reviewid, max(topicprob) as maxprob
from book_review_topics 
group by reviewid) AS MaxTopic
ON book_review_topics.topicprob = MaxTopic.maxprob
) AS TopTopic
ON book_reviews.id = TopTopic.reviewid
SET primary_topic_id = TopTopic.topicid,
    primary_topic_prob = TopTopic.topicprob;


CREATE TABLE book_topic_descriptions
AS
select Topic, 
  group_concat(Word ORDER BY Prob DESC SEPARATOR ',') AS TopicDesc
from book_topics t
group by Topic;

ALTER TABLE book_topic_descriptions ADD ShortDesc varchar(100) NULL;

UPDATE book_topic_descriptions
INNER JOIN
(select Topic, 
  group_concat(Word ORDER BY Prob DESC SEPARATOR ',') AS NewDesc
from book_topics t
where t.WordOrder <= 3
group by Topic) AS t2
ON book_topic_descriptions.topic = t2.topic
 SET ShortDesc = t2.NewDesc;

select * from book_topic_descriptions;
