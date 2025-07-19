# homebrew-kgrep

Homebrew tap for [kgrep](https://github.com/kgrep-org/kgrep) - a CLI for searching and analyzing logs and resources in Kubernetes.

## Installation

### Latest Version

To install the latest version of kgrep using this tap:

```bash
# Add the tap
brew tap kgrep-org/kgrep

# Install kgrep (latest version)
brew install kgrep
```

Alternatively, you can install directly without adding the tap:

```bash
brew install kgrep-org/kgrep/kgrep
```

### Specific Versions

To install a specific version of kgrep:

```bash
# Add the tap first
brew tap kgrep-org/kgrep

# Install specific version (e.g., v0.4.1)
brew install kgrep@0.4.1

# Or install directly without adding the tap
brew install kgrep-org/kgrep/kgrep@0.4.1
```

To see all available versions:

```bash
brew search kgrep-org/kgrep/
```

## Prerequisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - kgrep requires kubectl to be installed and configured

## Usage

After installation, you can use kgrep to search Kubernetes resources and logs:

```bash
# Search for a pattern in ConfigMaps
kgrep configmaps -n my-namespace -p "example"

# Search for errors in pod logs
kgrep logs -n my-namespace -p "error"

# Get help
kgrep --help
```

For detailed usage instructions, see the [main kgrep repository](https://github.com/kgrep-org/kgrep).

## Updating

To update to the latest version:

```bash
brew update
brew upgrade kgrep
```

## Development

This tap contains the Homebrew formula for kgrep. The formula downloads pre-built binaries from the [GitHub releases](https://github.com/kgrep-org/kgrep/releases).

### Updating the Formula

When a new version of kgrep is released:

1. Run the update script: `./update-formula.sh NEW_VERSION`
2. This will automatically create a versioned formula for the current version (e.g., `kgrep@0.4.2.rb`) before updating to the new version
3. Test both the main and versioned formulas

The script automatically handles:

- Creating versioned formulas for the current version
- Downloading release binaries from GitHub
- Calculating SHA256 checksums for all platforms
- Updating the main formula with the new version

After running the script, you can commit and push the changes as needed.

### Testing Locally

To test the formula locally:

```bash
# Install from local formula
brew install --formula ./kgrep.rb

# Or test the formula
brew test kgrep
```

## License

This tap is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

The kgrep tool itself is also licensed under Apache 2.0 - see the [main repository](https://github.com/kgrep-org/kgrep) for details.
