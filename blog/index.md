---
layout: default
title: "Hwigkim"
subtitle: "Tibetology & Sinology"
---

<!-- 포스트 데이터를 JSON 형식으로 직렬화 (Jekyll 빌드 시 생성됨) -->
<script id="posts-data" type="application/json">
[
  {% for post in site.posts %}
  {
    "title": {{ post.title | jsonify }},
    "url": {{ post.url | relative_url | jsonify }},
    "date": {{ post.date | date: "%Y년 %m월 %d일" | jsonify }},
    "content": {{ post.content | strip_html | jsonify }}
  }{% unless forloop.last %},{% endunless %}
  {% endfor %}
]
</script>

<!-- 사이드바 및 레이아웃 커스텀 스타일 정의 -->
<style>
  /* 1. 레이아웃 변수 설정 */
  :root {
    --sidebar-width: 260px;
    --transition-speed: 0.4s;
    --transition-curve: cubic-bezier(0.16, 1, 0.3, 1);
  }

  /* 2. 바디 패딩 트랜지션 (PC용 화면 밀기 효과) */
  body {
    transition: padding-left var(--transition-speed) var(--transition-curve);
  }

  /* 3. 사이드바 스타일 (Tufte 스타일: 여백 기반, 장식 배제) */
  #sidebar {
    position: fixed;
    top: 0;
    left: 0;
    width: var(--sidebar-width);
    height: 100vh;
    background: #fffff8; /* Tufte CSS 기본 용지 색상 */
    border-right: 1px solid rgba(0, 0, 0, 0.08);
    transform: translateX(-100%);
    transition: transform var(--transition-speed) var(--transition-curve);
    z-index: 1000;
    display: flex;
    flex-direction: column;
    padding: 6.5rem 2rem 2rem 2rem;
    box-sizing: border-box;
    font-family: et-book, Palatino, "Palatino Linotype", Georgia, serif;
  }

  /* 사이드바 열림 상태 */
  body.sidebar-open #sidebar {
    transform: translateX(0);
  }

  /* 다크모드 대응 */
  @media (prefers-color-scheme: dark) {
    #sidebar {
      background: #151515; /* Tufte CSS 다크모드 용지 색상 */
      border-right: 1px solid rgba(255, 255, 255, 0.08);
    }
  }

  /* 4. 사이드바 헤더 및 제목 (Tufte 이탤릭 제목 스타일) */
  .sidebar-header {
    margin-bottom: 2rem;
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    padding-bottom: 0.5rem;
  }

  @media (prefers-color-scheme: dark) {
    .sidebar-header {
      border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    }
  }

  .sidebar-title {
    font-size: 1.5rem;
    font-weight: normal;
    font-style: italic;
    font-family: et-book, Palatino, Georgia, serif;
    margin: 0;
  }

  /* 5. 태그 리스트 & 아이템 (타이포그래피 집중, 백그라운드 상자 배제) */
  .tag-list {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: 0.8rem;
    overflow-y: auto;
    flex-grow: 1;
  }

  .tag-item {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    padding: 0.2rem 0;
    background: transparent;
    border: none;
    cursor: pointer;
    font-size: 1.2rem;
    font-family: et-book, Palatino, Georgia, serif;
    color: #444;
    text-align: left;
    width: 100%;
    transition: color 0.2s ease;
  }

  /* 호버 시 Tufte 특유의 하단 언더라인 링크 효과 적용 */
  .tag-item:hover {
    color: #111;
    background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 50%);
    background-size: 100% 1px;
    background-repeat: repeat-x;
    background-position: 0 95%;
  }

  /* 활성화(Active) 상태: 볼드 및 언더라인 유지 */
  .tag-item.active {
    font-weight: bold;
    color: #111;
  }

  .tag-item.active .tag-name {
    background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.8) 50%);
    background-size: 100% 2px;
    background-repeat: repeat-x;
    background-position: 0 95%;
  }

  /* 태그 빈도수 (이탤릭 숫자 스타일) */
  .tag-count {
    font-family: et-book, Palatino, Georgia, serif;
    font-style: italic;
    font-size: 1.1rem;
    color: #888;
    margin-left: 0.5rem;
  }

  .tag-item.active .tag-count {
    color: #111;
  }

  /* 다크모드 태그 스타일 */
  @media (prefers-color-scheme: dark) {
    .tag-item {
      color: #aaa;
    }
    .tag-item:hover {
      color: #fff;
      background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(255, 255, 255, 0.6) 50%);
    }
    .tag-item.active {
      color: #fff;
    }
    .tag-item.active .tag-name {
      background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(255, 255, 255, 0.8) 50%);
    }
    .tag-count {
      color: #666;
    }
    .tag-item.active .tag-count {
      color: #fff;
    }
  }

  /* 6. 모바일 오버레이 */
  #sidebar-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0, 0, 0, 0.15);
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s ease, visibility 0.3s ease;
    z-index: 999;
  }

  body.sidebar-open #sidebar-overlay {
    opacity: 1;
    visibility: visible;
  }

  /* 7. Tufte 스타일 메뉴 토글 버튼 (수학/학술 책의 캡션/기호 심볼화) */
  #sidebar-toggle-btn {
    position: fixed;
    left: 20px;
    top: 20px;
    background: #fffff8;
    border: 1px solid rgba(0, 0, 0, 0.15);
    border-radius: 4px;
    color: #111;
    font-family: et-book, Palatino, Georgia, serif;
    font-style: italic;
    font-size: 1.15rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.4rem;
    z-index: 1001;
    padding: 0.4rem 0.8rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    transition: all 0.2s ease;
  }

  #sidebar-toggle-btn:hover {
    border-color: #111;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }

  .toggle-icon {
    font-style: normal;
    font-weight: bold;
  }

  /* 다크모드 토글 버튼 */
  @media (prefers-color-scheme: dark) {
    #sidebar-toggle-btn {
      background: #151515;
      border: 1px solid rgba(255, 255, 255, 0.15);
      color: #ddd;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
    }
    #sidebar-toggle-btn:hover {
      border-color: #fff;
    }
  }

  /* 8. 포스트 리스트 스타일 */
  #dynamic-posts-container {
    display: none;
    margin-top: 2rem;
  }

  .post-item {
    opacity: 0;
    transform: translateY(10px);
    animation: slideUpIn 0.4s var(--transition-curve) forwards;
    margin-bottom: 2rem;
    padding-bottom: 1.5rem;
    border-bottom: 1px dashed rgba(0, 0, 0, 0.08);
  }

  @keyframes slideUpIn {
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .post-link {
    font-size: 1.6rem;
    font-weight: normal;
    color: inherit;
    text-decoration: none;
    /* Tufte CSS 고유의 기본 링크 언더라인 스타일 유지 */
    background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 50%);
    background-size: 100% 1px;
    background-repeat: repeat-x;
    background-position: 0 95%;
    transition: background-size 0.2s ease;
  }

  .post-link:hover {
    background-size: 100% 2px;
  }

  .post-meta {
    font-size: 1.1rem;
    color: #666;
    margin-top: 0.6rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.8rem;
    align-items: center;
  }

  .post-tags-list {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
  }

  /* Tufte 스타일 해시태그 뱃지 (상자 배제, 이탤릭 텍스트 링크 형태) */
  .post-tag-badge {
    font-family: et-book, Palatino, Georgia, serif;
    font-style: italic;
    font-size: 1.05rem;
    color: #666;
    cursor: pointer;
    transition: color 0.2s ease;
  }

  .post-tag-badge:hover {
    color: #111;
    background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(0, 0, 0, 0.6) 50%);
    background-size: 100% 1px;
    background-repeat: repeat-x;
    background-position: 0 95%;
  }

  /* 다크모드 포스트 리스트 */
  @media (prefers-color-scheme: dark) {
    .post-item {
      border-bottom: 1px dashed rgba(255, 255, 255, 0.08);
    }
    .post-link {
      background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(255, 255, 255, 0.6) 50%);
    }
    .post-meta {
      color: #888;
    }
    .post-tag-badge {
      color: #888;
    }
    .post-tag-badge:hover {
      color: #fff;
      background-image: linear-gradient(to bottom, rgba(0, 0, 0, 0) 50%, rgba(255, 255, 255, 0.6) 50%);
    }
  }

  /* 9. PC 레이아웃 미디어 쿼리 (화면 가로 1024px 이상) */
  @media (min-width: 1024px) {
    body.sidebar-open {
      padding-left: calc(12.5% + var(--sidebar-width));
    }
    
    #sidebar-overlay {
      display: none !important;
    }

    /* PC에서는 테두리 및 배경을 완전 투명화하여 책의 '좌측 여백 노트(Sidenote)'처럼 자연스럽게 융합 */
    #sidebar {
      background: transparent;
      border-right: none;
    }
  }
