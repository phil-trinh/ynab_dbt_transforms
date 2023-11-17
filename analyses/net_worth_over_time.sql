with
    -- Sum amounts, aggregated to monthly
    transactions as (
        select
            date_trunc('month', transaction_date) as transaction_date,
            sum(transaction_amount) as transaction_sum
        from {{ ref("fct_transactions") }}
        where account_name not in ('First Parallel Home', 'First Parallel Mortgage')
        group by 1
    ),

    -- Cumulative sum over the monthly sums
    cumulative_calculation as (
        select
            transaction_date,
            {{ cumulative_sum("transaction_sum", "transaction_date") }} as net_worth
        from transactions
    ),

    -- Calculate absolute net worth change from beginning of period
    change_calculation as (
        select
            *,
            net_worth - first_value(net_worth) over () as change_in_net_worth
        from cumulative_calculation
    ),

    -- Calculate percetnage net worth change from beginning of period
    percentage_calculation as (
        select
            *,
            change_in_net_worth / first_value(net_worth) over () as net_worth_pct_change
        from change_calculation
    )

select *
from percentage_calculation
