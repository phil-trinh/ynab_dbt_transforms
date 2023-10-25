{{ config(alias="accounts") }}

select
    id,
    name,
    type,
    {{ amounts_to_dollars("balance") }},
    {{ amounts_to_dollars("uncleared_balance") }},
    {{ amounts_to_dollars("cleared_balance") }},
    nullif(note, '') as note,  -- Null empty notes
    deleted,
    closed,
    on_budget,
    (
        to_timestamp(last_reconciled_at, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"')::timestamp
        with time zone at time zone '+8'
    ) as last_reconciled_at,
    transfer_payee_id,
    direct_import_linked,
    direct_import_in_error
from {{ source("raw", "accounts") }}
