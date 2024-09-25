{% macro standard_deviation(column_name) %}
    {{ adapter.dispatch('standard_deviation', 're_data')(column_name) }}
{% endmacro %}

{% macro default__standard_deviation(column_name) %}
    stddev({{column_name}})
{% endmacro %}