---
layout: default
---

<h1 class="page-heading">{{ tag }} posts</h1>

<ul class="post-list">
  {% for post in tagged_posts %}
    {% include post.html %}
  {% endfor %}
</ul>
