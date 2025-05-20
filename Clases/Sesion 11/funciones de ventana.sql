-- Funciones Ventana
-- 14 - 05 - 2025

use dwhsales;

 -- with genera una tabla temporal que solo se puede usar en la siguiente consulta.
with ventas as(select profit as ganancia from fact_sales)
	select ganancia from ventas;
    
-- 

with ranked_customers as(
	select dg.country_name, dc.customer_id, concat_ws(' ', dc.first_name,
    dc.last_name) customer, dc.age, dc.occupation, dc.gender,
    sum(fs.profit) as total_profit,
    row_number() over(partition by dg.country_name order by sum(fs.profit) desc
) as customer_rank
	from fact_sales fs
    join dim_customer dc on(fs.dim_customer_id = dc.customer_id)
    join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
    group by dg.country_name, dc.customer_id
)
select * from ranked_customers where customer_rank <=3;

--
select dg.continent, dt.year,
	sum(fs.profit) as total_profit,
    lag(sum(fs.profit)) over(partition by dg.continent order by dt.year)
previuos_year_profit,
	sum(fs.profit) - lag(sum(fs.profit)) over(partition by dg.continent order by dt.year) growth
    from fact_sales fs
    join dim_time dt on (fs.dim_time_id = dt.time_id)
    join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
    group by dg.continent, dt.year;
    
-- 

with total_units as (
	select sum(fs.units_sold) as global_total_sold
    from fact_sales fs
)
select dg.country_name country, 
sum(fs.units_sold) as country_sold,
round(sum(fs.units_sold) / (select global_total_sold from total_units) * 100, 2) percentage_units_sold
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dg.country_name
with rollup
order by percentage_units_sold desc;