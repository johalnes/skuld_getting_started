with source as (
      select * from {{ source('input', 'fact_premiums') }}
),
renamed as (
    select
        

    from source
)
select * from renamed
  