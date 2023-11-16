{% macro whole_to_percentage(whole_number_column) %}
    ({{ whole_number_column }} / 100)
{% endmacro %}
