{% extends "section.md" %}

{% block body %}
<table class="table table-hover">
{% for item in items %}
<tr>
  <td>
    <a href="{{ item.repo_url }}">{{ item.name }}</a> |
    {% if item.removed %}
      <span class="text-danger"><i class="fa fas fa-ban"></i> removed</span> |
    {% else %}
      <i class="fa fas fa-star"></i> {{ item.stars }} |
    {% endif %}
    <em>{{ item.desc }}</em>
  </td>
  <td class='col-md-2' style='text-align:right;'>{{ item.year }}</td>
</tr>
{% endfor %}
</table>
{% endblock body %}
