{% docs fct_ri_pool_claims %}
# Summary: fct_ri_pool_claims

The `fct_ri_pool_claims` table provides a comprehensive view of insurance claim data related to reinsurance pooling. It's structured in several steps:

1. **pivot_claims**: This step reorganizes the data from the `fact_pool_acc_period` table, summarizing the total `club_gross` and `club_gross_usop` for each category of 'PAID' and 'EST'.

2. **dim_pool_master_claim_no**: This step selects data from the `dim_pool_claims` table and calculates the percentage of each claim that is within the insurance group (IG). This is done by subtracting the percentage of the claim that is outside the IG from 100%.

3. **claims**: This step combines the data from the previous two steps based on the `claim_no` column. It calculates the `paid_gross`, `est_gross`, `paid_usop`, and `est_usop` for each claim.

4. **cumulative_claims**: This final step calculates the cumulative sums of `paid_gross`, `est_gross`, `paid_usop`, and `est_usop` for each `master_claim_no` over the `acc_period`.

The `fct_ri_pool_claims` table includes all the calculated fields and provides a detailed view of the insurance claim data, making it easier to analyze and understand the data related to reinsurance pooling.

{% enddocs %}

{% docs int_ri_pool_layers %}
# Summary: int_ri_pool_layers

int_ri_pool_layers takes the `fact_pool_par` and `fct_ri_pool_claims` tables and combines them to get net claims for Skuld's reinsurance pooling. It's structured in several steps:

1. **layers**: This step reorganizes the data from the `fact_pool_par` table, extracting layer descriptions, layer numbers, policy years, and retention limits. It also calculates the upper limit for each policy year.

2. **ri_individual_claims**: This step selects data from the `fct_ri_pool_claims` table and combines it with the `layers` data based on the `policy_year` and `cumulative_incurred` fields. It calculates the `reinsurance_share_total`, `reinsurance_share_paid`, and `reinsurance_share_outstanding` for each claim.

The output now contains all claims with correct layers, but without aggregated limits at each layer. This is done in the next step.
{% enddocs %}