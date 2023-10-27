-- Net worth is the sum of all balances
(
    select sum(balance) as net_worth
    from {{ ref("accounts_datamart") }}
    where (name not in ('First Parallel Home', 'First Parallel Mortgage'))
)

cross join

-- Breakout liabilities with negative balances
(
    select sum(balance) as liabilities
    from {{ ref("accounts_datamart") }}
    where
        (name not in ('First Parallel Home', 'First Parallel Mortgage'))
        and (balance <= 0)
)

cross join

-- Breakout assets with positive balances
(
    select sum(balance) as assets
    from {{ ref("accounts_datamart") }}
    where
        (name not in ('First Parallel Home', 'First Parallel Mortgage'))
        and (balance > 0)
)
