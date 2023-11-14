{# Drop Account Debt tables that end up being blank from being dropped at the Airbyte ingestion #}
{{
    config(
        alias = "accounts",
        pre_hook = [
            "drop table if exists raw.accounts_debt_escrow_amounts cascade",
            "drop table if exists raw.accounts_debt_interest_rates cascade",
            "drop table if exists raw.accounts_debt_minimum_payments cascade",
        ],
    )
}}

with
    final as (
        select
            id as account_id,
            name as account_name,
            case
                when "type" = 'otherLiability'
                then 'Other Liability'
                when "type" = 'otherAsset'
                then 'Other Asset'
                when "type" = 'studentLoan'
                then 'Student Loan'
                when "type" = 'creditCard'
                then 'Credit Card'
                else initcap("type")
            end as account_type,
            {{ amounts_to_dollars("balance", "account_balance") }},
            {{ amounts_to_dollars("uncleared_balance", "account_uncleared_balance") }},
            {{ amounts_to_dollars("cleared_balance", "account_cleared_balance") }},
            nullif(note, '') as account_note,  -- Null empty notes
            deleted as is_deleted,
            closed as is_closed,
            on_budget as is_on_budget,
            (
                to_timestamp(
                    last_reconciled_at, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
                )::timestamp
                with time zone at time zone '+8'
            ) as last_reconciled_at,
            transfer_payee_id,
            direct_import_linked,
            direct_import_in_error
        from {{ source("raw", "accounts") }}
    )

select *
from final
