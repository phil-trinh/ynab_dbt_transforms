{{ config(alias='transactions') }}

-- Transactions Translated
WITH transactions AS (
    SELECT
        *
    FROM
        {{ ref("transactions_translated") }}
),

-- Categories
categories AS (
    SELECT
        category_id,
        category_group_name
    FROM
        {{ ref("categories_staged") }}
)

-- Enrich transactions with main category groups
SELECT
    CASE
        WHEN subtransaction_id IS NOT NULL THEN CONCAT_WS('_', transaction_id, subtransaction_id)
        ELSE transaction_id
    END AS id,
    transaction_id AS original_transaction_id,
    subtransaction_id,
    date,
    (amount * -1) AS amount,  -- Flip the sign for spend in positive
    category_group_name,
    category_name,
    account_name,
    payee_name,
    memo,
    transfer_transaction_id,
    matched_transaction_id,
    subtransaction_flag
FROM
    transactions
    LEFT JOIN
    categories USING(category_id)
