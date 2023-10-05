{{ config(alias='categories') }}

SELECT
    id AS category_id,
    name AS category_name,
    category_group_id,
    category_group_name,
    {{ amounts_to_dollars('activity') }},
    {{ amounts_to_dollars('budgeted') }},
    {{ amounts_to_dollars('balance') }},
    goal_type,
    {{ amounts_to_dollars('goal_target') }},
    goal_cadence,
    goal_cadence_frequency,
    goal_percentage_complete,
    {{ amounts_to_dollars('goal_overall_funded') }},
    {{ amounts_to_dollars('goal_overall_left') }},
    {{ amounts_to_dollars('goal_under_funded') }},
    goal_months_to_budget,
    goal_target_month,
    goal_creation_month,
    note,
    deleted,
    hidden
FROM {{ source('raw', 'categories_categories') }}
