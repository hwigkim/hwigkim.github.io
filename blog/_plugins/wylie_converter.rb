require 'open3'

Jekyll::Hooks.register :documents, :pre_render do |doc|
  next unless doc.extname == '.md'
  
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

    if status.success?
      doc.content = stdout
    else
      Jekyll.logger.warn "Wylie Converter [Error]:", stderr
    end
  end
end
