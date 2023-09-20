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
    transaction_id,
    subtransaction_id,
    date,
    amount,
    category_group_name,
    category_name,
    account_name,
    payee_name,
    memo,
    transfer_account_id,
    transfer_transaction_id,
    matched_transaction_id,
    subtransaction_flag
FROM
    transactions
    LEFT JOIN
    categories USING(category_id)
