use airbnbdata;
select * from airbnb;

-- Price Analysis
# Q1. What is the Average Price of Listings by Room Type?
select room_type , Round(avg(price),2) as avg_price
from airbnb
group by room_type;


# Q2. Which Neighbourhoods have highest average listing price?
select neighbourhood , Round(avg(price),2) as avg_price
from airbnb
group by neighbourhood
order by avg_price DESC
limit 10;

# Q3. Which Region have highest average listing price and expensive?
select neighbourhood_group , round(avg(price),2) as avg_price
from airbnb
group by neighbourhood_group
order by avg_price DESC;

# Q4.. What is the distribution of listings across different price ranges?
select 
   case 
        when price < 100 then 'Low Price'
        when price between 100 and 200 then 'Medium Price'
        else 'High Price'
    end as  price_category,
    COUNT(*) as total_listings
from airbnb
group by price_category;


-- Review Analysis
# Q5. Which listings have received the highest numbers of reviews?
select name , number_of_reviews 
from airbnb
order by number_of_reviews DESC
limit 10;

# Q6. what is the Average number of reviews bu room type?
select room_type , round(avg(number_of_reviews),2) as avg_reviews
from airbnb
group by room_type;


# Q7. . Do higher-priced listings receive fewer reviews?
select 
	case
		when price < 100 then 'Low_price'
        when price between 100 and 200 then 'Medium_price'
        else 'high_price'
	end as price_category,
	round(avg(number_of_reviews),2) as avg_reviews
from airbnb
group by price_category;


-- Availability Analysis
# Q8.What is the average availability of listings by room type?
select room_type ,round( avg(availability_365),2) as avg_avalability
from airbnb
group by room_type
order by avg_avalability DESC;

# Q9. How many listings are available for more than 200 days in a year?
select count(*) as high_availability_listings
from airbnb
where availability_365 > 200;

# Q10. Which neighbourhoods have the highest availability?
select neighbourhood  , round(avg(availability_365),2) as avg_availability
from airbnb
group by neighbourhood
order by avg_availability DESC
limit 10;
	
# Q11.Identify those listings whose price is greater than over all average price?
with total_avg_price as (
     select avg(price) as avg_price
     from airbnb
)
select id, name , price 
from airbnb , total_avg_price
where price > total_avg_price.avg_price;

# Q12.Rank neighbourhoods by average price 
select * from (
   select neighbourhood,
     avg(price) as avg_price,
     rank() over(order by avg(price) DESC) as rnk
   from airbnb
   group by neighbourhood
) t
 where t.rnk <= 10;
 ----------------------------------------
 with price_rank as (
    select
        neighbourhood,
        avg(price) as avg_price,
        rank() over (order by avg(price) desc) as rank_no
    from airbnb
    group by  neighbourhood
)
		select *
		from price_rank
		where rank_no <= 10;
		

# Q13. Identify high-value listings based on price and reviews
select name, price, number_of_reviews
from airbnb
where price > 200 and number_of_reviews > 50
order by  price DESC;

# Q14. Combine key metrics (price, reviews, availability) by room type
select room_type,
       round(avg(price),2) as avg_price,
       round(avg(number_of_reviews),2) as avg_reviews,
       round(avg(availability_365),2) as avg_availability
from airbnb
group by room_type;
