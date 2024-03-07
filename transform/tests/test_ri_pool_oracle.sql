{{ config(store_failures=true) }}

with
    oracle as (
        select
            master_claim_no,
            -- layer_no,
            sum(amount_usd) as reinsurance_share_oracle
        from {{ source("ra_data", "erm_fact_poolable") }}
        group by all
    ),

    duckdb as (
        select
            master_claim_no,
            -- layer_no,
            sum(reinsurance_share_total) as reinsurance_share_duckdb
        from {{ ref("int_ri_pool_layers") }}
        where acc_period = 202312
        group by all
    ),

    pool_claims as (
        select
            dim.master_claim_no,
            -- layer_no,
            sum(fact_pool.club_gross) as fact_pool_total_amount_usd
        from {{ source("ra_data", "fact_pool_acc_period") }} as fact_pool
        left join
            {{ source("ra_data", "dim_pool_claims") }} as dim
            on fact_pool.claim_no = dim.claim_no
        group by dim.master_claim_no
    )

select
    coalesce(
        oracle.master_claim_no, duckdb.master_claim_no, pool_claims.master_claim_no
    ) as master_claim_no,
    -- coalesce(oracle.layer_no, duckdb.layer_no) as layer_no,
    pool_claims.fact_pool_total_amount_usd,
    duckdb.reinsurance_share_duckdb,
    oracle.reinsurance_share_oracle,
    abs(
        pool_claims.fact_pool_total_amount_usd - duckdb.reinsurance_share_duckdb
    ) as diff_fact_pool_duckdb,
    abs(
        oracle.reinsurance_share_oracle + duckdb.reinsurance_share_duckdb
    ) as diff_oracle_duckdb

from oracle
full join duckdb on oracle.master_claim_no = duckdb.master_claim_no
full outer join pool_claims on oracle.master_claim_no = pool_claims.master_claim_no
-- and oracle.layer_no = duckdb.layer_no
where diff_oracle_duckdb > 10
