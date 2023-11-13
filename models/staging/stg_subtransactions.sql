{{ config(alias="subtransactions") }}

select
    id as subtransaction_id,
    transaction_id,
    {{ amounts_to_dollars("amount", "transaction_amount") }},
    category_id,
    category_name,
    payee_id,
    payee_name,
    nullif(memo, '') as transaction_memo,  -- Null empty memos
    deleted as is_deleted,
    transfer_transaction_id,
    transfer_account_id
from {{ source("raw", "subtransactions") }}
