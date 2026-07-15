class TerminalChinese < Formula
  desc "Learn Chinese vocabulary in your terminal — FSRS spaced repetition"
  homepage "https://github.com/wylansford/terminal-chinese"
  url "https://github.com/wylansford/terminal-chinese/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a81d8368711db5167f89eb70fa214ca593fee53aba20eaccdd1d103394c7bf7d"
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

      Then open a new terminal — you'll be offered the HSK 1 starter pack.
    EOS
  end

  test do
    assert_match "alias ct=", shell_output("#{bin}/terminal-chinese init zsh")
  end
end
