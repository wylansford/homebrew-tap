class TerminalChinese < Formula
  desc "Learn Chinese vocabulary in your terminal — FSRS spaced repetition"
  homepage "https://github.com/wylansford/terminal-chinese"
  url "https://github.com/wylansford/terminal-chinese/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "9d49fa50dd8ec4d33267a801e5e7f0fe0db829244e734f1b1ef8db2cd1c0d16b"
  license "MIT"

  depends_on "python@3.13"

  def install
    venv = libexec/"venv"
    system Formula["python@3.13"].opt_bin/"python3.13", "-m", "venv", venv
    system venv/"bin/pip", "install", "-q", "-r", "requirements.txt"
    libexec.install "bin", "lib", "data"
    (bin/"terminal-chinese").write <<~SH
      #!/bin/sh
      exec "#{venv}/bin/python3" "#{libexec}/bin/terminal-chinese" "$@"
    SH
  end

  def caveats
    <<~EOS
      Add to your ~/.zshrc (or ~/.bashrc with `init bash`):
        eval "$(terminal-chinese init zsh)"

      Then open a new terminal — HSK 1-6 vocabulary (~5,700 words) imports
      automatically, starting on HSK 1 (widen anytime: ct config --hsk 1,2,3).
    EOS
  end

  test do
    assert_match "alias ct=", shell_output("#{bin}/terminal-chinese init zsh")
  end
end
