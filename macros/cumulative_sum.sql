{%- macro cumulative_sum(numeric_column, date_time_column) -%}
    sum({{ numeric_column }}) over (
        order by {{ date_time_column }} asc rows between unbounded preceding and current row
    )
{%- endmacro -%}