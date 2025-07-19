# Homebrew Tap Setup Guide

This guide explains how to set up and maintain the Homebrew tap for kgrep.

## Publishing Process

### 1. Create a New kgrep Release

First, ensure you have a kgrep release with binaries for all supported platforms:

- `kgrep-macos-amd64.tar.gz`
- `kgrep-macos-arm64.tar.gz`
- `kgrep-linux-amd64.tar.gz`
- `kgrep-linux-arm64.tar.gz`

### 2. Update the Formula

Use the provided script to update the formula:

```bash
cd homebrew-kgrep
./update-formula.sh 0.4.2  # Replace with actual version
```

This script will:

- Download all platform binaries
- Calculate SHA256 checksums
- Update the formula with the new version and checksums

### 3. Test the Formula

Test the formula locally:

```bash
# Test installation (requires valid checksums)
brew install --formula ./kgrep.rb

# Test functionality
kgrep version
kgrep --help
```

### 4. Commit and Push

```bash
git add kgrep.rb
git commit -m "Update to v0.4.2"
git push origin main
```

## User Installation

Once the tap is published, users can install kgrep with:

```bash
# Method 1: Add tap then install
brew tap kgrep-org/kgrep
brew install kgrep

# Method 2: Install directly
brew install kgrep-org/kgrep/kgrep
```

## Formula Structure

The `kgrep.rb` formula includes:

- **Platform-specific URLs**: Downloads appropriate binary for user's platform
- **SHA256 checksums**: Ensures download integrity
- **Dependencies**: Requires `kubectl`
- **Installation**: Renames binary to `kgrep` and places in PATH
- **Tests**: Verifies the binary works after installation

## Maintenance

### Updating for New Releases

1. Run `./update-formula.sh VERSION` with the new version
2. Test the updated formula
3. Commit and push changes

### Testing Changes

The GitHub Actions workflow automatically tests:

- Formula syntax validation
- Installation process (syntax only, not full install)

### Troubleshooting

**Issue**: Formula fails with checksum mismatch

- **Solution**: Re-run `update-formula.sh` to get fresh checksums

**Issue**: Binary not found during installation

- **Solution**: Verify the release exists on GitHub with all required binaries

**Issue**: Permission denied on script

- **Solution**: Ensure script is executable: `chmod +x update-formula.sh`

## File Structure

```sh
homebrew-kgrep/
├── .github/
│   └── workflows/
│       └── test.yml           # CI tests for formula
├── .gitignore                 # Ignore backup and temp files
├── LICENSE                    # License file
├── README.md                  # User-facing documentation
├── SETUP.md                   # This setup guide
├── kgrep.rb                   # The Homebrew formula
└── update-formula.sh          # Script to update formula
```

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Acceptable Formulae](https://docs.brew.sh/Acceptable-Formulae)
- [Creating Homebrew Taps](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
