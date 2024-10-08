{{
    config(
        materialized='view'
    )
}}
select
    z.id,
    z.table_name,
    z.column_name,
    z.metric,
    z.z_score_value,
    z.modified_z_score_value,
    m.anomaly_detector,
    z.last_value,
    z.last_avg,
    z.last_median,
    z.last_stddev,
    z.last_median_absolute_deviation,
    z.last_mean_absolute_deviation,
    z.last_iqr,
    z.last_first_quartile - (cast( {{ json_extract('m.anomaly_detector', 'whisker_boundary_multiplier') }} as {{numeric_type()}} ) * z.last_iqr) lower_bound,
    z.last_third_quartile + (cast( {{ json_extract('m.anomaly_detector', 'whisker_boundary_multiplier') }} as {{numeric_type()}} ) * z.last_iqr) upper_bound,
    z.last_first_quartile,
    z.last_third_quartile,
    z.time_window_end,
    z.interval_length_sec,
    z.computed_on,
    {{ re_data.generate_anomaly_message('z.column_name', 'z.metric', 'z.last_value', 'z.last_avg') }} as message,
    {{ re_data.generate_metric_value_text('z.metric', 'z.last_value') }} as last_value_text
from
    {{ ref('re_data_z_score')}} z 
left join {{ ref('re_data_selected') }} m 
on {{ split_and_return_nth_value('table_name', '.', 1) }} = m.{{quote_column_name('database') }}
and {{ split_and_return_nth_value('table_name', '.', 2) }} = m.{{quote_column_name('schema') }}
and {{ split_and_return_nth_value('table_name', '.', 3) }} = m.{{quote_column_name('name') }}
where
    case when (lower(coalesce({{ json_extract('m.anomaly_detector', 'direction') }}, 'both')) = 'up' and z.last_value > z.last_avg)
        or (lower(coalesce({{ json_extract('m.anomaly_detector', 'direction') }}, 'both')) = 'down' and z.last_value < z.last_avg)
        or (lower(coalesce({{ json_extract('m.anomaly_detector', 'direction') }}, 'both')) != 'up' and lower(coalesce({{ json_extract('m.anomaly_detector', 'direction') }}, 'both')) != 'down')
        then
            case 
                when {{ json_extract('m.anomaly_detector', 'name') }} = 'z_score'
                    then
                    case 
                        when abs(z_score_value) > cast({{ json_extract('m.anomaly_detector', 'threshold') }} as {{ numeric_type() }})
                        then cast('true' as {{ re_data.boolean_type() }})
                        else cast('false' as {{ re_data.boolean_type() }})
                    end
                when {{ json_extract('m.anomaly_detector', 'name') }} = 'modified_z_score' 
                    then 
                    case 
                        when abs(modified_z_score_value) > cast( {{ json_extract('m.anomaly_detector', 'threshold') }} as {{numeric_type()}} )
                        then cast('true' as {{ re_data.boolean_type() }})
                        else cast('false' as {{ re_data.boolean_type() }})
                    end
                when {{ json_extract('m.anomaly_detector', 'name') }} = 'boxplot' 
                    then 
                    case 
                        when
                            (
                                z.last_value < z.last_first_quartile - (cast( {{ json_extract('m.anomaly_detector', 'whisker_boundary_multiplier') }} as {{numeric_type()}} ) * z.last_iqr)
                                or 
                                z.last_value > z.last_third_quartile + (cast( {{ json_extract('m.anomaly_detector', 'whisker_boundary_multiplier') }} as {{numeric_type()}} ) * z.last_iqr)
                            )
                        then cast('true' as {{ re_data.boolean_type() }})
                        else cast('false' as {{ re_data.boolean_type() }})
                    end
                else cast('false' as {{ re_data.boolean_type() }})
            end
        else cast('false' as {{ re_data.boolean_type() }})
    end = cast('true' as {{ re_data.boolean_type() }})
