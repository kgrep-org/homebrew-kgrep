#!/bin/bash

# Script to create a versioned Homebrew formula for kgrep
# Usage: ./create-versioned-formula.sh VERSION

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_usage() {
    echo "Usage: $0 VERSION"
    echo ""
    echo "Creates a versioned Homebrew formula for a specific kgrep release"
    echo ""
    echo "Example:"
    echo "  $0 0.4.1   # Create kgrep@0.4.1.rb"
    echo ""
    echo "NOTE: This script is for creating versioned formulas for existing releases."
    echo "For updating to a new version, use: ./update-formula.sh VERSION"
    echo ""
    echo "This script will:"
    echo "  1. Download release binaries from GitHub for the specified version"
    echo "  2. Calculate SHA256 checksums"
    echo "  3. Create a versioned formula file"
    echo ""
}

download_and_hash() {
    local version=$1
    local platform=$2
    local arch=$3
    local filename="kgrep-${platform}-${arch}.tar.gz"
    local url="https://github.com/kgrep-org/kgrep/releases/download/v${version}/${filename}"
    
    print_status "Downloading ${filename}..." >&2
    
    if ! curl -L -f -o "/tmp/${filename}" "${url}" 2>/dev/null; then
        print_error "Failed to download ${filename} from ${url}" >&2
        return 1
    fi
    
    local sha256=$(shasum -a 256 "/tmp/${filename}" | cut -d' ' -f1)
    print_success "Downloaded ${filename}, SHA256: ${sha256}" >&2
    
    # Clean up
    rm -f "/tmp/${filename}"
    
    # Return only the clean SHA256 value
    printf "%s" "${sha256}"
}

create_versioned_formula() {
    local version=$1
    local versioned_file="kgrep@${version}.rb"
    local class_name="KgrepAT$(echo $version | sed 's/\.//g')"
    
    print_status "Creating versioned formula for v${version}..."
    
    if [[ -f "$versioned_file" ]]; then
        print_error "Versioned formula $versioned_file already exists"
        exit 1
    fi
    
    # Download and get checksums for all platforms
    local macos_amd64_sha256=$(download_and_hash "${version}" "macos" "amd64")
    local macos_arm64_sha256=$(download_and_hash "${version}" "macos" "arm64")
    local linux_amd64_sha256=$(download_and_hash "${version}" "linux" "amd64")
    local linux_arm64_sha256=$(download_and_hash "${version}" "linux" "arm64")
    
    if [[ -z "$macos_amd64_sha256" || -z "$macos_arm64_sha256" || -z "$linux_amd64_sha256" || -z "$linux_arm64_sha256" ]]; then
        print_error "Failed to download all required binaries"
        exit 1
    fi
    
    # Create the versioned formula file
    cat > "$versioned_file" << EOF
class $class_name < Formula
  desc "Search and analyze logs and resources in Kubernetes"
  homepage "https://github.com/kgrep-org/kgrep"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v${version}/kgrep-macos-amd64.tar.gz"
      sha256 "${macos_amd64_sha256}"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v${version}/kgrep-macos-arm64.tar.gz"
      sha256 "${macos_arm64_sha256}"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/kgrep-org/kgrep/releases/download/v${version}/kgrep-linux-amd64.tar.gz"
      sha256 "${linux_amd64_sha256}"
    end

    on_arm do
      url "https://github.com/kgrep-org/kgrep/releases/download/v${version}/kgrep-linux-arm64.tar.gz"
      sha256 "${linux_arm64_sha256}"
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
EOF
    
    print_success "Created versioned formula: $versioned_file"
    print_status "  Class name: $class_name"
    print_status "  Version: v${version}"
    print_status "  SHA256 checksums:"
    echo "    macOS AMD64: ${macos_amd64_sha256}"
    echo "    macOS ARM64: ${macos_arm64_sha256}"
    echo "    Linux AMD64: ${linux_amd64_sha256}"
    echo "    Linux ARM64: ${linux_arm64_sha256}"
}

# Main script
if [[ $# -ne 1 ]]; then
    print_error "Version argument is required"
    show_usage
    exit 1
fi

version="$1"

# Validate version format
if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_error "Invalid version format: $version"
    print_error "Use semantic versioning: MAJOR.MINOR.PATCH (e.g., 1.2.0)"
    exit 1
fi

print_status "Creating versioned formula for kgrep v${version}"

create_versioned_formula "$version"

print_success "Versioned formula creation completed!"
print_status "File created:"
echo "  - $versioned_file"
print_status ""
print_status "Test the formula:"
echo "  brew install --formula ./$versioned_file"
echo "  kgrep version" 