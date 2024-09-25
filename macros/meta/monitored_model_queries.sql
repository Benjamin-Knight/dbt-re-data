{% macro get_tables() %}
    select *
    from {{ ref('re_data_selected') }}
    order by name, {{ quote_column_name('schema') }}, {{ quote_column_name('database') }}, time_filter
{% endmacro %}

{% macro get_schemas() %}
    select distinct {{ quote_column_name('schema') }}, {{ quote_column_name('database') }}
    from {{ ref('re_data_selected') }}
{% endmacro %}