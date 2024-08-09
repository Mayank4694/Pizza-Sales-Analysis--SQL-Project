-- Q6. Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    category, SUM(quantity) AS total_qty
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY category
ORDER BY total_qty DESC;

-- Q7. Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hour
ORDER BY hour ASC;

-- Q8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Q9. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        SUM(quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY order_date) AS order_quantity;

-- Q10. Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    name, SUM(quantity * price) AS tot_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY name
ORDER BY tot_revenue DESC
LIMIT 3;

-- Q11. Calculate the percentage contribution of each pizza type to total revenue.

CREATE VIEW v2 AS
    (SELECT 
        name, SUM(quantity * price) AS tot_revenue
    FROM
        order_details
            JOIN
        pizzas ON order_details.pizza_id = pizzas.pizza_id
            JOIN
        pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    GROUP BY name
    ORDER BY tot_revenue DESC);

SELECT 
    name,
    ROUND(tot_revenue * 100 / (SELECT 
                    SUM(tot_revenue)
                FROM
                    v2),
            2) AS 'Revenue%'
FROM
    v2
GROUP BY name
ORDER BY 'Revenue%' DESC;

-- Revenue% by Category

CREATE VIEW v3 AS
    (SELECT 
        category, SUM(quantity * price) AS tot_revenue
    FROM
        order_details
            JOIN
        pizzas ON order_details.pizza_id = pizzas.pizza_id
            JOIN
        pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    GROUP BY category
    ORDER BY tot_revenue DESC);

-- select * from v3

SELECT 
    category,
    ROUND(tot_revenue * 100 / (SELECT 
                    SUM(tot_revenue)
                FROM
                    v3),
            2) AS 'Revenue%'
FROM
    v3
GROUP BY category
ORDER BY 'Revenue%' DESC;


-- Q12. Analyze the cumulative revenue generated over time.

-- CUMULATIVE SUM
select order_date, round(sum(revenue) over(order by order_date),2) as cum_revenue 
from (select order_date, round(sum(quantity*price),2) as revenue 
from order_details join orders 
on order_details.order_id =orders.order_id 
join pizzas on pizzas.pizza_id = order_details.pizza_id
group by order_date order by order_date) as sales;



-- Q13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

-- create view v13 as 
-- select quantity, price, name, category
-- from order_details join pizzas on order_details.pizza_id =pizzas.pizza_id join pizza_types on pizza_types.pizza_type_id =pizzas.pizza_type_id;

-- select category, name, sum(sum(quantity)* price) as revenue from v13 group by category,name

 -- RANK
select category, name, revenue from  
(select category, name, revenue, 
rank() over(partition by category order by revenue desc) as class from 
(select category, name, sum(quantity* price) as revenue from 
order_details join pizzas on order_details.pizza_id =pizzas.pizza_id 
join pizza_types on pizza_types.pizza_type_id =pizzas.pizza_type_id
group by category,  name) as a) as b where class <=3;










