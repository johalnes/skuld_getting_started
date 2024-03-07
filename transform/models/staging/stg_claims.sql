with renamed as (select * from {{ source("input", "fact_claims") }})

select *
from renamed
