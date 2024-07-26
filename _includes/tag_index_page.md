---
layout: default
---

<h1>{{ tag }} Posts</h1>

{% for post in tagged_posts %}
  {{ post.title }}
{% endfor %}
