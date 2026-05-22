# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-05-22

### Added

- Initial release. `use Intoable` generates a per-target `Into` protocol and
  a `from/1` function, plus a default `List` implementation that maps over
  list elements. `allow_nil?: true` opts into a `nil`-passthrough for the
  outer `from/1`.

[Unreleased]: https://github.com/Qarma-inspect/intoable/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Qarma-inspect/intoable/releases/tag/v1.0.0
