{% macro concat_columns(columns) %}
    {% for column in columns %}
        {% if not loop.first %} || ' - ' || {%- endif -%} {{ column }}
    {% endfor %}
{% endmacro %}
