{% macro column_length(column_name) %}
    {{ adapter.dispatch('column_length', 're_data')(column_name) }}
{% endmacro %}

{% macro default__column_length(column_name) %}
    length({{column_name}})
{% endmacro %}