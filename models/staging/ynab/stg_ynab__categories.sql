{{ config(alias="categories") }}

with
    final as (
        select
            id as category_id,
            name as category_name,
            category_group_id,
            category_group_name,
            {{ amounts_to_dollars("activity", "category_activity") }},
            {{ amounts_to_dollars("budgeted", "category_budgeted") }},
            {{ amounts_to_dollars("balance", "category_balance") }},
            goal_type as category_goal_type,
            {{ amounts_to_dollars("goal_target", "category_goal_target") }},
            goal_cadence as category_goal_cadence,
            goal_cadence_frequency as category_goal_cadence_frequency,
            goal_percentage_complete as category_goal_percentage_complete,
            {{ amounts_to_dollars("goal_overall_funded", "category_goal_overall_funded") }},
            {{ amounts_to_dollars("goal_overall_left", "category_goal_overall_left") }},
            {{ amounts_to_dollars("goal_under_funded", "category_goal_under_funded") }},
            goal_months_to_budget as category_goal_months_to_budget,
            goal_target_month as category_goal_target_month,
            goal_creation_month as category_goal_creation_month,
            nullif(note, '') as category_note,  -- Null empty notes
            deleted as is_deleted,
            hidden as is_hidden
        from {{ source("raw", "category_groups") }}
    )

select *
from final
