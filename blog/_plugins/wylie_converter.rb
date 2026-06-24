require 'open3'
require 'fileutils'

Jekyll::Hooks.register [:documents, :pages], :pre_render do |doc|
  # 파일 경로가 없거나 마크다운 파일이 아니면 건너뜁니다.
  next unless doc.path
  ext = File.extname(doc.path).downcase
  next unless ext == '.md' || ext == '.markdown'
  
  # 디버그 로그 파일 경로 설정 (소스 폴더에 작성하여 빌드 시 _site로 복사되도록 함)
  debug_file = File.join(doc.site.source, "wylie_debug.txt")
  
  File.open(debug_file, "a:utf-8") do |f|
    f.puts "--- Processing: #{doc.path} ---"
  end
  
  content = doc.content
  if content && content.include?('tibwc*')
    File.open(debug_file, "a:utf-8") do |f|
      f.puts "Found 'tibwc*' keyword in #{doc.path}"
    end

    # 파이썬을 서브프로세스로 실행하여 Wylie 표기를 티베트 유니코드로 변환
    # PYTHONUTF8=1 환경변수를 설정하여 윈도우 인코딩 오류 방지
    python_code = <<~PYTHON
      import sys, re, pyewts
      converter = pyewts.pyewts()
      text = sys.stdin.read()
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

    File.open(debug_file, "a:utf-8") do |f|
      f.puts "Python subprocess success: #{status.success?}"
      f.puts "Stdout length: #{stdout.length}"
      f.puts "Stderr: #{stderr}"
      if status.success?
        f.puts "Sample output: #{stdout[0..300]}"
      end
    end

    if status.success?
      doc.content = stdout
    else
      raise "Wylie Converter [Error] on #{doc.path}: #{stderr}"
    end
  end
end
