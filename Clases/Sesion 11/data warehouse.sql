-- 12 - 05 - 2025
-- Data Warehouse

use dwhsales;
show tables;

select * from fact_sales;
select * from dim_time;
select * from dim_customer;
select * from dim_geography;
select * from dim_product;

--
select count(*) nreg, sum(profit) profittotal, sum(units_sold) total_unidades
from fact_sales fs;

select dt.year, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by year;

-- drill down
-- -- añadir año
select dt.year, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year
with rollup;

-- -- añadir mes
select dt.year, dt.month_name, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year, dt.month_name
with rollup;

-- -- añadir si es fin de semana
select dt.year, dt.month_name, dt.is_weekend, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on (fs.dim_time_id = dt.time_id)
group by dt.year, dt.month_name
with rollup;


-- -- por año, continente y region
select dt.year, dg.continent, dg.region, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on (fs.dim_time_id = dt.time_id)
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dg.continent, dg.region
with rollup;

-- -- por año, continente y genero
select dt.year, dg.continent, dc.gender, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on (fs.dim_time_id = dt.time_id)
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.year, dg.continent, dc.gender
with rollup;

-- -- por año, dia y categoria
select dt.year, dt.day_name, dp.category, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on (fs.dim_time_id = dt.time_id)
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dt.year, dt.day_name, dp.category
with rollup;

-- -- por año, dia y categoria (ordenado)
select dt.year, dt.day_name, dp.category, count(*) nreg, sum(profit) profit_total, sum(units_sold) total_unidades
from fact_sales fs
join dim_time dt on (fs.dim_time_id = dt.time_id)
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dt.year, dt.day_name, dp.category
order by field(dt.day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), 
dp.category;

