SELECT * FROM distributors;

SELECT * FROM rating;

SELECT * FROM revenue;

SELECT * FROM specs;

SELECT specs.movie_id, specs.film_title, specs.release_year
FROM specs
INNER JOIN revenue 
	ON specs.movie_id = revenue.movie_id;


SELECT 	specs.movie_id
	,	specs.film_title
	,	specs.release_year
	,	distributors.distributor_id
	,	distributors.company_name
FROM specs
	LEFT JOIN distributors
		ON domestic_distributor_id = distributor_id;

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT specs.film_title AS movie_name
	, specs.release_year
	, revenue.worldwide_gross
FROM specs
INNER JOIN revenue
	ON specs.movie_id  =  revenue.movie_id
ORDER BY revenue.worldwide_gross ASC
LIMIT 1;

-- Answer				Movie Name	Release_Year	Worldwide _gross
-- 						Semi-Tough	1977			37187139	







-- 2. What year has the highest average imdb rating?

SELECT specs.release_year
	, AVG(rating.imdb_rating) AS average_imbd_rating
FROM specs
JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY specs.release_year
ORDER BY average_imbd_rating DESC
LIMIT 1;

-- Answer			Year 1991 is the year with highest average imdb rating.







-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT specs.film_title
	, specs.mpaa_rating
	, revenue.worldwide_gross
	, distributors.company_name
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id = distributor_id
WHERE specs.mpaa_rating = 'G'
ORDER BY worldwide_gross DESC
LIMIT 1;

-- Answer			Toy Stor 4 is the highest grossing Grating movie distributed by Walt Disney







-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.


SELECT distributors.company_name
	, specs.film_title
FROM specs
FULL JOIN distributors
ON distributors.distributor_id = specs.domestic_distributor_id
ORDER BY distributors.company_name ASC,
	 specs.film_title ASC;




--5. Write a query that returns the five distributors with the highest average movie budget.

SELECT distributors.company_name
	, AVG(revenue.film_budget) AS avg_film_budget
FROM specs
LEFT JOIN revenue
ON specs.movie_id = revenue.movie_id
INNER JOIN distributors
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY company_name
ORDER BY avg_film_budget DESC
LIMIT 5;


--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT specs.film_title
	, rating.imdb_rating
	, distributors.headquarters
FROM Distributors
LEFT JOIN specs
ON specs.domestic_distributor_id = distributors.distributor_id
	INNER JOIN rating
	ON specs.movie_id = rating.movie_id
WHERE distributors.headquarters NOT ILIKE '%Ca';


--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?


SELECT 
	CASE
		WHEN length_in_min < 120 THEN 'under_2_hours'
		WHEN length_in_min > 120 THEN 'over_2_hours'
	END AS under_over_2_hours,
	ROUND (AVG(imdb_rating), 2)
FROM specs
INNER JOIN rating
USING (movie_id)
GROUP BY under_over_2_hours;



--2nd way
SELECT 
	CASE WHEN length_in_min >=0 AND length_in_min <=120 THEN 'Under 2 Hours' 
	ELSE 'Over 2 Hours'
	END AS length_range, 
	AVG(r.imdb_rating) as avg_rating
FROM specs as s
LEFT JOIN rating as r
USING(movie_id)
GROUP BY length_range
ORDER BY avg_rating DESC;







