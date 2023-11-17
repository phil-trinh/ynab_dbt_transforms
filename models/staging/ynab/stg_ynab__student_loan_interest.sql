{{ config(alias="student_loan_interest") }}

with
    final as (
        select
            md5("date"::text) as transaction_id,
            md5("date"::text) as original_transaction_id,
            null as subtransaction_id,
            "date" as transaction_date,
            interest_amount * -1 as transaction_amount,  -- Reverse sign to align with transactions
            'bdb8b767-61eb-4e3c-8635-e51fa29f8db3' as category_id,
            'Uncategorized' as category_name,
            '451b473b-b283-43ac-90ce-89cc58776190' as account_id,
            'Student Loan' as account_name,
            'MOHELA' as payee_name,
            null as transaction_memo,
            null as transfer_account_id,
            null as transfer_transaction_id,
            null as matched_transaction_id,
            false as subtransaction_flag
        from {{ ref('student_loan_interest') }}
    )

select *
from final
