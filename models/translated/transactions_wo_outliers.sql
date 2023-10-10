{{ config(alias = 'transactions_wo_outliers') }}

-- Flip sign of main transaction amount
WITH
    transactions AS (
        SELECT
            (
                amount * -1
            ) AS amount
        FROM
            {{ ref("transactions_translated") }}
    ),

    -- Calculate z-score: (amount - mean(amount)) / stddev(amount)
    transactions_z_score AS (
        SELECT
            amount,
            ((amount - (AVG(amount) over ())) / (STDDEV_POP(amount) over ())) AS z_score
        FROM
            transactions
    )

-- Calculatate new mean and std. dev. without outliers
SELECT
    AVG(amount) AS avg_wo_outliers,
    STDDEV(amount) AS std_wo_outliers
FROM
    transactions_z_score
WHERE
    -3 > z_score
    OR z_score < 3 -- Remove outliers below -3 and above 3 z-score
