-- 1. Creating the database
create database if not exists house_price_regression;

-- 2. Creating the table
create table if not exists house_price_data (
  `id` varchar(255) not null,
  `date` date default null, 
  `bedrooms` int default null, 
  `bathrooms` float default null,
  `sqft_living` int default null,
  `sqft_lot` int default null,
  `floors` float default null,
  `waterfront` int default null,
  `view` int default null,
  `condition` int default null,
  `grade` int default null,
  `sqft_above` int default null,
  `sqft_basement` int default null,
  `yr_built` year default null,
  `yr_renovated` year default null,
  `zipcode` int default null,
  `lat` float default null,
  `long` float default null,
  `sqft_living15` int default null,
  `sqft_lot15` int default null,
  `price` int default null,
  constraint primary key (id) 
);

-- 3. Importing the data from the csv file
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/regression_data.csv' 
into table films_2020
fields terminated by ',';
-- I was getting error after error when loading the data with the code that is above, so I loaded the data via Table Data Import Wizard ("Create new table")

-- 4. Selecting all the data from table house_price_data
select * from house_price_regression.house_price_data;

-- 5. Dropping the column date
alter table house_price_regression.house_price_data
drop column `date`;

-- 5.1. Select all the data from the table to verify if the previous command worked. Limiting to 10
select * from house_price_regression.house_price_data limit 10;

-- 6. Finding out how many rows of data we have
select count(*) from house_price_regression.house_price_data;

-- 7. Finding the unique values in some of the categorical columns
-- 7.1. Beedrooms
select distinct bedrooms from house_price_regression.house_price_data;

-- 7.2. Bathrooms
 select distinct bathrooms from house_price_regression.house_price_data;

-- 7.3. Floors
select distinct floors from house_price_regression.house_price_data;

-- 7.4. Condition
select distinct `condition` from house_price_regression.house_price_data;

-- 7.5. Grade
select distinct grade from house_price_regression.house_price_data;

-- 8. Arranging the data in a decreasing order by the price of the house. Returning only IDs of the top 10 most expensive houses in the data
select id from house_price_regression.house_price_data
order by price desc limit 10;

-- 9. Finding out the average price of all the properties in the data
select avg(price) from house_price_regression.house_price_data;

-- 10. Checking the properties of some of the categorical variables in the data
-- 10.1. What is the average price of the houses grouped by bedrooms?
select bedrooms, avg(price) as 'Average Price' 
from house_price_regression.house_price_data
group by bedrooms;

-- 10.2. What is the average sqft_living of the houses grouped by bedrooms? 
select bedrooms, avg(sqft_living) as 'Average Square Feet' 
from house_price_regression.house_price_data
group by bedrooms;

-- 10.3. What is the average price of the houses with a waterfront and without a waterfront?
-- With a waterfront
select waterfront, avg(price) as 'Average Price' 
from house_price_regression.house_price_data
group by waterfront;

-- 10.4. Is there any correlation between the columns condition and grade?
select `condition`, avg(grade) 
from  house_price_regression.house_price_data
group by `condition`
order by `condition` asc;
-- There is no correlation; or there is positive correlation from condition 1 to 3 and negative correlation from condition 3 to 5

-- 11. Query to find houses with specific characteristics
select * from house_price_regression.house_price_data
where bedrooms between 3 and 4 
and bathrooms > 3 
and floors = 1 
and waterfront = 0 
and `condition` >= 3 
and grade >= 5 
and price < 300000;

-- 12. Finding the list of properties whose prices are twice more than the average of all the properties in the database. Using a subquery
select * from house_price_regression.house_price_data
where price > (select avg(price)*2 from house_price_regression.house_price_data);

-- 13. Creating a view from the previous query
create view high_priced_properties as
select * from house_price_regression.house_price_data
where price > (select avg(price)*2 from house_price_regression.house_price_data);

select * from high_priced_properties;

-- 14. Finding the difference in average prices of the properties with three and four bedrooms
select bedrooms, avg(price) as 'Average Price'
from house_price_regression.house_price_data
where bedrooms in (3, 4)
group by bedrooms;

-- 15. Finding out the different locations where properties are available in your database
select distinct zipcode, lat, `long` 
from house_price_regression.house_price_data;

-- 16. Showing the list of all the properties that were renovated
select * from house_price_regression.house_price_data
where yr_renovated > 1;

-- 17. Providing the details of the property that is the 11th most expensive property in your database
select * from house_price_regression.house_price_data
order by price desc 
limit 10, 1;