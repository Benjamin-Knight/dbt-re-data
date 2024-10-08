
{% macro re_data_metric_max(context) %}
    max({{context.column_name}})
{% endmacro %}

{% macro re_data_metric_min(context) %}
    min({{context.column_name}})
{% endmacro %}

{% macro re_data_metric_avg(context) %}
    avg(cast ({{context.column_name}} as {{ numeric_type() }}))
{% endmacro %}

{% macro re_data_metric_stddev(context) %}
    {% set innerText %}cast({{context.column_name}} as {{ numeric_type() }}){% endset %}
    {{ standard_deviation(innerText) }}
{% endmacro %}

{% macro re_data_metric_variance(context) %}
    {% set innerText %}cast( {{context.column_name}} as {{ numeric_type() }}){% endset %}
    {{ variance(innerText) }}
{% endmacro %}

{% macro re_data_metric_max_length(context) %}
    max({{column_length(context.column_name)}})
{% endmacro %}

{% macro re_data_metric_min_length(context) %}
    min({{column_length(context.column_name)}})
{% endmacro %}

{% macro re_data_metric_avg_length(context) %}
    avg(cast ({{column_length(context.column_name)}} as {{ numeric_type() }}))
{% endmacro %}

{% macro re_data_metric_nulls_count(context) %}
    coalesce(
        sum(
            case when {{context.column_name}} is null
                then 1
            else 0
            end
        ), 0
    )
{% endmacro %}

{% macro re_data_metric_missing_count(context) %}
    coalesce(
        sum(
            case 
            when {{context.column_name}} is null
                then 1
            when {{context.column_name}} = ''
                then 1
            else 0
            end
        ), 0
    )
{% endmacro %}

{% macro re_data_metric_nulls_percent(context) %}
    {{ percentage_formula(re_data_metric_nulls_count(context), re_data_metric_row_count()) }}
{% endmacro %}

{% macro re_data_metric_missing_percent(context) %}
    {{ percentage_formula(re_data_metric_missing_count(context), re_data_metric_row_count()) }}
{% endmacro %}

{% macro re_data_metric_count_true(context) %}
    COALESCE(
        SUM(
            CASE
                WHEN {{ context.column_name }} = CAST('TRUE' AS {{ boolean_type() }}) THEN 1
                ELSE 0
            END
        ),
        0
    )
{% endmacro %}

{% macro re_data_metric_count_false(context) %}
    COALESCE(
        SUM(
            CASE
                WHEN {{ context.column_name }} IS CAST('FALSE' AS {{ boolean_type() }}) THEN 1
                ELSE 0
            END
        ),
        0
    )
{% endmacro %}


