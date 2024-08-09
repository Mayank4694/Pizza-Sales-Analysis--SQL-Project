-- Pizza House Query
use pizza_house;

-- Q1. Retrieve the total number of orders placed.

-- i.e. count order_id
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- Q2. Calculate the total revenue generated from pizza sales.
-- i.e. Sum of qty x price
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS 'Total Revenue'
FROM
    order_details
        LEFT JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- Q3. Identify the highest-priced pizza.
-- i.e. pizza name and price 
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        LEFT JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Q4. Identify the most common pizza size ordered.
-- i.e. we need order_detail_id and size
SELECT 
    size, COUNT(order_details_id) AS Times_ordered
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY (size)
ORDER BY Times_ordered DESC
LIMIT 1;

-- Q5. List the top 5 most ordered pizza types along with their quantities.
-- i.e. pizzas.name and count(order_details_id)

-- 1st solution using create view (temporary virtual table)
CREATE VIEW v1 AS
    SELECT 
        order_details_id,
        order_details.pizza_id,
        quantity,
        pizza_type_id
    FROM
        order_details
            LEFT JOIN
        pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Top 5 most ordered pizzas with their quantity
SELECT 
    name, SUM(quantity) AS total_qty
FROM
    v1
        LEFT JOIN
    pizza_types ON v1.pizza_type_id = pizza_types.pizza_type_id
GROUP BY name
ORDER BY total_qty DESC
LIMIT 5;


-- 2nd solution using 2 joins
SELECT 
    name, SUM(quantity) AS total_qty
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY name
ORDER BY total_qty DESC
LIMIT 5;





















