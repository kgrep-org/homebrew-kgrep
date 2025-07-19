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
./update-formula.sh 0.4.3  # Replace with actual version
```

This script automatically:

- Creates a versioned formula for the current version (preserves user choice and compatibility)
- Downloads all platform binaries for the new version
- Calculates SHA256 checksums
- Updates the main formula with the new version and checksums

**Why versioned formulas are automatically created:**
- Users can pin to specific versions for reproducible builds
- Allows parallel installation of multiple versions
- Maintains backward compatibility
- Follows Homebrew best practices (like `node@14`, `python@3.9`)

#### Automatic Versioned Formula Creation

The script automatically:

1. Detects the current version from `kgrep.rb` (e.g., v0.4.2)
2. Creates `kgrep@0.4.2.rb` with the current formula content
3. Updates the class name to `KgrepAT042`
4. Updates `kgrep.rb` to the new version (e.g., v0.4.3)

This allows users to install specific versions:
- `brew install kgrep-org/kgrep/kgrep` (latest version)
- `brew install kgrep-org/kgrep/kgrep@0.4.2` (specific version)

### 3. Test the Formula

Test the formula locally:

```bash
# Test installation (requires valid checksums)
brew install --formula ./kgrep.rb

# Test functionality
kgrep version
kgrep --help
```

## User Installation

Once the tap is published, users can install kgrep with:

### Latest Version

```bash
# Method 1: Add tap then install
brew tap kgrep-org/kgrep
brew install kgrep

# Method 2: Install directly
brew install kgrep-org/kgrep/kgrep
```

### Specific Versions

```bash
# Add tap first
brew tap kgrep-org/kgrep

# Install specific version
brew install kgrep@0.4.1

# Or install directly
brew install kgrep-org/kgrep/kgrep@0.4.1
```

### List Available Versions

```bash
# Show all available formulas in the tap
brew search kgrep-org/kgrep/
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

## Creating Versioned Formulas for Existing Releases

If you need to create versioned formulas for existing kgrep releases:

```bash
# Create a versioned formula for a specific version
./create-versioned-formula.sh 0.4.1

# This will:
# 1. Download binaries for v0.4.1 from GitHub
# 2. Calculate SHA256 checksums
# 3. Create kgrep@0.4.1.rb with proper checksums
```

## File Structure

```sh
homebrew-kgrep/
├── .github/
│   └── workflows/
│       └── test.yml              # CI tests for formula
├── .gitignore                    # Ignore backup and temp files
├── LICENSE                       # License file
├── README.md                     # User-facing documentation
├── SETUP.md                      # This setup guide
├── kgrep.rb                      # The main Homebrew formula (latest version)
├── kgrep@0.4.1.rb               # Versioned formula for v0.4.1
├── kgrep@0.4.0.rb               # Versioned formula for v0.4.0
├── update-formula.sh             # Script to update formula
└── create-versioned-formula.sh  # Script to create versioned formulas
```

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Acceptable Formulae](https://docs.brew.sh/Acceptable-Formulae)
- [Creating Homebrew Taps](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
