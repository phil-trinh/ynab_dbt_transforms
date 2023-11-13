{{ config(alias="transactions") }}

with
    -- Transactions Translated
    transactions as (select * from {{ ref("translate_transactions") }}),

    -- Categories
    categories as (
        select category_id, category_group_name from {{ ref("stg_categories") }}
    ),

    -- Main Accounts
    accounts as (select account_id, account_type from {{ ref("dim_accounts") }}),

    -- Transfer Accounts
    transfer_accounts as (
        select
            account_id as transfer_account_id,
            account_name as transfer_account_name,
            account_type as transfer_account_type
        from {{ ref("dim_accounts") }}
    ),

    -- Enrich transactions with main category groups
    enriched_transactions as (
        select
            transaction_id,
            original_transaction_id,
            subtransaction_id,
            transaction_date,
            transaction_amount,
            category_group_name,
            category_name,
            account_name,
            account_type,
            payee_name,
            transaction_memo,
            transactions.transfer_account_id,
            transfer_account_name,
            transfer_account_type,
            transfer_transaction_id,
            matched_transaction_id,
            subtransaction_flag
        from transactions
        left join categories using (category_id)
        left join accounts using (account_id)
        left join transfer_accounts using (transfer_account_id)
    ),

    final as (
        select
            *,
            case
                -- Any inflow that is not a starting balance
                when
                    (category_name like 'Inflow%')
                    and (payee_name <> 'Starting Balance' or payee_name is null)
                then 'Income'

                -- Mortgage payments
                when transfer_account_type = 'Mortgage'
                then 'Mortgage Payment'

                -- Credit Card payments (minus balance transfers)
                when
                    (transfer_account_type = 'Credit Card')
                    and not (account_type = 'Credit Card')
                then 'Credit Card Payment'

                -- Retirement Savings transfers
                when
                    (transfer_account_type = 'Retirement')
                    or (account_type = 'Retirement')
                then 'Retirement Savings'

                -- All other Transfers
                when transfer_account_id is not null
                then 'Transfer'

                -- Starting balance or other Mortgage transactions are N/A types
                when
                    (payee_name = 'Starting Balance')
                    or (account_type in ('Mortgage', 'Other Liability', 'Other Asset'))
                then 'NA'

                -- All other transactions are expenses
                when not (category_name like 'Inflow%')
                then 'Expense'

            -- No else case to make sure we catch any other types that we didn't
            -- account for.
            end as transaction_type
        from enriched_transactions
    )

select *
from final
