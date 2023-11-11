{{ config(alias="accounts") }}

select
    account_id,
    account_name,
    case
        when account_type = 'Other Asset' and account_name <> 'First Parallel Home'
        then 'Retirement'
        else account_type
    end as account_type,
    balance,
    uncleared_balance,
    cleared_balance,
    note,
    deleted,
    closed,
    on_budget,
    last_reconciled_at::timestamp with time zone as last_reconciled_at,
    transfer_payee_id,
    direct_import_linked,
    direct_import_in_error
from {{ ref("stg_accounts") }}
where deleted = false
order by account_type, account_name