</style>

<!-- 레이아웃 요소 삽입 -->
<button id="sidebar-toggle-btn" aria-label="태그 목록 토글">
  <span class="toggle-icon">⊕</span>
  <span class="toggle-text">태그 목록</span>
</button>

<div id="sidebar-overlay"></div>

<aside id="sidebar">
  <div class="sidebar-header">
    <h3 class="sidebar-title">태그 목록</h3>
  </div>
  <ul class="tag-list" id="tag-list-container">
    <!-- 자바스크립트로 동적 생성됨 -->
  </ul>
</aside>


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


<!-- 데이터 처리 및 컴포넌트 동작 제어 스크립트 -->
<script>
(function() {
  // 1. DOM 요소 취득
  const staticList = document.getElementById('static-posts-list');
  const dynamicContainer = document.getElementById('dynamic-posts-container');
  const tagListContainer = document.getElementById('tag-list-container');
  const toggleBtn = document.getElementById('sidebar-toggle-btn');
  const overlay = document.getElementById('sidebar-overlay');
  
  // 2. 포스트 JSON 데이터 파싱
  let posts = [];
  try {
    posts = JSON.parse(document.getElementById('posts-data').textContent);
  } catch (e) {
    console.error("포스트 데이터를 파싱하지 못했습니다:", e);
    return;
  }

  // 3. 상태 관리 변수
  let activeTag = null; // null이면 '전체 보기'

  // 4. 태그 자동 식별 (정규표현식) 및 매핑 로직
  // 한글/영문/숫자/언더바 포함하며 첫 글자는 문자여야 함 (색상코드 #fff, #151515 등 배제)
  const tagRegex = /(?:^|\s)#([a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣_][a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣_]*)/g;
  const tagCounts = {};
  
  // 각 포스트 객체에 추출한 태그 배열 추가
  posts.forEach(post => {
    const content = post.content || "";
    const tags = [];
    let match;
    
    // 정규식을 리셋하여 재사용
    tagRegex.lastIndex = 0;
    while ((match = tagRegex.exec(content)) !== null) {
      const tag = match[1];
      if (!tags.includes(tag)) {
        tags.push(tag);
      }
    }
    
    post.tags = tags;
    
    // 태그 빈도수 계산
    tags.forEach(tag => {
      tagCounts[tag] = (tagCounts[tag] || 0) + 1;
    });
  });

  // 5. 사이드바 메뉴 렌더링 함수
  function renderSidebar() {
    tagListContainer.innerHTML = '';

    // '전체 보기' 버튼 생성
    const allItem = document.createElement('li');
    const isAllActive = !activeTag;
    allItem.innerHTML = `
      <button class="tag-item ${isAllActive ? 'active' : ''}" id="all-tags-item">
        <span class="tag-name">${isAllActive ? '→ 전체 보기' : '전체 보기'}</span>
        <span class="tag-count">${posts.length}</span>
      </button>
    `;
    allItem.querySelector('button').addEventListener('click', () => {
      selectTag(null);
      closeSidebarOnMobile();
    });
    tagListContainer.appendChild(allItem);

    // 식별된 개별 태그 목록 정렬 및 렌더링
    const sortedTags = Object.keys(tagCounts).sort((a, b) => tagCounts[b] - tagCounts[a]);
    
    sortedTags.forEach(tag => {
      const count = tagCounts[tag];
      const tagItem = document.createElement('li');
      const isActive = activeTag === tag;
      
      tagItem.innerHTML = `
        <button class="tag-item ${isActive ? 'active' : ''}">
          <span class="tag-name">${isActive ? '→ ' + tag : tag}</span>
          <span class="tag-count">${count}</span>
        </button>
      `;
      
      tagItem.querySelector('button').addEventListener('click', () => {
        selectTag(tag);
        closeSidebarOnMobile();
      });
      tagListContainer.appendChild(tagItem);
    });
  }

  // 6. 게시글 리스트 렌더링 함수 (필터링 적용 및 애니메이션)
  function renderPosts() {
    dynamicContainer.innerHTML = '';
    
    // 필터링 적용
    const filteredPosts = activeTag 
      ? posts.filter(post => post.tags && post.tags.includes(activeTag))
      : posts;

    if (filteredPosts.length === 0) {
      dynamicContainer.innerHTML = '<p>해당 태그의 글이 없습니다.</p>';
      return;
    }

    filteredPosts.forEach((post, index) => {
      const postCard = document.createElement('div');
      postCard.className = 'post-item';
      // 순차적 페이드인 애니메이션 딜레이 설정
      postCard.style.animationDelay = `${index * 0.05}s`;

      // 게시글 내 태그 뱃지 생성 (middot로 구분된 텍스트 형태)
      let tagsHTML = '';
      if (post.tags && post.tags.length > 0) {
        tagsHTML = `
          <div class="post-tags-list">
             &nbsp;&middot;&nbsp; 
            ${post.tags.map(t => `<span class="post-tag-badge">#${t}</span>`).join(' &middot; ')}
          </div>
        `;
      }

      postCard.innerHTML = `
        <a class="post-link" href="${post.url}">${post.title}</a>
        <div class="post-meta">
          <span>${post.date}</span>
          ${tagsHTML}
        </div>
      `;

      // 포스트 내부의 태그 뱃지 클릭 시에도 필터링 연동
      postCard.querySelectorAll('.post-tag-badge').forEach((badge, idx) => {
        badge.addEventListener('click', (e) => {
          e.preventDefault();
          e.stopPropagation();
          const clickedTag = post.tags[idx];
          selectTag(clickedTag);
        });
      });

      dynamicContainer.appendChild(postCard);
    });
  }

  // 7. 태그 선택 처리 함수
  function selectTag(tag) {
    activeTag = tag;
    renderSidebar();
    renderPosts();
  }

  // 8. 사이드바 동작 제어
  function toggleSidebar() {
    const isOpen = document.body.classList.toggle('sidebar-open');
    toggleBtn.classList.toggle('open', isOpen);
    const icon = toggleBtn.querySelector('.toggle-icon');
    if (icon) {
      icon.textContent = isOpen ? '⊖' : '⊕';
    }
  }

  // 모바일 환경(1024px 미만)에서만 태그 클릭 시 사이드바를 자동으로 닫음
  function closeSidebarOnMobile() {
    if (window.innerWidth < 1024) {
      document.body.classList.remove('sidebar-open');
      toggleBtn.classList.remove('open');
      const icon = toggleBtn.querySelector('.toggle-icon');
      if (icon) {
        icon.textContent = '⊕';
      }
    }
  }

  // 이벤트 리스너 바인딩
  toggleBtn.addEventListener('click', toggleSidebar);
  overlay.addEventListener('click', toggleSidebar);

  // 9. 초기화 및 실행
  // 화면 진입 시 정적 리스트를 감추고 동적 렌더링 컨테이너 노출
  if (staticList) staticList.style.display = 'none';
  if (dynamicContainer) dynamicContainer.style.display = 'block';

  // PC 환경일 경우 초기 상태로 사이드바를 열어둠
  if (window.innerWidth >= 1024) {
    document.body.classList.add('sidebar-open');
    toggleBtn.classList.add('open');
    const icon = toggleBtn.querySelector('.toggle-icon');
    if (icon) {
      icon.textContent = '⊖';
    }
  }

  renderSidebar();
  renderPosts();
})();
</script>
