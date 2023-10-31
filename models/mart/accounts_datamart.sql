{{ config(alias="accounts") }}

select
    id,
    name,
    type,
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
from {{ ref("accounts_staged") }}
where deleted = false
order by type, name
