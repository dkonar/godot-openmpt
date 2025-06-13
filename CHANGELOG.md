# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial changelog for version tracking

## [1.3] - 2024-12-19

### Added
- ARM64 Linux binary support
- macOS support with separate Intel (x86_64) and ARM64 (Apple Silicon) binary builds
- Architecture-specific binary naming for optimal performance on each platform
- Enhanced GitHub Actions workflow for multi-architecture builds

### Changed
- Updated .gdextension file to support separate macOS architectures
- Modified build workflow to create both Intel and ARM64 macOS binaries
- Enhanced CMakeLists.txt for proper macOS architecture detection
- Updated GitHub Actions versions
- Enhanced cross-platform build process

### Fixed
- ARM64 Linux binary naming issues
- macOS build configuration and binary naming
- GitHub Actions cache issues
- Build workflow compatibility