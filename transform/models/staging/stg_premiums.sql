with
    renamed as (
        select
            product_line_id,
            business_unit_id,
            make_date(
                accidentyear, cast(1 + floor(12 * random()) as int), 20
            ) as accident_date,
            make_date(
                developmentyear, cast(1 + floor(12 * random()) as int), 20
            ) as development_date,
            earnedpremdir as earned_premium_usd
        from {{ source("input", "fact_premiums") }}
    )

select *
from renamed
