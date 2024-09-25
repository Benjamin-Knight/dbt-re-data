
select 
    {{ quote_column_name('name') }}, 
    {{ quote_column_name('schema') }},
    {{ quote_column_name('database') }},
    {{ quote_column_name('time_filter') }},
    {{ quote_column_name('metrics') }},
    {{ quote_column_name('columns') }},
    {{ quote_column_name('anomaly_detector') }},
    {{ quote_column_name('owners') }}
from {{ ref('re_data_monitored')}}
where 
    selected = cast('true' AS {{ boolean_type() }})