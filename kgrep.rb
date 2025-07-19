class Kgrep < Formula
  desc "Search and analyze logs and resources in Kubernetes"
  homepage "https://github.com/kgrep-org/kgrep"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.2/kgrep-macos-amd64.tar.gz"
      sha256 "8fd0ba5e64d2a4f7b8403c0e997bc2680bd6d1e4d67d5559cc317c6882467295"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.2/kgrep-macos-arm64.tar.gz"
      sha256 "93b2f0b910184083206d74c5d2952945d0e214af68b2b59628ca160237889841"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.2/kgrep-linux-amd64.tar.gz"
      sha256 "e8e8d18d0ced1cbd0f97986974c359e7fffc3c64a79e61abefa2798a9bc2198b"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.2/kgrep-linux-arm64.tar.gz"
      sha256 "fcd6daae88ab80fec4c734438755486301af68b3f4b85b2418e0ec06b7158ac5"
    end
  end

  on_windows do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.2/kgrep-windows-amd64.zip"
      sha256 "d7d8fcb080098534bbedcc0476539ce77ce68a820acc5d925508156958c4f63f"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.2/kgrep-windows-arm64.zip"
      sha256 "f9ea6fa68e12cf37c7bf6f88a0e2a2da0422a4859f0b3c0808622412144bd57a"
    end
  end

  depends_on "kubectl"

  def install
    bin.install "kgrep"
  end

  test do
    system "#{bin}/kgrep", "version"
    assert_match "kgrep", shell_output("#{bin}/kgrep --help")
  end
end 