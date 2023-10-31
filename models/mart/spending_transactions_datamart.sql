{{ config(alias="spending_transactions") }}

-- Flip the sign for spend in positive
select
    id,
    original_transaction_id,
    subtransaction_id,
    date,
    (amount * -1) as amount,
    category_group_name,
    category_name,
    account_name,
    payee_name,
    memo,
    transfer_transaction_id,
    matched_transaction_id,
    subtransaction_flag
from {{ ref("fct_transactions") }}
where
    -- Remove all starting balance transactions (https://wiki.postgresql.org/wiki/Is_distinct_from)
    payee_name is distinct from 'Starting Balance'

    -- Remove all inflow transactions
    and category_name <> 'Inflow: Ready to Assign'

    -- Remove transfer transactions
    and not (
        payee_name like 'Transfer%' and category_name = 'Uncategorized'
    )

    -- Remove savings, investment, and debt accounts as transactions from these
    -- accounts shouldn't be counted.
    and account_name not in (
        'Automated Emergency Fund',
        'Fidelity Investment Savings',
        'First Parallel Home',
        'First Parallel Mortgage',
        'Investment Savings',
        'LMI 401k',
        'LMI 403(b)',
        'LMI HSA',
        'Roth IRA',
        'Roth IRA - Vanguard',
        'Seagate 401k',
        'Seagate HSA',
        'Student Loan',
        'Student Loan (Original)'
    )
