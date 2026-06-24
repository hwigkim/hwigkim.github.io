---
layout: default
title: "Hwigkim"
subtitle: "Tibetology & Sinology"
---
<h2>최근 작성된 글</h2>

<!-- 1. JS 비활성화 시 노출되는 기존 정적 HTML (SEO 대응 및 하위 호환) -->
<ul id="static-posts-list">
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a> &mdash; {{ post.date | date: "%Y년 %m월 %d일" }}
    </li>
  {% else %}
    <li>아직 작성된 글이 없습니다.</li>
  {% endfor %}
</ul>

<!-- 2. JS 활성화 시 동적으로 필터링 렌더링될 컨테이너 -->
<div id="dynamic-posts-container"></div>
