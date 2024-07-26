---
layout: default
---

{% assign tag = "dsat" %}
{% assign tagged_posts = "" | split: "" %}
{% for post in site.posts %}
  {% if post.tags contains tag %}
    {% assign tagged_posts = tagged_posts | push: post %}
  {% endif %}
{% endfor %}


<h1>{{ tag }} Posts</h1>

{% for post in tagged_posts %}
  {{ post.title }}
{% endfor %}

