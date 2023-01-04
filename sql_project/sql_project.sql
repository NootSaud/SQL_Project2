/*Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out?*/

 SELECT title AS film_title, name AS category_name, COUNT(r.rental_id) 
 AS rental_count
 FROM film_category
 JOIN film ON film.film_id= film_category.film_id
 JOIN category ON  category.category_id=film_category.category_id
 JOIN inventory ON inventory.film_id = film.film_id
 JOIN rental r ON r.inventory_id = inventory.inventory_id
 GROUP BY 1,2
 ORDER BY 3 DESC;

/*Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into*/

SELECT film_title, category_name, rental_duration, standard_quartile
FROM
	(SELECT film.title AS film_title,category.name AS category_name, film.rental_duration,
 	 NTILE(4) OVER (PARTITION BY category.name ORDER BY film.rental_duration) AS standard_quartile
	FROM film_category
	JOIN film ON film.film_id= film_category.film_id
   	JOIN category ON  category.category_id=film_category.category_id
 	 )sub
GROUP BY 4,2,1,3
ORDER BY 4;



/*Provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies 
within each combination of film category for each corresponding rental duration category?*/

SELECT name, standard_quartile,SUM(_count)
FROM
	(SELECT category.name AS name, film.rental_duration AS rental_duration, NTILE(4) OVER (PARTITION BY name ORDER BY COUNT(rental_duration)) AS standard_quartile ,COUNT(film.film_id) AS _count
	FROM film_category
	JOIN film ON film.film_id= film_category.film_id
	JOIN category ON  category.category_id=film_category.category_id
	GROUP BY 1,2, rental_duration)sub
GROUP BY 1,2
ORDER BY 1;



/*Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. 
Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.*/

SELECT 
date_part('Month',rental.rental_date ) AS Rental_Month,
date_part('Year',rental.rental_date ) AS Rental_Year,
inventory.store_id ,COUNT(rental.customer_id) 
AS rental_count
FROM rental
JOIN inventory ON  inventory.inventory_id=rental.inventory_id
GROUP BY 1,2,3
ORDER BY 1 ;


