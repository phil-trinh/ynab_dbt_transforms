{{ config(alias='spending_transactions') }}

-- Flip the sign for spend in positive
SELECT
    id,
    original_transaction_id,
    subtransaction_id,
    date,
    (amount * -1) AS amount,
    category_group_name,
    category_name,
    account_name,
    payee_name,
    memo,
    transfer_transaction_id,
    matched_transaction_id,
    subtransaction_flag
FROM
    {{ ref("transactions_datamart") }}
WHERE
    category_name <> 'Inflow: Ready to Assign' -- Remove all inflow transactions
