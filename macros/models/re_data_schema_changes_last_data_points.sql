{% macro re_data_schema_changes_last_data_points() -%}

    {{ adapter.dispatch('re_data_schema_changes_last_data_points', 're_data') () }}

{%- endmacro %}

{% macro default__re_data_schema_changes_last_data_points() %}
    select
        distinct detected_time
    from {{ ref('re_data_columns_over_time') }}
    order by
    detected_time desc limit 2;
{% endmacro %}