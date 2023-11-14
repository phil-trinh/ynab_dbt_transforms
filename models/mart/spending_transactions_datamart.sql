{{ config(alias="spending_transactions") }}

with
    final as (
        select
            transaction_id,
            original_transaction_id,
            subtransaction_id,
            transaction_date,
            (transaction_amount * -1) as transaction_amount,  -- Flip the sign for spend in positive
            category_group_name,
            category_name,
            account_name,
            account_type,
            payee_name,
            transaction_memo,
            transfer_transaction_id,
            matched_transaction_id,
            subtransaction_flag,
            transaction_type
        from {{ ref("fct_transactions") }}
        where
            -- Expense and mortgage payment transaction types only
            transaction_type in ('Expense', 'Mortgage Payment')

            and (
                transaction_memo not in (
                    'Federal Tax Payment 😕',
                    'For dad to borrow',
                    'Part 1 of dad’s repayment',
                    'Withdrawal of Roth IRA contributions for 2022'
                )
                or transaction_memo is null
            )
    )

select *
from final
