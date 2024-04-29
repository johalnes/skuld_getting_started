{{ config(materialized="table") }}

with dates as ({{ dbt_date.get_date_dimension("1960-01-01", "2030-12-31") }})

select *
from dates
