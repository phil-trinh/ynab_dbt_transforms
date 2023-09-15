select
    id as subtransaction_id,
    transaction_id,
    (amount / 1000) as amount,
    category_id,
    category_name,
    payee_id,
    payee_name,
    memo,
    deleted,
    transfer_transaction_id,
    transfer_account_id
from {{ source('ynab_budget', 'transactions_data_tr__tions_subtransactions') }}
