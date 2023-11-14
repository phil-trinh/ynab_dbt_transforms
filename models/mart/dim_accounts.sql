{{ config(alias="accounts") }}

with
    final as (
        select
            account_id,
            account_name,
            case
                when
                    account_type = 'Other Asset'
                    and account_name <> 'First Parallel Home'
                then 'Retirement'
                else account_type
            end as account_type,
            account_balance,
            account_uncleared_balance,
            account_cleared_balance,
            account_note,
            is_deleted,
            is_closed,
            is_on_budget,
            last_reconciled_at::timestamp with time zone as last_reconciled_at,
            transfer_payee_id,
            direct_import_linked,
            direct_import_in_error
        from {{ ref("stg_ynab__accounts") }}
        where is_deleted = false
        order by account_type, account_name
    )

select *
from final
