with transactions_translated as (
    select * from {{ source('ynab_budget', 'transactions_data_transactions') }}
)

select * from transactions_translated