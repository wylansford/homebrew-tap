class TerminalChinese < Formula
  desc "Learn Chinese vocabulary in your terminal - FSRS spaced repetition"
  homepage "https://github.com/wylansford/terminal-chinese"
  url "https://github.com/wylansford/terminal-chinese/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "54a54e732b0859cd907d5b22602b3bef873a68ceb7d540305b6d913fcd0f443b"
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
      Add to your ~/.zshrc (or ~/.bashrc):
        alias ct=terminal-chinese
        if [[ -o interactive && -t 0 && $SHLVL -eq 1 && -z "$TERMINAL_CHINESE_DISABLE" ]]; then
            terminal-chinese review
        fi

      (bash: swap `-o interactive` for `$- == *i*`.) Uses the bare command
      name, not an absolute path -- brew keeps it on PATH across upgrades,
      so nothing goes stale when the version bumps.

      Then open a new terminal - HSK 1-6 vocabulary (~5,700 words) imports
      automatically, starting on HSK 1 (widen anytime: ct config --hsk 1,2,3).
    EOS
  end

  test do
    # TERMINAL_CHINESE_BIN must be honored -- without it, init would bake in
    # the internal venv script path instead of the wrapper, silently
    # bypassing the venv (see bin/terminal-chinese's cmd_init).
    out = shell_output("TERMINAL_CHINESE_BIN=#{bin}/terminal-chinese #{bin}/terminal-chinese init zsh")
    assert_match "alias ct=#{bin}/terminal-chinese", out
  end
end
