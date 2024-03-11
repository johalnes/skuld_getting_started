{% set pk_columns = [
    "product_line_id",
    "business_unit_id",
    "accident_date",
    "development_date",
] %}

with
    claim_data as (

        select
            {{ dbt_utils.generate_surrogate_key(pk_columns) }} as primary_id,
            {{ concat_columns(pk_columns) }} as business_id,
            product_line_id,
            business_unit_id,
            accident_date,
            development_date,
            sum(incurred_claims_usd) as incurred_claims_usd,
            sum(paid_claims_usd) as paid_claims_usd,
            sum(incurred_claims_usd) - sum(paid_claims_usd) as reserved_claims_usd
        from {{ ref("stg_claims") }}
        group by all
    )

select *
from claim_data
