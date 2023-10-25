{{ config(alias="subtransactions") }}

select
    id as subtransaction_id,
    transaction_id,
    {{ amounts_to_dollars("amount") }},
    category_id,
    category_name,
    payee_id,
    payee_name,
    nullif(memo, '') as memo,  -- Null empty memos
    deleted,
    transfer_transaction_id,
    transfer_account_id
from {{ source("raw", "subtransactions") }}
