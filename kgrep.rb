class Kgrep < Formula
  desc "Search and analyze logs and resources in Kubernetes"
  homepage "https://github.com/kgrep-org/kgrep"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.1/kgrep-macos-amd64.tar.gz"
      sha256 "ab6e1b60c7a2e22a517cb85198db01715749b92cc6324d106a2013d138417e85"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.1/kgrep-macos-arm64.tar.gz"
      sha256 "51f15fd0af8052667d92c9f9398d4980c78817983369a075fae5fa78feb2f50c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.1/kgrep-linux-amd64.tar.gz"
      sha256 "5d6bc03d0053f697993bcb49929f1967143d6999de72ccb261d76b5d11ef91cd"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.1/kgrep-linux-arm64.tar.gz"
      sha256 "bd927fed5ab0819f4001eb831535d55fdc2221dc2be1ecead8eb2562d5b5cac1"
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