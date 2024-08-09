create database pizza_house;
use pizza_house;

-- created tables using Table Data Import Wizard
-- pizzas.csv (4 kb) and pizza_types.csv (4 kb)

-- creating table orders
create table orders( 
order_id int,
order_data date,
order_time time,
primary key(order_id));

-- we insert values into this table using Table Data Import Wizard

-- creating table order_details
create table order_details( 
order_details_id int,
order_id int,
pizza_id text,
quantity int,
primary key(order_details_id), foreign key(order_id) references orders(order_id));

-- Foreign key 'order_id'
-- we insert values into this table using Table Data Import Wizard


select count(order_id) from order_details





