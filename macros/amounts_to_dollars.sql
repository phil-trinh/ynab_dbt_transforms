{% macro amounts_to_dollars(amount_column_name, output_column=amount_column_name) %}
    ({{ amount_column_name }} / 1000) as {{ output_column }}
{% endmacro %}
