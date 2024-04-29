import polars as pl


def calculate_cl_factors(
    amount: str = "paid_claims_usd",
    index: str = "line_of_business",
    development: str = "development_lag",
    origin="accident_date",
) -> pl.Expr:
    """
    Calculate Chain-Ladder Factors.

    Args:
        amount (str): The column name representing the amount of claims.
        index (str): The column name representing the line of business.
        development (str): The column name representing the development lag.
        origin (str): The column name representing the accident date.

    Returns:
        pl.Expr: A Polars expression representing the calculated Chain-Ladder Factors.
    """

    sort_cols = [index, origin, development]
    over_cols = [index, origin]

    return (
        pl.col(amount).sort_by(sort_cols).pct_change().over(over_cols).fill_null(0) + 1
    )


def calculate_cdf(ldf: str = "ldf_incurred", development: str = "development_lag"):
    """
    Calculate the cumulative distribution function (CDF) based on the given loss development factors (LDF) and development lags.

    Args:
        ldf (str): The name of the column containing the loss development factors. Default is "ldf_incurred".
        development (str): The name of the column containing the development lags. Default is "development_lag".

    Returns:
        cdf (pandas.Series): The calculated cumulative distribution function.

    """

    cdf = (
        pl.col(ldf)
        .sort_by(development, descending=True)
        .shift(1, fill_value=1)
        .cum_prod()
    )
    return cdf.reverse()


def calculate_ldf_and_cdf(df, index, development, origin):
    """
    Calculate loss development factors (LDF) and cumulative development factors (CDF) for a given DataFrame.

    Args:
        df (DataFrame): The input DataFrame containing the data.
        index (str): The column name to be used as the index.
        development (str): The column name representing the development period.
        origin (str): The column name representing the origin period.

    Returns:
        DataFrame: A concatenated DataFrame containing the calculated LDF and CDF values.

    """
    dataframes = []

    for df_lob in df.partition_by("line_of_business"):
        df_factors = (
            df_lob.with_columns(
                cl_factor_incurred=calculate_cl_factors(amount="incurred_claims_usd"),
                cl_factor_paid=calculate_cl_factors(amount="paid_claims_usd"),
            )
            .group_by([index, development])
            .agg(
                ldf_incurred=pl.col("cl_factor_incurred").mean(),
                ldf_paid=pl.col("cl_factor_paid").mean(),
            )
            .sort(development)
            .with_columns(
                cdf_incurred=calculate_cdf("ldf_incurred"),
                cdf_paid=calculate_cdf("ldf_paid"),
            )
        )
        dataframes.append(df_factors)
    return pl.concat(dataframes)


def model(dbt, session):
    dbt.config(materialized="table", location="../data/output/development_factors.csv")

    df = dbt.ref("report_ibnr").pl()

    # Have to loop through the years to calculate the chain ladder factors
    # as a simulation for yearly IBNR modelling
    dev_years = df.select(pl.col("development_year").unique().sort()).to_series()
    df_cf = pl.concat(
        [
            (
                df.filter(pl.col("development_year") <= dev_year)
                .pipe(
                    calculate_ldf_and_cdf,
                    index="line_of_business",
                    development="development_lag",
                    origin="accident_date",
                )
                .with_columns(development_year=pl.lit(dev_year))
            )
            for dev_year in dev_years
        ]
    )

    return df_cf
