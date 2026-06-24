require 'open3'

Jekyll::Hooks.register [:documents, :pages], :pre_render do |doc|
  # 파일 경로가 없거나 마크다운 파일이 아니면 건너뜁니다.
  next unless doc.path
  ext = File.extname(doc.path).downcase
  next unless ext == '.md' || ext == '.markdown'
  
  content = doc.content
  if content && content.include?('tibwc*')
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

    if status.success?
      doc.content = stdout
    else
      raise "Wylie Converter [Error] on #{doc.path}: #{stderr}"
    end
  end
end
