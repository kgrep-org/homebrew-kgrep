class KgrepAT041 < Formula
  desc "Search and analyze logs and resources in Kubernetes"
  homepage "https://github.com/kgrep-org/kgrep"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.1/kgrep-macos-amd64.tar.gz"
      sha256 "df3491dffd3c3d73e5f38f47476e1abf65caa8ccc6cdbb6b3f5b7412321c63fd"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.1/kgrep-macos-arm64.tar.gz"
      sha256 "423b4324ccda3eed53e9103c788043aabfd4c54b46f16ca6ed622a8298408766"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.1/kgrep-linux-amd64.tar.gz"
      sha256 "21df40fa3b1d37bd80148f6c8e4bab630ffc3d975396ed78a1e29c595de83637"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v0.4.1/kgrep-linux-arm64.tar.gz"
      sha256 "5c4ab0ed122ac6ef57f36058b1a20be9e0aa80024558887f206195ed2e0766ff"
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
