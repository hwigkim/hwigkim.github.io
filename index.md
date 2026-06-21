---
layout: default
title: "Tufte & Pandoc Blog"
subtitle: "Jekyll, Pandoc, and Tufte CSS Sidenotes Integration"
---

Tufte CSS 기반 블로그에 오신 것을 환영합니다! 이 블로그는 Pandoc의 각주 기능을 사용하여 본문 우측 공간에 사이드노트(Sidenote)를 띄울 수 있도록 설계되었습니다.

## 최근 작성된 글

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a> &mdash; {{ post.date | date: "%Y년 %m월 %d일" }}
    </li>
  {% else %}
    <li>아직 작성된 글이 없습니다.</li>
  {% endfor %}
</ul>
