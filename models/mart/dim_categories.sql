{{ config(alias="categories") }}

with
    final as (
        select
            category_id,
            category_name,
            category_group_id,
            category_group_name,
            category_note,
            category_activity,
            category_budgeted,
            category_balance,
            category_goal_type,
            category_goal_target,
            category_goal_cadence,
            category_goal_cadence_frequency,
            category_goal_percentage_complete,
            category_goal_overall_funded,
            category_goal_overall_left,
            category_goal_under_funded,
            category_goal_months_to_budget,
            category_goal_target_month,
            category_goal_creation_month,
            is_hidden
        from {{ ref("stg_ynab__categories") }}
        where is_deleted = false
        order by category_group_name, category_name
    )

select *
from final
