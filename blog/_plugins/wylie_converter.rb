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

      # 파이썬을 서브프로세스로 실행하여 Wylie 표기를 티베트 유니코드로 변환
      # PYTHONUTF8=1 환경변수를 설정하여 윈도우 인코딩 오류 방지
      python_code = <<~PYTHON
        import sys, re, pyewts
        converter = pyewts.pyewts()
        text = sys.stdin.read()
        sys.stderr.write(f"Python stdout encoding: {sys.stdout.encoding}, stdin: {sys.stdin.encoding}\\n")
        # tibwc*wylie* 패턴을 찾아 변환
        result = re.sub(r"tibwc\*(.*?)\*", lambda m: f"{converter.toUnicode(m.group(1))} *{m.group(1)}*", text)
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
