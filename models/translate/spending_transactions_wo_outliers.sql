{{
    config(
        alias = "spending_transactions_wo_outliers",
        materialized = "ephemeral"
    )
 }}

with
    -- Select only transaction amounts
    transactions as (
        select transaction_amount from {{ ref("spending_transactions_datamart") }}
    ),

    -- Calculate z-scores: (transaction_amount - mean(transaction_amount)) /
    -- stddev(transaction_amount)
    transactions_z_score as (
        select
            transaction_amount,
            (
                (transaction_amount - (avg(transaction_amount) over ()))
                / (stddev_pop(transaction_amount) over ())
            ) as z_score
        from transactions
    ),

    -- Calculatate new mean and std. dev. without outliers
    final as (
        select
            avg(transaction_amount) as avg_wo_outliers,
            stddev(transaction_amount) as std_wo_outliers
        from transactions_z_score
        where z_score between -3 and 3  -- Remove outliers below -3 and above 3 z-score
    )

select *
from final
