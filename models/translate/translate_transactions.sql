{{ config(alias="transactions") }}

-- Main transactions table
with
    transactions as (
        select
            transaction_id,
            date,
            amount,
            category_id,
            category_name,
            payee_name,
            account_name,
            debt_transaction_type,
            memo,
            transfer_account_id,
            transfer_transaction_id,
            matched_transaction_id
        from {{ ref("stg_transactions") }}
        where
            approved = true  -- Only approved transactions (i.e. no pending)
            and deleted = false  -- Only non-deleted transactions
    ),

    -- Subtransactions that were split from main transactions
    subtransactions as (
        select
            subtransaction_id,
            transaction_id,
            amount,
            category_id,
            category_name,
            payee_name,
            memo,
            transfer_account_id,
            transfer_transaction_id
        from {{ ref("stg_subtransactions") }}
        where deleted = false  -- Only non-deleted transactions
    )

-- Join Transactions with Subtransactions and coalesce common columns
select
    case
        when subtransaction_id is not null
        then concat_ws('_', transactions.transaction_id, subtransaction_id)
        else transactions.transaction_id
    end as id,
    transactions.transaction_id as original_transaction_id,
    subtransaction_id,
    transactions.date,
    coalesce(subtransactions.amount, transactions.amount) as amount,
    coalesce(
        subtransactions.category_id, transactions.category_id
    ) as category_id,
    coalesce(
        subtransactions.category_name, transactions.category_name
    ) as category_name,
    account_name,
    coalesce(subtransactions.payee_name, transactions.payee_name) as payee_name,
    coalesce(subtransactions.memo, transactions.memo) as memo,
    coalesce(
        subtransactions.transfer_account_id, transactions.transfer_account_id
    ) as transfer_account_id,
    coalesce(
        subtransactions.transfer_transaction_id,
        transactions.transfer_transaction_id
    ) as transfer_transaction_id,
    matched_transaction_id,
    case
        when subtransaction_id is not null then true else false
    end as subtransaction_flag  -- Boolean if transaction came from a subtransaction
from transactions
full outer join
    subtransactions
    on transactions.transaction_id = subtransactions.transaction_id
