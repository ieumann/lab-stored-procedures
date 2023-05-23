USE sakila;

# 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
# Convert the query into a simple stored procedure.

DELIMITER //
CREATE PROCEDURE customers_renting_action_movies()
BEGIN
  SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = 'Action'
  GROUP BY first_name, last_name, email;
END //
DELIMITER ;

CALL customers_renting_action_movies();

# 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it 
# can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
# For eg., it could be action, animation, children, classics, etc.

DROP PROCEDURE IF EXISTS customers_renting_movies_by_category;

DELIMITER //
CREATE PROCEDURE customers_renting_movies_by_category(IN f_category VARCHAR(10))
BEGIN
  SELECT first_name, last_name, email 
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = f_category
  GROUP BY first_name, last_name, email;
END //
DELIMITER ;

CALL customers_renting_movies_by_category('Action');

# 3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter 
# only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

DELIMITER //
CREATE PROCEDURE num_movies_per_category_above_param(IN param1 INT)
BEGIN
    SELECT c.name, SUM(film_id) AS num_films
    FROM film_category AS fc
    JOIN category AS c ON fc.category_id = c.category_id
    GROUP BY c.name
    HAVING SUM(film_id) > param1;
END //
DELIMITER ;

CALL num_movies_per_category_above_param(32000)
