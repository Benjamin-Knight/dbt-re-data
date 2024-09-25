
{% macro bool_to_string(column) -%}

    {{ adapter.dispatch('bool_to_string','re_data') (column) }}

{%- endmacro %}

{% macro default__bool_to_string(column) %}
    (
    case when {{ column }} = true then 'true'
         when {{ column }} = false then 'false'
    end
    ) as {{ column }}
{% endmacro %}