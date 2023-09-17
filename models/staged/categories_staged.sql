SELECT
    id AS category_id,
    name AS category_name,
    category_group_id,
    category_group_name,
    (activity / 1000) AS activity,
    (budgeted / 1000) AS budgeted,
    (balance / 1000) AS balance,
    goal_type,
    (goal_target / 1000) AS goal_target,
    goal_cadence,
    goal_cadence_frequency,
    goal_percentage_complete,
    (goal_overall_funded / 1000) AS goal_overall_funded,
    (goal_overall_left / 1000) AS goal_overall_left,
    (goal_under_funded / 1000) AS goal_under_funded,
    goal_months_to_budget,
    goal_target_month,
    goal_creation_month,
    note,
    deleted,
    hidden
FROM
    {{ source('ynab_budget', 'categories_data_category_groups_categories') }}
