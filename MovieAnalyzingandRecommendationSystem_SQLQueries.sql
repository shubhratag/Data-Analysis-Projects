/*-------Creating a view on movie table to extract the title and release year into separate columns. 
This will be used for the queries utilizing year.-----*/

CREATE VIEW movie_view (movieId, movie_title, release_year, genres) AS 
SELECT movieId, SUBSTRING(title, 1, CHAR_LENGTH(TRIM(title))-6), CAST(SUBSTRING(title, CHAR_LENGTH(TRIM(title))-4, 4) as unsigned), genres
FROM movies;

/*-------Creating a view on movie view to limit the data for query 4 as it would run into timeout and considered a good practice.-----*/

CREATE VIEW movie_tags AS
select DISTINCT m.release_year, m.movie_title,t.tag, r.rating, g.relevance AS m_relevance
from movie_view m 
join genome_scores g 
on m.movieId=g.movieId 
join genome_tags t
on t.tagId=g.tagId 
join ratings r 
on r.movieId=m.movieId 
where r.rating=5 AND m.release_year IN (1930,1931);

/*Question1*/
/*----What are the three least favourite genres?----*/ 

use group6;
WITH movie_cte AS (
Select genres,count(movieId) 
from movies 
group by genres
order by count(movieId))
SELECT *
FROM movie_cte
LIMIT 3;

/*Question2*/
/*----How are the movie trends changing every 20 years? (Most popular genres every 20-year starting from 1930)----*/ 

use group6;
with movie_cte as(
(select "1930-1949" as Year,m.genres as Genre,count(distinct m.movieId) as Count_of_Movies_released 
from movies m
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 1930 and 1949 
group by v.release_year,m.genres 
order by count(distinct m.movieId) desc 
limit 5)
union
(select "1950-1969" as Year,m.genres as Genre,count(distinct m.movieId) as Count_of_Movies_released 
from movies m
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 1950 and 1969 
group by v.release_year,m.genres 
order by count(distinct m.movieId) desc 
limit 5)
union
(select "1970-1989" as Year,m.genres as Genre,count(distinct m.movieId) as Count_of_Movies_released 
from movies m
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 1970 and 1989 
group by v.release_year,m.genres 
order by count(distinct m.movieId) desc 
limit 5)
union
(select "1990-2009" as Year,m.genres as Genre,count(distinct m.movieId) as Count_of_Movies_released 
from movies m
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 1990 and 2009 
group by v.release_year,m.genres 
order by count(distinct m.movieId) desc 
limit 5)
union
(select "2010-2021" as Year,m.genres as Genre,count(distinct m.movieId) as Count_of_Movies_released 
from movies m
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 2010 and 2021 
group by v.release_year,m.genres  
order by count(distinct m.movieId) desc 
limit 5))
select Year, Genre, SUM(Count_of_Movies_released) 
from movie_cte 
group by Year;

/*Question3*/
/*----What is the spread of audience ratings across various genres?----*/

use group6;

Select movies.genres,avg(ratings.rating) 
from movies 
join ratings 
on movies.movieId=ratings.movieId 
group by movies.genres;

/*Question4*/
/*----4.	In the year 1930 and 1931, out of the top-rated movies (with 5-star ratings) 
which tag is the most relevant to the title? #These two years are selected but user can select any other years as desired----*/

SELECT *
FROM
(select m.*,
dense_rank() over (partition by m.release_year,m.movie_title order by m_relevance desc) AS Relevance_Rank
from movie_tags m) AS x
WHERE Relevance_Rank = 1;

/*Question5*/
/*----What is the number of tags assigned to a movie?(Limiting the data to 10)----*/

use group6;

Select movies.title,count(genome_scores.tagId) AS "Number Of Tags"
from movies 
join genome_scores 
on movies.movieId=genome_scores.movieId 
group by movies.title 
order by count(genome_scores.tagId) desc
limit 10;

/*Question6*/
/*----What are the top 10 genres of movies that have the highest average ratings?----*/

use group6;

Select movies.genres,avg(ratings.rating) 
from movies 
join ratings 
on movies.movieId=ratings.movieId 
group by movies.genres 
order by avg(ratings.rating) desc 
limit 10;

/*Question7*/
/*----List the top rated movies of each genre.----*/

use group6; 

SELECT m.genres, m.title, r.rating
FROM movies AS m 
JOIN ratings AS r
ON m.movieId=r.movieId
WHERE r.rating=5
GROUP BY m.genres, m.title
ORDER BY m.genres desc;

/*Question8*/
/*----What is the number of movies releasing every 3-years starting 2000?----*/

use group6;
with cte as(
select "2000-2002" as Year,count(distinct m.movieId) as Count_of_Movies_released 
from movies m 
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 2000 and 2002 
group by v.release_year  
union
select "2003-2005",count(distinct m.movieId) 
from movies m 
join movie_view v 
on m.movieId=v.movieId
where v.release_year between 2003 and 2005 
group by v.release_year  
union
select "2006-2008",count(distinct m.movieId) 
from movies m 
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 2006 and 2008 
group by v.release_year  
union
select "2009-2011",count(distinct m.movieId) 
from movies m 
join movie_view v on m.movieId=v.movieId 
where v.release_year between 2009 and 2011 
group by v.release_year  
union
select "2012-2014",count(distinct m.movieId) 
from movies m 
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 2012 and 2014 
group by v.release_year
union
select "2015-2017",count(distinct m.movieId) 
from movies m 
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 2015 and 2017 
group by v.release_year
union
select "2018-2020",count(distinct m.movieId) 
from movies m 
join movie_view v on m.movieId=v.movieId 
where v.release_year between 2018 and 2020 
group by v.release_year
union
select "2021-2022",count(distinct m.movieId) 
from movies m 
join movie_view v 
on m.movieId=v.movieId 
where v.release_year between 2021 and 2022 
group by v.release_year)
select Year,sum(Count_of_Movies_released) as Number_of_movies_released 
from cte 
group by Year;

/*Question9*/
/*----Count of movies in each genre?----*/

use group6;
Select genres,count(movieId) As "Number Of Movies"
from movies 
group by genres
order by count(movieId) desc;

/*Question10*/
/*----Which users have given the most relevant tags?----*/

use group6;

SELECT t.userId, avg(g.relevance) AS "Average Relevance", COUNT(g.movieId) AS "Movies Tagged Relevantly"
FROM tags AS t
INNER JOIN movies AS m
ON t.movieId=m.movieId
JOIN genome_scores as g
ON m.movieId=g.movieId
WHERE g.relevance>0.80 
GROUP BY t.userId
HAVING COUNT(g.movieId)>400
ORDER BY avg(g.relevance) DESC;



