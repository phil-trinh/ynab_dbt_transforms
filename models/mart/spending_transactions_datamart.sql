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
    account_type,
    payee_name,
    memo,
    transfer_transaction_id,
    matched_transaction_id,
    subtransaction_flag,
    transaction_type
from {{ ref("fct_transactions") }}
where
    -- Expense transaction types only
    transaction_type = 'Expense'

    and memo not in (
        'Federal Tax Payment 😕',
        'For dad to borrow',
        'Part 1 of dad’s repayment',
        'Withdrawal of Roth IRA contributions for 2022'
    )
