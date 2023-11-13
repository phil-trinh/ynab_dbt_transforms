{{ config(alias="spending_transactions_demo") }}

with  -- Transactions Translated
    transactions as (select * from {{ ref("spending_transactions_datamart") }}),

    -- Mean & Std. Dev. of transaction amounts without outliers
    transactions_minus_outliers_stats as (
        select * from {{ ref("spending_transactions_wo_outliers") }}
    )

-- Cross Join to get outliers and mask all other personal values
select
    transaction_id,
    transaction_date,

    -- New amount column, randomly picked based on current distribution
    round(cast(random_normal(avg_wo_outliers, std_wo_outliers) as numeric), 2)::float
    as transaction_amount,
    category_group_name,

    -- Alias personal category names
    (
        case
            -- Alias Subscriptions
            when
                category_name
                in ('Aspiration Bank', 'Costco Membership', 'Global Entry ✈️')
            then 'Subscription A'
            when category_name in ('HBO Max', 'Hulu', 'iCloud', 'Netflix')
            then 'Subscription B'
            when
                category_name
                in ('Nintendo Online', 'Patreon', 'Phone Service 📱', 'Ring Insurance 💍')
            then 'Subscription C'
            when category_name in ('Sapphire Reserve CC', 'Term Life Insurance', 'YNAB')
            then 'Subscription C'

            -- Alias family related
            when category_name in ('Parallel', 'Little Human 👶', '529 Fund')
            then 'Gifts for Family'

            -- Alias Home related
            when category_name in ('HOA')
            then 'Utilities 💡'
            else category_name
        end
    ) as category_name,

    -- Alias personal account names
    (
        case
            -- Alias Credit Cards
            when account_name in ('Blue Cash Everyday', 'Freedom')
            then 'Credit Card A'
            when account_name in ('Unlimited', 'Sapphire')
            then 'Credit Card B'
            when account_name = 'Double Cash'
            then 'Credit Card C'

            -- Alias bank accounts
            when account_name = 'Cash Account'
            then 'Checking'
            when account_name in ('Aspiration Save', 'Aspiration Spend')
            then 'Savings'
            when account_name = 'Venmo Cash'
            then 'Cash'
            else account_name
        end
    ) as account_name,

    -- Alias personal payee names
    (
        case
            -- Randomly generated company names form https://namelix.com/app/
            (random() * 10)::int
            when 0
            then 'Fracture Finance'
            when 1
            then 'Trendwave'
            when 2
            then 'UtilityFunds'
            when 3
            then 'Partisan Goods'
            when 4
            then 'SNAPfinance'
            when 5
            then 'EZFOOD'
            when 6
            then 'RetailWise'
            when 7
            then 'Subscription Lux'
            when 8
            then 'Electronics Edge'
            when 9
            then 'Commerce Hub'
            when 10
            then 'Eateria'
        end
    ) as payee_name
from transactions
cross join transactions_minus_outliers_stats
