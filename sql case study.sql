-- 1. What is the total amount each customer spent at the restaurant?
select c.customer_id,sum(m.price) as total_amount_spent
from sales c join menu m on c.product_id = m.product_id
group by c.customer_id
order by total_amount_spent desc;

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(DISTINCT order_date) as visit_day
from sales
group by customer_id
order by visit_day desc;

--3. What was the first item from the menu purchased by each customer?
with first_order as (
    select customer_id,
        MIN(order_date) AS first_order_date
  from sales 
  group by customer_id
)
select c.customer_id,m.product_name
from sales c join first_order f on c.customer_id = f.customer_id
 and c.order_date = f.first_order_date
join menu m on c.product_id = m.product_id
order by c.customer_id;

-- 4. What is the most purchased item on the menu 
--and how many times was it purchased by all customers?
select m.product_name , count(*) as totol_purchase 
from sales c 
join menu m on c.product_id = m.product_id
group by m.product_name
order by totol_purchase desc
limit 1;

-- 5. Which item was the most popular for each customer?
with c1 as (
  select c.customer_id,m.product_name,count(*) as purchase_count,
  row_number () over(partition by c.customer_id order by count(*) desc) as rn
  from sales c join menu m on c.product_id=m.product_id 
  group by c.customer_id,m.product_name
)
SELECT 
    customer_id,
    product_name,
    purchase_count
from c1 
 where rn = 1
 order by customer_id;
-- 6. Which item was purchased first by the customer after they became a member?

with alll as (
select c.customer_id,c.order_date,c.product_id ,p.join_date
from sales c join members p on c.customer_id = p.customer_id
where c.order_date>p.join_date),
    c1 as (
  select cs.customer_id,cs.order_date,m.product_name,
  row_number()over (partition by cs.customer_id order by cs.order_date desc) rn
  from alll cs join menu m on cs.product_id= m.product_id
)

select customer_id,product_name,order_date from c1 
where rn =1;

-- 7. Which item was purchased just before the customer became a member?

with alll as (
select c.customer_id,c.order_date,c.product_id ,p.join_date
from sales c join members p on c.customer_id = p.customer_id
where c.order_date<p.join_date),
    c1 as (
  select cs.customer_id,cs.order_date,m.product_name,
  row_number()over (partition by cs.customer_id order by cs.order_date desc) rn
  from alll cs join menu m on cs.product_id= m.product_id
)

select customer_id,product_name,order_date from c1 
where rn =1;
















  