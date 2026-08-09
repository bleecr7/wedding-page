---
layout: default
title: Home
---

{% assign sections = site.sections | sort: "order" %}
{% for section in sections %}{{ section.content }}{% endfor %}