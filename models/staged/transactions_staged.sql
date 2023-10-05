{{ config(alias='transactions') }}

SELECT
    id AS transaction_id,
    to_date(date, 'yyyy-mm-dd') AS date,
    {{ amounts_to_dollars('amount') }},
    category_id,
    category_name,
    account_id,
    account_name,
    payee_id,
    payee_name,
    memo,
    cleared,
    approved,
    deleted,
    debt_transaction_type,
    import_payee_name,
    import_payee_name_original,
    import_id,
    transfer_account_id,
    transfer_transaction_id,
    matched_transaction_id
FROM {{ source('raw', 'transactions') }}
