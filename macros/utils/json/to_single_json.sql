{% macro to_json_string_value_or_null(column) -%}
    {{ adapter.dispatch('to_json_string_value_or_null','re_data') (column) }}
{%- endmacro %}

{% macro default__to_json_string_value_or_null(column) %}
    (
        case 
            when {{ column }} is null then 'null'
            else '"' ||
                regexp_replace(
                    replace(cast({{ column }} as {{ string_type() }}), '"', {{ escape_seq_for_json('"') }}),
                    '\n', {{ quote_new_line() }} {% if target.type in postgres_type_db() %}, 'g' {% endif %}
                ) || '"'
        end
    )
{% endmacro %}

{% macro to_single_json(columns) -%}
    {{ adapter.dispatch('to_single_json','re_data') (columns) }}
{%- endmacro %}

{% macro default__to_single_json(columns) %}
    '{' ||
    {%- for column in columns %}
        '"{{ column }}": ' ||
        {{ to_json_string_value_or_null(column) }}
        {%- if not loop.last %} || ',' || {%- endif %}
    {%- endfor %}
    || '}'
{% endmacro %}
