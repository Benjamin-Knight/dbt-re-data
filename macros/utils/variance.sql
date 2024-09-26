{% macro variance(column_name) %}
    {{ adapter.dispatch('variance', 're_data')(column_name) }}
{% endmacro %}

{% macro default__variance(column_name) %}
    variance({{column_name}})
{% endmacro %}