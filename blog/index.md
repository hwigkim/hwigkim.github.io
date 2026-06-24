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
