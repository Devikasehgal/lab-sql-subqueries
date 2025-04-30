-- Select the Sakila database
USE sakila;

-- Challenge 1 - Number of copies of the film "Hunchback Impossible"
SELECT 
    COUNT(*) AS number_of_copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

-- Challenge 2 - List all films longer than average length
SELECT 
    title,
    length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

-- Challenge 3 - Display all actors who appear in the film "Alone Trip"
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
);

-- Bonus Challenge 4 - Identify all movies categorized as family films
SELECT 
    f.title
FROM film f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    INNER JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Family'
);

-- Bonus Challenge 5 - Retrieve name and email of customers from Canada (subquery method)
SELECT 
    first_name,
    last_name,
    email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- Bonus Challenge 6 - Films starred by the most prolific actor
SELECT 
    f.title
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);

-- Bonus Challenge 7 - Films rented by the most profitable customer
SELECT 
    f.title
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- Bonus Challenge 8 - Clients who spent more than average total amount
SELECT 
    customer_id,
    SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
    SELECT AVG(customer_total)
    FROM (
        SELECT 
            customer_id,
            SUM(amount) AS customer_total
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
);