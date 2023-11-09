-- Sum amounts, aggregated to monthly
with
    transactions as (
        select date_trunc('month', "date") as "date", sum(amount) as "sum"
        from {{ ref("fct_transactions") }}
        where account_name not in ('First Parallel Home', 'First Parallel Mortgage')
        group by date_trunc('month', "date")
    )

-- Then run a cumulative sum over the monthly sums
select
    date,
    sum("sum") over (
        order by date asc rows between unbounded preceding and current row
    ) as cum_amt
from transactions
