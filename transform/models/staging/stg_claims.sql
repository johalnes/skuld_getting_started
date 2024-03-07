with source as (
      select * from {{ source('ra_data', 'fact_claims') }}
),
renamed as (
    select
        

    from source
)
select * from renamed
  