# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4] - 2024-12-19

### Added
- ARM64 Linux support for Raspberry Pi and other ARM-based Linux systems
- macOS support (x86_64 and ARM64/Apple Silicon)
- Updated .gdextension file to include ARM Linux binary configurations
- CI/CD workflow now builds ARM64 binaries automatically
- Release workflow for automated GitHub releases

### Changed
- Plugin version updated to 1.4
- Build system now generates ARM-specific binary names (libgdmpt-linux.*.arm64.so)

### Technical Details
- Added linux.debug.arm64 and linux.release.arm64 entries to openmpt.gdextension
- CI workflow builds on ubuntu-22.04-arm runners for native ARM64 compilation
- macOS builds on macos-latest runners with clang compiler
- Binaries are automatically packaged and distributed via GitHub releases

### Platform Support
- Windows (x86_64) - Debug & Release
- Linux (x86_64) - Debug & Release
- Linux (ARM64) - Debug & Release ✨ **NEW**
- macOS (x86_64/ARM64) - Debug & Release ✨ **NEW**
