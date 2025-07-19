class KgrepAT040 < Formula
  desc "Search and analyze logs and resources in Kubernetes"
  homepage "https://github.com/kgrep-org/kgrep"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.0/kgrep-macos-amd64.tar.gz"
      sha256 "075c30715563c52af2c5839426785e26b3aeee632c6561b27a8aac0d50331fd5"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.0/kgrep-macos-arm64.tar.gz"
      sha256 "9a498a9090c9039e5f2162b1d3a845e9d503dcc6f6ff7ed251da41da44927200"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.0/kgrep-linux-amd64.tar.gz"
      sha256 "d67c5a45d6e12fe91c16a59de766ace82764a5f27df8fca11867003e5eef7846"
    end

    # Note: Linux ARM64 binary not available for v0.4.0
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