--Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
    show_id	VARCHAR(10),
	type VARCHAR(10),	
	title	VARCHAR(150),
	director	VARCHAR(208),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year INT,	
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*) FROM netflix;

-- 15 business problems
-- 1. count the number of movies vs tv shows

SELECT 
    type,
	count(*) AS total_content
FROM netflix
GROUP BY type;

-- 2. find the most common rating for the movies and tv shows 
SELECT 
   type,
   rating
FROM
(
  SELECT 
     type,
     rating,
     COUNT(*),
     RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
  FROM netflix
  GROUP BY type, rating --ORDER BY type, COUNT(*) DESC
) t1
WHERE ranking = 1;

-- 3. list all the movies released in the year 2020

SELECT type, title, release_year from netflix
where type = 'Movie' AND release_year = 2020;

-- 4. find the top 5 countries with the most netflix content

SELECT 
   Trim(UNNEST(STRING_TO_ARRAY(country, ',')))as new_country,
   count(show_id) AS total_content
FROM netflix
group by 1
ORDER BY 2 desc
LIMIT 5;

--SELECT UNNEST(STRING_TO_ARRAY(country, ','))as new_country from netflix;

-- 5. identify the largest movie

SELECT * FROM netflix
WHERE type = 'Movie'
      AND 
	  Duration = (SELECT MAX(duration)from Netflix);


-- 6. find everything that released in the last 5 years

SELECT *	
FROM netflix
where 
   TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';



-- 7. find all the names of movies and tv shows by director called ' Rajiv Chilaka'
 SELECT * FROM netflix
 WHERE director LIKE '%Rajiv Chilaka%';

 
-- 8. list all tv shows which have more than 5 seasons
(--SELECT 
    * 
FROM netflix
WHERE 
    type = 'Tv Show'
    AND 
    SPLIT_PART(duration,' ',1 )::numeric > 5)

-- select SPLIT_PART('Apple, Banana, Cherry', ' ', 1) use this funtion when you need specific word



-- 9. count the number of content itrems in each genre
SELECT 
    COUNT(show_id) AS total_content, 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
from netflix
GROUP BY genre
Order by total_content desc;


-- 10. find each year and the avg year of content release by india on netflix,  
-- return top 5 year with highest avg content release.


SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as year,
    Count(*) as yearly_content,
	Round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric * 100, 2 )as avg_content_per_year
FROM netflix
where country = 'India'
GROUP BY 1;

-- 11. List all the movies those are documentaries

SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%'


-- 12. find all the content without director
SELECT * from netflix
WHERE director is null;

(-- 13. find how many movies actor 'salman khan' appeared last 10 years
SELECT * FROM netflix
WHERE 
    casts ILIKE '%Salman Khan%' 
    AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10)


-- 14. find the top 10 actors who have appeared in the highest number of movies produced in india

SELECT
   UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
   count(*) as total_content
from netflix
WHERE country ILIKE '%India%'
Group by actors
ORDER BY total_content DESC
LIMIT 10;


-- 15. CATEGORIES the content based on the presence of the keywords'kill' and 'violence' in the description
-- field. label containig these words as bad and all other good. count how many category fall into each.

With new_table
AS
(
SELECT 
    *,
	Case WHEN 
	       description ILIKE '%Kill%' OR  
	       description ILIKE '%Violence%' THEN 'Bad_content'
           Else 'Good_content'
		 End category
FROM netflix
)
SELECT 
   category,
   Count(*) as total_content
FROM new_table
GROUP BY category




WHERE description ILIKE '%Kill%' OR description ILIKE '%Violence%'
























