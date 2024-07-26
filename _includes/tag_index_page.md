---
layout: default
---

<h1 class="page-heading">posts tagged with <em>{{ tag }}</em> </h1>

<ul class="post-list">
  {% for post in tagged_posts %}
    {% include post.html %}
  {% endfor %}
</ul>
