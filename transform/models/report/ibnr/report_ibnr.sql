{{ config(materialized="table", location="../data/output/report_ibnr.csv") }}

with
    triangles as (

        select
            line_of_business_id,
            line_of_business,
            accident_date,
            development_date,
            accident_date.year_number as accident_year,
            development_date.year_number as development_year,
            -- Easy calculations between dates for all granularity of lags
            datediff('year', accident_date, development_date) as development_lag,
            -- sum all claim amounts
            sum(incurred_claims_usd) as incurred_claims_usd,
            sum(paid_claims_usd) as paid_claims_usd,
            sum(reserved_claims_usd) as reserved_claims_usd,
            -- sum all premium amounts
            sum(earned_premium_usd) as earned_premium_usd
        from {{ ref("fct_insurance") }} as fct_insurance
        left join {{ ref("dim_product") }} as dim_product using (product_line_id)
        inner join
            {{ ref("dim_date") }} as accident_date
            on fct_insurance.accident_date = accident_date.date_day
        inner join
            {{ ref("dim_date") }} as development_date
            on fct_insurance.development_date = development_date.date_day
            and development_date.day_of_month = 20
        inner join
            {{ source("input", "dim_group") }} as dim_group using (business_unit_id)

        group by all
    )

select
    triangles.*,
    -- incremental sums by amount - lag(amount) for all claims and premium sums
    incurred_claims_usd - coalesce(
        lag(incurred_claims_usd) over (
            partition by line_of_business_id, accident_year order by development_year
        ),
        0
    ) as incremental_incurred_claims_usd,
    paid_claims_usd - coalesce(
        lag(paid_claims_usd) over (
            partition by line_of_business_id, accident_year order by development_year
        ),
        0
    ) as incremental_paid_claims_usd,
    incremental_incurred_claims_usd
    - incremental_paid_claims_usd as incremental_reserved_claims_usd
from triangles
