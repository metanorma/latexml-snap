# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

This is a Snap packaging project for LaTeXML, a LaTeX to XML/HTML/MathML converter developed by NIST. The repository contains configuration to build and publish LaTeXML as a Snap package for Linux distributions.

## Build commands

Build the snap package:
```bash
snapcraft snap
```

The resulting `.snap` file will be created in the root directory.

## Testing

On macOS, use multipass for testing:
```bash
multipass transfer latexml_*_amd64.snap ${instance-name}:/home/multipass
multipass shell ${instance-name}
sudo snap install --devmode latexml_*_amd64.snap
```

Verify the installation:
```bash
latexml --VERSION
latexml --dest=test.xml test.tex
```

## Version management

The version is stored in `VERSION` file (single source of truth). The `snap/snapcraft.yaml` uses `adopt-info` to read the version dynamically.

To update the version:
1. Update the `VERSION` file
2. Or trigger the `release-tag.yml` workflow via GitHub Actions UI

## Release process

1. Manually trigger the `release-tag.yml` workflow via GitHub Actions UI with the new version number
2. The workflow updates `VERSION` file and creates a git tag
3. Tag push triggers the `main.yml` workflow which builds, tests, and publishes

Release channels:
- **stable**: Tags matching `v*` (not ending in `pre`) - auto-promoted from candidate
- **candidate**: Tags ending with `pre`
- **edge/beta**: Pushes to main/master branch

## Key files

- `VERSION`: Single source of truth for version number
- `snap/snapcraft.yaml`: Main snap package definition (uses `adopt-info` for dynamic version)
- `.github/workflows/main.yml`: CI/CD pipeline for build, test, and release
- `.github/workflows/release-tag.yml`: Version bump and tag creation workflow
- `.github/workflows/promote-to-stable.yml`: Manual promotion to stable channel
- `.github/scripts/check-snap-version.sh`: Script to check if version already exists in store

## Snap package architecture

- Base: `core24` (Ubuntu 24.04)
- Grade: `stable`, Confinement: `strict`
- Dependencies: Perl, XML::LibXSLT, LaTeXML (installed via CPAN)
- Platforms: amd64 (with infrastructure for arm64)

Exposed apps:
- `latexml` - Main converter
- `latexmlc` - Compact converter
- `latexmlfind` - Find utility
- `latexmlmath` - Math converter
- `latexmlpost` - Post-processor

Each app uses a wrapper script (`perl5lib.sh`) to set up the correct `PERL5LIB` environment.
