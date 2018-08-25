class Autojump < Formula
  desc "A cd command that learns - easily navigate directories from the command line"
  homepage "https://github.com/juanrgon/autojump"
  url "https://github.com/juanrgon/autojump/archive/release-v22.6.1.tar.gz"
  sha256 "a43fe271785e645cadc3fc4485284b093de7766cb2cab44e499173ec2c728f00"

  def install
    system "./install.py", "-d", prefix, "-z", zsh_completion

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix/"etc").install_symlink prefix/"etc/profile.d/autojump.sh"

    libexec.install bin
    bin.write_exec_script libexec/"bin/autojump"
  end

  def caveats; <<~EOS
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      [ -f #{etc}/profile.d/autojump.sh ] && . #{etc}/profile.d/autojump.sh

    If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
      [ -f #{HOMEBREW_PREFIX}/share/autojump/autojump.fish ]; and source #{HOMEBREW_PREFIX}/share/autojump/autojump.fish
  EOS
  end

  test do
    path = testpath/"foo/bar"
    path.mkpath
    output = `
      source #{etc}/profile.d/autojump.sh
      j -a "#{path.relative_path_from(testpath)}"
      j foo >/dev/null
      pwd
    `.strip
    assert_equal path.realpath.to_s, output
  end
end
