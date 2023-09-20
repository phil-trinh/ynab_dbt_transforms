{{ config(alias='transactions') }}

SELECT
    id AS transaction_id,
    to_date(date, 'yyyy-mm-dd') AS date,
    (amount / 1000) AS amount,
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
    flag_color,
    import_payee_name,
    import_payee_name_original,
    import_id,
    transfer_account_id,
    transfer_transaction_id,
    matched_transaction_id
FROM {{ source('ynab_budget', 'transactions_data_transactions') }}
