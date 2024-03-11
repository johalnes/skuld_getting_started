with
    renamed as (
        select
            product_line_id,
            business_unit_id,
            make_date(accidentyear, 2, 20) as accident_date,
            make_date(developmentyear, 2, 20) as development_date,
            incurloss as incurred_claims_usd,
            cumpaidloss as paid_claims_usd
        from {{ source("input", "fact_claims") }}
    )

select *
from renamed
