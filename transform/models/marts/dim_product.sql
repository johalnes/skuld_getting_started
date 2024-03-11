with
    complete_product as (
        select dim_product.*, dim_lob.*
        from {{ source("input", "dim_product") }} as dim_product
        inner join {{ ref("dim_line_of_business") }} as dim_lob using (product_line_id)
    )

select *
from complete_product
