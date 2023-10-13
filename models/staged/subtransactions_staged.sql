{{ config(alias='subtransactions') }}

SELECT
    id AS subtransaction_id,
    transaction_id,
    {{ amounts_to_dollars('amount') }},
    category_id,
    category_name,
    payee_id,
    payee_name,
    NULLIF(memo, '') AS memo,  -- Null empty memos
    deleted,
    transfer_transaction_id,
    transfer_account_id
FROM {{ source('raw', 'subtransactions') }}
