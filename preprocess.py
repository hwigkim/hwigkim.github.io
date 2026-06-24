import os
import re
import pyewts

# EWTS 변환기 초기화
converter = pyewts.pyewts()

def convert_wylie(match):
    wylie_text = match.group(1)
    # Wylie 표기를 티베트 유니코드로 변환
    tibetan_text = converter.toUnicode(wylie_text)
    # [티베트 문자] *[와일리 표기]* 형태로 치환
    return f"{tibetan_text} *{wylie_text}*"

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # tibwc*[와일리]* 패턴 매칭 정규식
    pattern = r"tibwc\*(.*?)\*"
    new_content = re.sub(pattern, convert_wylie, content)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"[Wylie Converter] 변환 완료: {filepath}")

def main():
    # 변환 대상 폴더 설정 (blog/ 디렉토리 내의 markdown 파일들)
    blog_dir = 'blog'
    if not os.path.exists(blog_dir):
        print(f"[Wylie Converter] {blog_dir} 디렉토리를 찾을 수 없습니다.")
        return

    # 변환에서 제외할 디렉토리 목록
    exclude_dirs = {'_site', '.jekyll-cache', 'vendor', 'node_modules'}

    for root, dirs, files in os.walk(blog_dir):
        # 제외 대상 디렉토리는 탐색하지 않음
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                process_file(filepath)

if __name__ == '__main__':
    main()
