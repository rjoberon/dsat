---
layout: default
---

{% assign tag = "coordinates" %}
{% assign tagged_posts = "" | split: "" %}
{% for post in site.posts %}
  {% if post.tags contains tag %}
    {% assign tagged_posts = tagged_posts | push: post %}
  {% endif %}
{% endfor %}


<h1 class="page-heading">posts tagged with <em>{{ tag }}</em> </h1>

<ul class="post-list">
  {% for post in tagged_posts %}
    {% include post.html %}
  {% endfor %}
</ul>

