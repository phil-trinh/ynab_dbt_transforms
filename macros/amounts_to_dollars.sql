{%- macro amounts_to_dollars(amount_column_name) -%}
    ({{ amount_column_name }} / 1000)
{%- endmacro -%}
