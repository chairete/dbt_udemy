{% macro get_season(date_string)%}
CASE WHEN MONTH(TO_TIMESTAMP({{date_string}})) IN (12, 1, 2) THEN 'WINTER'
     WHEN MONTH(TO_TIMESTAMP({{date_string}})) IN (3, 4, 5) THEN 'SPRING'
     WHEN MONTH(TO_TIMESTAMP({{date_string}})) IN (6, 7, 8) THEN 'SUMMER'
     ELSE 'AUTUMN'
END
{% endmacro %}


{% macro day_type(date_string) %}
CASE WHEN DAYNAME(TO_TIMESTAMP({{date_string}})) IN ('Saturday', 'Sunday') THEN 'WEEKEND'
     ELSE 'BUSINESSDAY'
END
{% endmacro %}