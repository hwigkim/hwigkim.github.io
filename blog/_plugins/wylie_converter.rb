# UTF-8 인코딩을 기본으로 설정하여 서브프로세스와의 입출력 시 인코딩 손상을 방지합니다.
Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

require 'open3'

# 글로벌 로그 수집 배열
$wylie_logs = []

Jekyll::Hooks.register [:documents, :pages], :pre_render do |doc|
  # 파일 경로가 없거나 마크다운 파일이 아니면 건너뜁니다.
  next unless doc.path
  ext = File.extname(doc.path).downcase
  next unless ext == '.md' || ext == '.markdown'
  
  $wylie_logs << "--- Processing: #{doc.path} ---"
  
  begin
    content = doc.content
    if content && content.include?('tibwc*')
      $wylie_logs << "Found 'tibwc*' keyword in #{doc.path}"
      $wylie_logs << "Input content length: #{content.length}"
      $wylie_logs << "Input content: #{content.strip}"

      # 파이썬을 서브프로세스로 실행하여 Wylie 표기를 티베트 유니코드로 변환
      # 코드블럭(fenced 및 inline) 내부의 패턴은 변환 대상에서 제외합니다.
      python_code = <<~'PYTHON'
        import sys, re, pyewts
        converter = pyewts.pyewts()
        text = sys.stdin.read()
        sys.stderr.write(f"Python stdout encoding: {sys.stdout.encoding}, stdin: {sys.stdin.encoding}\n")
        
        # 1) Fenced code block (```...```)
        # 2) Inline code (`...`)
        # 3) tibwc*wylie* (본문 영역만 변환)
        pattern = re.compile(r"(```[\s\S]*?```)|(`[^`\n]*?`)|tibwc\*([^\*\n]+)\*")
        
        def replace(match):
            if match.group(1):
                return match.group(1)
            elif match.group(2):
                return match.group(2)
            elif match.group(3):
                wylie = match.group(3)
                unicode_val = converter.toUnicode(wylie)
                
                # 로마자(알파벳)로 끝나는지 검사
                if re.search(r"[a-zA-Z]$", wylie):
                    # ng으로 끝나는 경우: tsheg(་) + shad(།) 덧붙임
                    if wylie.endswith("ng"):
                        if not unicode_val.endswith('\u0f0b\u0f0d'):
                            if unicode_val.endswith('\u0f0b'):
                                unicode_val += '\u0f0d'
                            else:
                                unicode_val += '\u0f0b\u0f0d'
                    # 그 외 일반 로마자로 끝나는 경우: tsheg(་) 덧붙임
                    else:
                        if not unicode_val.endswith('\u0f0b'):
                            unicode_val += '\u0f0b'
                            
                return f"{unicode_val} *{wylie}*"
            return match.group(0)

        result = pattern.sub(replace, text)
        sys.stdout.write(result)
      PYTHON

      stdout, stderr, status = Open3.capture3(
        {"PYTHONUTF8" => "1"},
        "python", "-c", python_code,
        stdin_data: content
      )

      stdout.force_encoding("UTF-8")
      stderr.force_encoding("UTF-8")

      $wylie_logs << "Python subprocess success: #{status.success?}"
      $wylie_logs << "Stdout length: #{stdout.length}"
      $wylie_logs << "Stderr: #{stderr.strip}"
      if status.success?
        $wylie_logs << "Sample output: #{stdout[0..300]}"
        doc.content = stdout
      else
        $wylie_logs << "Python script failed with status: #{status.inspect}"
      end
    end
  rescue => e
    $wylie_logs << "Hook raised exception: #{e.class} - #{e.message}"
    $wylie_logs << e.backtrace.join("\n")
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  # 빌드가 완전히 완료된 후 _site 폴더에 직접 디버그 로그 파일 쓰기
  debug_file = File.join(site.dest, "wylie_debug.txt")
  File.write(debug_file, $wylie_logs.join("\n"), encoding: "utf-8")
end
