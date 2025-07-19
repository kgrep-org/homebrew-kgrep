# homebrew-kgrep

Homebrew tap for [kgrep](https://github.com/kgrep-org/kgrep) - a CLI for searching and analyzing logs and resources in Kubernetes.

## Installation

To install kgrep using this tap:

```bash
# Add the tap
brew tap kgrep-org/kgrep

# Install kgrep
brew install kgrep
```

Alternatively, you can install directly without adding the tap:

```bash
brew install kgrep-org/kgrep/kgrep
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

1. Update the version number in `kgrep.rb`
2. Update the URLs to point to the new release
3. Update the SHA256 checksums for each platform
4. Test the formula locally
5. Commit and push the changes

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
