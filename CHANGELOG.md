# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to SemVer.

## [0.5.0] - 2026-01-12
### Added
- CLI flag `-o/--output-path` to control where text output is written.
- Aruba RSpec integration specs for the CLI.
- SimpleCov startup to measure coverage.
- Support for `.cc_ignore` as an alternate ignore file name.

### Changed
- Text output defaults to the project root when the target is a file.
- CLI now validates `-p/--print` values and errors on invalid output methods.
- CLI now errors when a target path does not exist.

### Fixed
- Directory ignore rules now match directory paths and nested contents.
- Directory glob rules now handle `**/` patterns correctly.
- Ignore filtering leaves files outside the root unfiltered.
- Relative path resolution returns absolute paths for files outside the root.
- Core now supports file targets in addition to directories.
- `pbcopy` fallback now warns and writes to stdout when unavailable.
- Gemspec no longer packages built `.gem` artifacts.
