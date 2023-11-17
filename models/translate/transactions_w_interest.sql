{{ config(alias="transactions_w_interest") }}

with
    -- Main transactions table
    transactions as (select * from {{ ref("transactions_translated") }}),

    student_loan_interest as (
        select * from {{ ref("stg_ynab__student_loan_interest") }}
    ),

    -- Union Transactions with Student Loan Interest as extra transactions missing
    final as (
        select *
        from transactions
        union
        select *
        from student_loan_interest
    )

select *
from final
