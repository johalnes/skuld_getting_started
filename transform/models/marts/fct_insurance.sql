with
    claims_and_premiums as (
        select
            coalesce(int_premiums.primary_id, int_claims.primary_id) as primary_id,
            coalesce(int_premiums.business_id, int_claims.business_id) as business_id,
            coalesce(
                int_premiums.product_line_id, int_claims.product_line_id
            ) as product_line_id,
            coalesce(
                int_premiums.business_unit_id, int_claims.business_unit_id
            ) as business_unit_id,
            coalesce(
                int_premiums.accident_date, int_claims.accident_date
            ) as accident_date,
            coalesce(
                int_premiums.development_date, int_claims.development_date
            ) as development_date,
            int_claims.incurred_claims_usd,
            int_claims.paid_claims_usd,
            int_claims.reserved_claims_usd,
            int_premiums.earned_premium_usd
        from {{ ref("int_premiums") }} as int_premiums
        full join {{ ref("int_claims") }} as int_claims using (primary_id)
    )

select *
from claims_and_premiums
