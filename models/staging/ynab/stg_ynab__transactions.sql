{{ config(alias="transactions") }}

with
    final as (
        select
            id as transaction_id,
            to_date(date, 'yyyy-mm-dd') as transaction_date,
            {{ amounts_to_dollars("amount") }} as transaction_amount,
            category_id,
            category_name,
            account_id,
            account_name,
            payee_id,
            payee_name,
            nullif(memo, '') as transaction_memo,  -- Null empty memos
            cleared as is_cleared,
            approved as is_approved,
            deleted as is_deleted,
            debt_transaction_type,
            import_payee_name,
            import_payee_name_original,
            import_id,
            transfer_account_id,
            transfer_transaction_id,
            matched_transaction_id
        from {{ source("raw", "transactions") }}
    )

select *
from final
