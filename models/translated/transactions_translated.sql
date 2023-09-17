-- Main transactions table
WITH transactions AS (
    SELECT
        transaction_id,
        DATE,
        amount,
        category_name,
        payee_name,
        account_name,
        debt_transaction_type,
        memo,
        transfer_account_id,
        transfer_transaction_id,
        matched_transaction_id
    FROM
        {{ ref("transactions_staged") }}
    WHERE
        payee_name <> 'Starting Balance' -- Remove all starting balance transactions
        AND category_name <> 'Inflow: Ready to Assign' -- Remove all inflow transactions
        AND approved = TRUE -- Only approved transactions (i.e. no pending)
        AND deleted = FALSE -- Only non-deleted transactions
),

-- Subtransactions that were split from main transactions
subtransactions AS (
    SELECT
        subtransaction_id,
        transaction_id,
        amount,
        category_name,
        payee_name,
        memo,
        transfer_account_id,
        transfer_transaction_id
    FROM
        "staged"."subtransactions_staged"
    WHERE
        deleted = FALSE -- Only non-deleted transactions
),

-- Join Transactions with Subtransactions and coalesce common columns
transactions_joined AS (
    SELECT
        COALESCE(
            subtransactions.transaction_id,
            transactions.transaction_id
        ) AS transaction_id,
        subtransaction_id,
        transactions.date,
        COALESCE(
            subtransactions.amount,
            transactions.amount
        ) AS amount,
        COALESCE(
            subtransactions.category_name,
            transactions.category_name
        ) AS category_name,
        account_name,
        COALESCE(
            subtransactions.payee_name,
            transactions.payee_name
        ) AS payee_name,
        COALESCE(
            subtransactions.memo,
            transactions.memo
        ) AS memo,
        COALESCE(
            subtransactions.transfer_account_id,
            transactions.transfer_account_id
        ) AS transfer_account_id,
        COALESCE(
            subtransactions.transfer_transaction_id,
            transactions.transfer_transaction_id
        ) AS transfer_transaction_id,
        matched_transaction_id,
        CASE
            WHEN subtransaction_id IS NOT NULL THEN TRUE
            ELSE FALSE
        END AS subtransaction_flag -- Boolean if transaction came from a subtransaction
    FROM
        transactions
        FULL OUTER JOIN subtransactions
        ON transactions.transaction_id = subtransactions.transaction_id
    WHERE
        -- Remove savings, investment, and debt accounts as transactions from these
        -- accounts shouldn't be counted.
        account_name NOT IN (
            'Automated Emergency Fund',
            'Fidelity Investment Savings',
            'First Parallel Home',
            'First Parallel Mortgage',
            'Investment Savings',
            'LMI 401k',
            'LMI 403(b)',
            'LMI HSA',
            'Roth IRA',
            'Roth IRA - Vanguard',
            'Seagate 401k',
            'Seagate HSA',
            'Student Loan',
            'Student Loan (Original)'
        )
)

-- Final select
SELECT
    *
FROM
    transactions_joined
WHERE
    NOT (  -- Remove transfer transactions that were payments to credit cards
        payee_name LIKE 'Transfer%'
        AND category_name = 'Uncategorized'
    )

