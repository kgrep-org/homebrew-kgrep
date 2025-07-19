class Kgrep < Formula
  desc "Search and analyze logs and resources in Kubernetes"
  homepage "https://github.com/kgrep-org/kgrep"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.0/kgrep-macos-amd64.tar.gz"
      sha256 "2a0efc5466d6dbd0f20b87a8b4ad33a2ee2096c6f29fb6a959a9a4ddd1dbc24b"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.0/kgrep-macos-arm64.tar.gz"
      sha256 "384053c3afe720fbcf94ef8d210539bbc48b4aeff7e36f5805a402dc1e213520"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.0/kgrep-linux-amd64.tar.gz"
      sha256 "d6fdd00b23b5adba2b20ceb5de964fc8f99279f1a2803888752c7d9aefe20b17"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.5.0/kgrep-linux-arm64.tar.gz"
      sha256 "f406a484a5944dccba54bfb27601452de501a88a0750f00440a312c0b4b03e9c"
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