#!/bin/bash

# Script to update the Homebrew formula with a new kgrep release
# Usage: ./update-formula.sh VERSION

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
    echo "Updates the Homebrew formula for a new kgrep release"
    echo ""
    echo "Example:"
    echo "  $0 0.4.3   # Creates kgrep@0.4.2.rb then updates to v0.4.3"
    echo ""
    echo "This script will:"
    echo "  1. Create a versioned formula for the current version"
    echo "  2. Download release binaries from GitHub"
    echo "  3. Calculate SHA256 checksums"
    echo "  4. Update the main formula with new version and checksums"
    echo ""
}

# Function to get the current version from kgrep.rb
get_current_version() {
    grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' kgrep.rb | head -1 | sed 's/v//'
}

# Function to create versioned formula
create_versioned_formula() {
    local old_version=$1
    local versioned_file="kgrep@${old_version}.rb"
    local class_name="KgrepAT$(echo $old_version | sed 's/\.//g')"
    
    print_status "Creating versioned formula for v${old_version}..."
    
    if [[ -f "$versioned_file" ]]; then
        print_error "Versioned formula $versioned_file already exists"
        return 1
    fi
    
    # Copy current formula to versioned formula
    cp kgrep.rb "$versioned_file"
    
    # Update class name in versioned formula
    sed -i.tmp "s/class Kgrep/class $class_name/" "$versioned_file"
    rm -f "${versioned_file}.tmp"
    
    print_success "Created versioned formula: $versioned_file"
    print_status "  Class name: $class_name"
    print_status "  Version: v${old_version}"
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

update_formula() {
    local version=$1
    
    print_status "Updating formula for version ${version}..."
    
    # Download and get checksums for all platforms
    local macos_amd64_sha256=$(download_and_hash "${version}" "macos" "amd64")
    local macos_arm64_sha256=$(download_and_hash "${version}" "macos" "arm64")
    local linux_amd64_sha256=$(download_and_hash "${version}" "linux" "amd64")
    local linux_arm64_sha256=$(download_and_hash "${version}" "linux" "arm64")
    
    if [[ -z "$macos_amd64_sha256" || -z "$macos_arm64_sha256" || -z "$linux_amd64_sha256" || -z "$linux_arm64_sha256" ]]; then
        print_error "Failed to download all required binaries"
        exit 1
    fi
    
    # Create backup
    cp kgrep.rb kgrep.rb.backup
    
    # Update the formula - replace version in URLs
    sed -i.tmp "s|/releases/download/v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/|/releases/download/v${version}/|g" kgrep.rb
    
    # Create a temporary script to update SHA256 values more reliably
    cat > /tmp/update_sha256.py << 'EOF'
import sys
import re

def update_formula(filename, sha256_values):
    with open(filename, 'r') as f:
        content = f.read()
    
    # Find and replace SHA256 values in order
    sha256_pattern = r'sha256 "[a-f0-9]{64}"'
    
    def replace_sha256(match):
        if not hasattr(replace_sha256, 'counter'):
            replace_sha256.counter = 0
        
        platforms = ['macos_amd64', 'macos_arm64', 'linux_amd64', 'linux_arm64']
        if replace_sha256.counter < len(platforms):
            platform = platforms[replace_sha256.counter]
            new_sha256 = sha256_values[platform]
            replace_sha256.counter += 1
            return f'sha256 "{new_sha256}"'
        return match.group(0)
    
    updated_content = re.sub(sha256_pattern, replace_sha256, content)
    
    with open(filename, 'w') as f:
        f.write(updated_content)

if __name__ == "__main__":
    sha256_values = {
        'macos_amd64': sys.argv[1],
        'macos_arm64': sys.argv[2], 
        'linux_amd64': sys.argv[3],
        'linux_arm64': sys.argv[4]
    }
    update_formula('kgrep.rb', sha256_values)
EOF
    
    # Use Python script to update SHA256 values
    python3 /tmp/update_sha256.py "${macos_amd64_sha256}" "${macos_arm64_sha256}" "${linux_amd64_sha256}" "${linux_arm64_sha256}"
    
    # Clean up temporary files
    rm -f kgrep.rb.tmp /tmp/update_sha256.py
    
    print_success "Formula updated successfully!"
    print_status "Changes:"
    echo "  Version: ${version}"
    echo "  macOS AMD64 SHA256: ${macos_amd64_sha256}"
    echo "  macOS ARM64 SHA256: ${macos_arm64_sha256}"
    echo "  Linux AMD64 SHA256:  ${linux_amd64_sha256}"
    echo "  Linux ARM64 SHA256:  ${linux_arm64_sha256}"
    echo ""
    print_status "To test the formula:"
    echo "  brew install --formula ./kgrep.rb"
    echo "  kgrep version"
    echo ""
    print_status "Backup saved as kgrep.rb.backup"
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

# Check if kgrep.rb exists
if [[ ! -f "kgrep.rb" ]]; then
    print_error "kgrep.rb not found in current directory"
    exit 1
fi

print_status "Updating Homebrew formula for kgrep v${version}"

# Create versioned formula for current version
current_version=$(get_current_version)
if [[ -n "$current_version" ]]; then
    create_versioned_formula "$current_version"
    print_status ""
else
    print_error "Could not determine current version from kgrep.rb"
    exit 1
fi

update_formula "$version"

print_success "Formula update completed!"
print_status "Files created/updated:"
echo "  - kgrep.rb (updated to v${version})"
echo "  - kgrep@${current_version}.rb (new versioned formula)"
print_status ""
print_status "Test the formulas:"
echo "  brew audit --strict kgrep.rb"
echo "  brew install --formula ./kgrep@${current_version}.rb"
