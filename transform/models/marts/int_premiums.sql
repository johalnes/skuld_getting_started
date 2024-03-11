{% set pk_columns = [
    "product_line_id",
    "business_unit_id",
    "accident_date",
    "development_date",
] %}

with
    premium_data as (
        select
            {{ dbt_utils.generate_surrogate_key(pk_columns) }} as primary_id,
            {{ concat_columns(pk_columns) }} as business_id,
            product_line_id,
            business_unit_id,
            accident_date,
            development_date,
            sum(earned_premium_usd) as earned_premium_usd
        from {{ ref("stg_premiums") }}
        group by all
    )

select *
from premium_data
