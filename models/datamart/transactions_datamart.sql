{{ config(alias="transactions") }}

-- Transactions Translated
with
    transactions as (select * from {{ ref("transactions_translated") }}),

    -- Categories
    categories as (
        select category_id, category_group_name from {{ ref("categories_staged") }}
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
    account_name,
    payee_name,
    memo,
    transfer_transaction_id,
    matched_transaction_id,
    subtransaction_flag
from transactions
left join categories using (category_id)
