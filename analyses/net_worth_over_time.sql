-- Sum amounts, aggregated to monthly
with
    transactions as (
        select date_trunc('month', transaction_date) as transaction_date, sum(transaction_amount) as "sum"
        from {{ ref('fct_transactions') }}
        where account_name not in ('First Parallel Home', 'First Parallel Mortgage')
        group by date_trunc('month', transaction_date)
    ),

    -- Then run a cumulative sum over the monthly sums
    net_worth as (
        select
            transaction_date,
            sum("sum") over (
                order by transaction_date asc rows between unbounded preceding and current row
            ) as cum_amt
        from transactions
    ),

    -- Value change from the beginning of the period
    change_calculation as (
        select
            *,
            cum_amt - first_value(cum_amt) over () as change_in_net_worth
        from net_worth
    ),

    -- Percentage change from the beginning of the period
    percentage_calculation as (
        select
            *,
            change_in_net_worth / first_value(cum_amt) over () as net_worth_pct_change
        from change_calculation
    )

select * from percentage_calculation