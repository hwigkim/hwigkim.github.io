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
    --sidebar-width: 280px;
    --transition-speed: 0.4s;
    --transition-curve: cubic-bezier(0.16, 1, 0.3, 1);
    --active-color-light: rgba(17, 17, 17, 0.08);
    --active-color-dark: rgba(255, 255, 255, 0.1);
  }

  /* 2. 바디 패딩 트랜지션 (PC용 화면 밀기 효과) */
  body {
    transition: padding-left var(--transition-speed) var(--transition-curve);
  }

  /* 3. 사이드바 스타일 (기본적으로 모바일 드로어 형태) */
  #sidebar {
    position: fixed;
    top: 0;
    left: 0;
    width: var(--sidebar-width);
    height: 100vh;
    background: rgba(255, 255, 248, 0.95);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border-right: 1px solid rgba(0, 0, 0, 0.08);
    box-shadow: 4px 0 24px rgba(0, 0, 0, 0.05);
    transform: translateX(-100%);
    transition: transform var(--transition-speed) var(--transition-curve), background-color 0.3s ease;
    z-index: 1000;
    display: flex;
    flex-direction: column;
    padding: 2.5rem 1.8rem;
    box-sizing: border-box;
  }

  /* 사이드바 열림 상태 */
  body.sidebar-open #sidebar {
    transform: translateX(0);
  }

  /* 다크모드 사이드바 */
  @media (prefers-color-scheme: dark) {
    #sidebar {
      background: rgba(21, 21, 21, 0.95);
      border-right: 1px solid rgba(255, 255, 255, 0.08);
      box-shadow: 4px 0 24px rgba(0, 0, 0, 0.3);
    }
  }

  /* 4. 사이드바 헤더 및 제목 */
  .sidebar-header {
    margin-bottom: 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .sidebar-title {
    font-size: 1.6rem;
    font-weight: 600;
    font-family: system-ui, -apple-system, sans-serif;
    margin: 0;
    letter-spacing: -0.02em;
  }

  /* 5. 태그 리스트 & 아이템 */
  .tag-list {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    overflow-y: auto;
    flex-grow: 1;
  }

  .tag-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.7rem 0.9rem;
    border-radius: 10px;
    cursor: pointer;
    font-size: 1.1rem;
    font-family: system-ui, -apple-system, sans-serif;
    color: #444;
    background: transparent;
    border: none;
    text-align: left;
    width: 100%;
    transition: all 0.2s ease;
  }

  .tag-item:hover {
    background: rgba(0, 0, 0, 0.04);
    color: #111;
    transform: translateX(5px);
  }

  .tag-item.active {
    background: var(--active-color-light);
    color: #111;
    font-weight: 600;
  }

  .tag-count {
    font-size: 0.9rem;
    background: rgba(0, 0, 0, 0.05);
    padding: 0.15rem 0.5rem;
    border-radius: 20px;
    color: #666;
    font-weight: 500;
    transition: all 0.2s ease;
  }

  .tag-item.active .tag-count {
    background: rgba(0, 0, 0, 0.12);
    color: #111;
  }

  /* 다크모드 태그 */
  @media (prefers-color-scheme: dark) {
    .tag-item {
      color: #aaa;
    }
    .tag-item:hover {
      background: rgba(255, 255, 255, 0.04);
      color: #fff;
    }
    .tag-item.active {
      background: var(--active-color-dark);
      color: #fff;
    }
    .tag-count {
      background: rgba(255, 255, 255, 0.08);
      color: #aaa;
    }
    .tag-item.active .tag-count {
      background: rgba(255, 255, 255, 0.2);
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
    background: rgba(0, 0, 0, 0.3);
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s ease, visibility 0.3s ease;
    z-index: 999;
    backdrop-filter: blur(2px);
  }

  body.sidebar-open #sidebar-overlay {
    opacity: 1;
    visibility: visible;
  }

  /* 7. 메뉴 토글 버튼 (햄버거 형태) */
  #sidebar-toggle-btn {
    position: fixed;
    left: 20px;
    top: 20px;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: rgba(255, 255, 248, 0.9);
    backdrop-filter: blur(8px);
    -webkit-backdrop-filter: blur(8px);
    border: 1px solid rgba(0, 0, 0, 0.10);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1001;
    transition: all 0.3s var(--transition-curve);
  }

  #sidebar-toggle-btn:hover {
    transform: scale(1.06);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
    background: #ffffff;
  }

  #sidebar-toggle-btn:active {
    transform: scale(0.94);
  }

  #sidebar-toggle-btn .hamburger {
    width: 18px;
    height: 12px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
  }

  #sidebar-toggle-btn .bar {
    display: block;
    width: 100%;
    height: 2px;
    background-color: #111;
    border-radius: 1px;
    transition: transform 0.3s var(--transition-curve), opacity 0.3s ease;
  }

  /* 햄버거 -> X 애니메이션 */
  #sidebar-toggle-btn.open .bar:nth-child(1) {
    transform: translateY(5px) rotate(45deg);
  }
  #sidebar-toggle-btn.open .bar:nth-child(2) {
    opacity: 0;
  }
  #sidebar-toggle-btn.open .bar:nth-child(3) {
    transform: translateY(-5px) rotate(-45deg);
  }

  /* 다크모드 토글 버튼 */
  @media (prefers-color-scheme: dark) {
    #sidebar-toggle-btn {
      background: rgba(21, 21, 21, 0.9);
      border: 1px solid rgba(255, 255, 255, 0.15);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    }
    #sidebar-toggle-btn:hover {
      background: #1e1e1e;
    }
    #sidebar-toggle-btn .bar {
      background-color: #ddd;
    }
  }

  /* 8. 포스트 리스트 애니메이션 & 스타일 */
  #dynamic-posts-container {
    display: none;
    margin-top: 2rem;
  }

  .post-item {
    opacity: 0;
    transform: translateY(15px);
    animation: slideUpIn 0.5s var(--transition-curve) forwards;
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
    color: #111;
    text-decoration: none;
    font-weight: 500;
    background-image: linear-gradient(currentColor, currentColor);
    background-position: 0 100%;
    background-repeat: no-repeat;
    background-size: 0 1px;
    transition: background-size 0.3s ease;
  }

  .post-link:hover {
    background-size: 100% 1px;
  }

  .post-meta {
    font-size: 1.1rem;
    color: #666;
    margin-top: 0.6rem;
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
    align-items: center;
  }

  .post-tags-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
  }

  .post-tag-badge {
    font-size: 0.9rem;
    color: #0066cc;
    background: rgba(0, 102, 204, 0.05);
    padding: 0.1rem 0.5rem;
    border-radius: 4px;
    cursor: pointer;
    font-family: system-ui, -apple-system, sans-serif;
    transition: all 0.2s ease;
  }

  .post-tag-badge:hover {
    background: rgba(0, 102, 204, 0.12);
    color: #0044b3;
  }

  /* 다크모드 포스트 리스트 */
  @media (prefers-color-scheme: dark) {
    .post-item {
      border-bottom: 1px dashed rgba(255, 255, 255, 0.08);
    }
    .post-link {
      color: #ddd;
    }
    .post-meta {
      color: #888;
    }
    .post-tag-badge {
      color: #66b2ff;
      background: rgba(102, 178, 255, 0.1);
    }
    .post-tag-badge:hover {
      background: rgba(102, 178, 255, 0.2);
      color: #99ccff;
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
  }
</style>

<!-- 레이아웃 요소 삽입 -->
<button id="sidebar-toggle-btn" aria-label="태그 목록 토글">
  <div class="hamburger">
    <span class="bar"></span>
    <span class="bar"></span>
    <span class="bar"></span>
  </div>
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
    allItem.innerHTML = `
      <button class="tag-item ${!activeTag ? 'active' : ''}" id="all-tags-item">
        <span>전체 보기</span>
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
          <span>#${tag}</span>
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

      // 게시글 내 태그 뱃지 생성
      let tagsHTML = '';
      if (post.tags && post.tags.length > 0) {
        tagsHTML = `
          <div class="post-tags-list">
            ${post.tags.map(t => `<span class="post-tag-badge">#${t}</span>`).join('')}
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
    
    // 브라우저 세션 스토리지 등에 선택 태그 임시 저장 가능 (원할 경우 스크롤 위치 유지 등)
  }

  // 8. 사이드바 토글 동작 제어
  function toggleSidebar() {
    const isOpen = document.body.classList.toggle('sidebar-open');
    toggleBtn.classList.toggle('open', isOpen);
  }

  function closeSidebarOnMobile() {
    // 모바일 환경(1024px 미만)에서만 태그 클릭 시 사이드바를 자동으로 닫음
    if (window.innerWidth < 1024) {
      document.body.classList.remove('sidebar-open');
      toggleBtn.classList.remove('open');
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
  }

  renderSidebar();
  renderPosts();
})();
</script>
