-- Sum amounts, aggregated to monthly
with
    transactions as (
        select
            date_trunc('month', transaction_date) as transaction_date,
            sum(transaction_amount) as transaction_sum
        from {{ ref('fct_transactions') }}
        where account_name not in ('First Parallel Home', 'First Parallel Mortgage')
        group by 1
    ),

    -- Then run a cumulative sum over the monthly sums
    cumulative_calculation as (
        select
            transaction_date,
            {{ cumulative_sum('transaction_sum', 'transaction_date')}} as net_worth
        from transactions
    ),

    change_calculation as (
        select
            *,
            net_worth - first_value(net_worth) over () as change_in_net_worth
        from cumulative_calculation
    ),

    percentage_calculation as (
        select
            *,
            change_in_net_worth / first_value(net_worth) over () as net_worth_pct_change
        from change_calculation
    )

select * from percentage_calculation