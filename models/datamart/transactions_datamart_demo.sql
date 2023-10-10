{{ config(alias = 'transactions_demo') }}

WITH -- Transactions Translated
transactions AS (
    SELECT
        *
    FROM
        {{ ref("transactions_datamart") }}
),

-- Mean & Std. Dev. of transaction amounts without outliers
transactions_minus_outliers_stats AS (
    SELECT
        *
    FROM
        {{ ref("transactions_wo_outliers") }}
)

-- Cross Join to get outliers and mask all other personal values
SELECT
    id,
    date,

    -- New amount column, randomly picked based on current distribution
    ROUND(
        CAST(random_normal(avg_wo_outliers, std_wo_outliers) AS numeric),
        2
    ) AS amount,
    category_group_name,

    -- Alias personal category names
    (
        CASE
            -- Alias Subscriptions
            WHEN category_name IN (
                'Aspiration Bank',
                'Costco Membership',
                'Global Entry ✈️'
            ) THEN 'Subscription A'
            WHEN category_name IN (
                'HBO Max',
                'Hulu',
                'iCloud',
                'Netflix'
            ) THEN 'Subscription B'
            WHEN category_name IN (
                'Nintendo Online',
                'Patreon',
                'Phone Service 📱',
                'Ring Insurance 💍'
            ) THEN 'Subscription C'
            WHEN category_name IN (
                'Sapphire Reserve CC',
                'Term Life Insurance',
                'YNAB'
            ) THEN 'Subscription C'
            
            -- Alias family related
            WHEN category_name IN (
                'Parallel',
                'Little Human 👶',
                '529 Fund'
            ) THEN 'Gifts for Family'
            
            -- Alias Home related
            WHEN category_name IN ('HOA') THEN 'Utilities 💡'
            ELSE category_name
        END
    ) AS category_name,

    -- Alias personal account names
    (
        CASE
            -- Alias Credit Cards
            WHEN account_name IN (
                'Blue Cash Everyday',
                'Freedom'
            ) THEN 'Credit Card A'
            WHEN account_name IN (
                'Unlimited',
                'Sapphire'
            ) THEN 'Credit Card B'
            WHEN account_name = 'Double Cash' THEN 'Credit Card C'

            -- Alias bank accounts
            WHEN account_name = 'Cash Account' THEN 'Checking'
            WHEN account_name IN (
                'Aspiration Save',
                'Aspiration Spend'
            ) THEN 'Savings'
            WHEN account_name = 'Venmo Cash' THEN 'Cash'
            ELSE account_name
        END
    ) AS account_name,

    -- Alias personal payee names
    (
        CASE
            -- Randomly generated company names form https://namelix.com/app/
            (RANDOM() * 10) :: INT
            WHEN 0 THEN 'Fracture Finance'
            WHEN 1 THEN 'Trendwave'
            WHEN 2 THEN 'UtilityFunds'
            WHEN 3 THEN 'Partisan Goods'
            WHEN 4 THEN 'SNAPfinance'
            WHEN 5 THEN 'EZFOOD'
            WHEN 6 THEN 'RetailWise'
            WHEN 7 THEN 'Subscription Lux'
            WHEN 8 THEN 'Electronics Edge'
            WHEN 9 THEN 'Commerce Hub'
            WHEN 10 THEN 'Eateria'END
    ) AS payee_name
FROM
    transactions
    CROSS JOIN transactions_minus_outliers_stats
