with renamed as (select * from {{ source("input", "fact_premiums") }})

select *
from renamed
