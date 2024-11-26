Create database Pizza_Sales;
use Pizza_sales;

select * from orders;
Select * from order_details;
Select * from pizzas;
Select * from pizza_types;


-- Q1. Retrieve the total number of orders placed.

Select 
 count(order_id) "Total_Orders" 
from orders;


-- Q2. Calculate the total revenue generated from pizza sales.

Select 
    round(sum(order_details.quantity * pizzas.price),2) as "Total_revenue"
	from order_details  
	join pizzas 
	on order_details.pizza_id = pizzas.pizza_id;


-- Q3.Identify the highest-priced pizza.

Select
    Top 1
	pizza_types.name, pizzas.price
	from pizza_types 
	join pizzas 
	on pizza_types.pizza_type_id = pizzas.pizza_type_id
	order by pizzas.price desc


-- Q4.Identify the most common pizza size ordered.

Select
	pizzas.size,
	count(order_details.order_details_id) as Order_count
	from pizzas 
	join order_details 
	on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by Order_count desc


-- Q5. List the top 5 most ordered pizza types along with their quantities.

Select 
	Top 5
	pt.name,
	sum(order_details.quantity) as Quantity
	from pizza_types pt 
	join pizzas p
	on pt.pizza_type_id = p.pizza_type_id
	join order_details
	on order_details.pizza_id = p.pizza_id
Group By pt.name
order by quantity desc;


--Q6.Join the necessary tables to find the total quantity of each pizza category ordered.

Select 
	pt.category,
	sum(order_details.quantity) as Quantity
	from pizza_types pt
	join pizzas p
	on pt.pizza_type_id = p.pizza_type_id
	join order_details
	on order_details.pizza_id = p.pizza_id
Group by pt.category
Order by Quantity desc


--Q7.Determine the distribution of orders by hour of the day.

Select 
	DateTrunc(Hour,time) as "Hour",
	count(order_id) as Order_count
from orders
Group By DateTrunc(Hour,time)
Order by Order_count desc;


--Q8. Join relevant tables to find the category-wise distribution of pizzas.

Select 
	category,
	count(name)
	from pizza_types
Group By category;


--Q9. Group the orders by date and calculate the average number of pizzas ordered per day.

Select 
	avg(Number_of_pizza_ordered) as Avg_pizza_ordered_per_day
	from
(Select 
	orders.date,
	sum(order_details.quantity) as Number_of_pizza_ordered
	from orders
	join order_details
	on orders.order_id = order_details.order_id
group by orders.date)t


--Q10. Determine the top 3 most ordered pizza types based on revenue.

Select
    Top 3
	pizza_types.name,
	sum(pizzas.price * order_details.quantity) as Revenue
	from pizza_types
	join pizzas
	on pizzas.pizza_type_id = pizza_types.pizza_type_id
	join order_details
	on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.name
order by revenue desc


-- Q11. Calculate the percentage contribution of each pizza type to total revenue.

Select 
	pizza_types.category,
	round(sum(order_details.quantity * pizzas.price) / (Select 
       round(sum(order_details.quantity * pizzas.price),2) as "Total_revenue"
	from order_details  
	join pizzas 
	on order_details.pizza_id = pizzas.pizza_id) *100,2) as Revenue

	from pizza_types
	join pizzas
	on pizzas.pizza_type_id = pizza_types.pizza_type_id
	join order_details
	on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.category
Order by Revenue desc


--Q12. Analyze the cumulative revenue generated over time.


Select date,
round(sum(revenue) over(order by date),2) as Cum_Revenue
from
(Select 
	orders.date,
	sum(order_details.quantity * pizzas.price) as Revenue
	from order_details 
	join pizzas
	on order_details.pizza_id = pizzas.pizza_id
	join orders
	on orders.order_id = order_details.order_id
Group by orders.date)t


--Q13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.


Select category, name ,Revenue
from
(select 
category,name,revenue,
rank() over(partition by category order by revenue desc) as Rn
from
(Select 
	pizza_types.category,
	pizza_types.name,
	sum(order_details.quantity * pizzas.price) as Revenue
	from pizza_types
	join pizzas
	on pizza_types.pizza_type_id = pizzas.pizza_type_id
	join order_details
	on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.name) t) b
where Rn <=3;









