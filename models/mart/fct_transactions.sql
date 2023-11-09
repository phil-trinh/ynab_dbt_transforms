{{ config(alias="transactions") }}

with
    -- Transactions Translated
    transactions as (
        select * from {{ ref("translate_transactions") }}
    ),

    -- Categories
    categories as (
        select category_id, category_group_name from {{ ref("stg_categories") }}
    ),

    -- Accounts
    accounts as (
        select account_id, account_name, account_type from {{ ref("stg_accounts") }}
    )

-- Enrich transactions with main category groups
select
    id,
    original_transaction_id,
    subtransaction_id,
    date,
    amount,
    category_group_name,
    category_name,
    transactions.account_name,
    account_type,
    payee_name,
    memo,
    transfer_transaction_id,
    matched_transaction_id,
    subtransaction_flag,
    case
        -- Any inflow that is not a starting balance
        when (category_name like 'Inflow%') and (payee_name <> 'Starting Balance' or payee_name is null)
        then 'Income'

        -- Starting balance is not a type
        when (category_name like 'Inflow%') and (payee_name = 'Starting Balance')
        then 'NA'

        -- Mortgage payments
        when (payee_name like 'Transfer%') and (category_name = 'Uncategorized') and (account_type = 'Mortgage')
        then 'Mortgage Payment'

        -- Credit Card payments (minus balance transfers)
        when (payee_name like 'Transfer%') and (category_name = 'Uncategorized') and (account_type = 'Credit Card') and (memo is distinct from 'Balance Transfer')
        then 'Credit Card Payment'

        -- Transfers
        when (payee_name like 'Transfer%') and (category_name = 'Uncategorized') and (account_type <> 'Mortgage')
        then 'Transfer'

        -- All other transactions are expenses
        when not (category_name like 'Inflow%')
        then 'Expense'
    end as transaction_type
from transactions
left join categories using (category_id)
left join accounts using (account_id)
