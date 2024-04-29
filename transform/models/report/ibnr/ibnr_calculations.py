import polars as pl


def model(dbt, session):
    dbt.config(materialized="external", location="../data/output/ibnr_calculations.csv")

    df_claims_premium = dbt.ref("report_ibnr").pl()
    df_cl_factors = dbt.ref("development_factors").pl()
    df_expected_loss_parameters = dbt.ref("ibnr_expected_loss").pl()
    df_ibnr = (
        df_claims_premium.join(
            df_cl_factors,
            on=["line_of_business", "development_year", "development_lag"],
            how="inner",
        )
        .join(df_expected_loss_parameters, on=["line_of_business"], how="outer")
        .with_columns(
            ibnr_cl_incurred=pl.col("incurred_claims_usd") * pl.col("cdf_incurred")
            - pl.col("incurred_claims_usd"),
            ibnr_cl_paid=pl.col("paid_claims_usd") * pl.col("cdf_paid")
            - pl.col("paid_claims_usd"),
            ibnr_loss_ratio=pl.col("earned_premium_usd") * pl.col("expected_loss_ratio")
            - pl.col("incurred_claims_usd"),
        )
    )

    return df_ibnr
