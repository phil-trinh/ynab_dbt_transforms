-- Net worth is the sum of all balances
(
    select sum(balance) as net_worth
    from {{ ref("dim_accounts") }}
    where (name not in ('First Parallel Home', 'First Parallel Mortgage'))
)

cross join

-- Breakout liabilities with negative balances
(
    select sum(balance) as liabilities
    from {{ ref("dim_accounts") }}
    where
        (name not in ('First Parallel Home', 'First Parallel Mortgage'))
        and (balance <= 0)
)

cross join

-- Breakout assets with positive balances
(
    select sum(balance) as assets
    from {{ ref("dim_accounts") }}
    where
        (name not in ('First Parallel Home', 'First Parallel Mortgage'))
        and (balance > 0)
)
