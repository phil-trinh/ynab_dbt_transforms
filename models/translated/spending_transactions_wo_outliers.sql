{{ config(alias="spending_transactions_wo_outliers") }}

-- Select only transaction amounts
with
    transactions as (select amount from {{ ref("spending_transactions_datamart") }}),

    -- Calculate z-scores: (amount - mean(amount)) / stddev(amount)
    transactions_z_score as (
        select
            amount,
            ((amount - (avg(amount) over ())) / (stddev_pop(amount) over ())) as z_score
        from transactions
    )

-- Calculatate new mean and std. dev. without outliers
select avg(amount) as avg_wo_outliers, stddev(amount) as std_wo_outliers
from transactions_z_score
where -3 > z_score or z_score < 3  -- Remove outliers below -3 and above 3 z-score
