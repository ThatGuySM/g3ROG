# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Promoted the repo into the broader `g3ROG` machine dossier with `docs/machines/` as the new per-machine structure
- Added the active `G3ROG-DARK` machine page, share-safe markdown spec, detailed detected markdown spec, and HTML exports
- Added `G3ROG-DARK` gallery photos from the May 8, 2026 chassis shoot
- Added a new `G3ROG-DARK` README banner and GitHub social preview card generated from the real chassis photos
- Added historical `g3ROG-actual` and future rebuild machine pages so the repo can track the old flagship and the hand-me-down build cleanly

### Changed

- Reworked the root README from a single-machine audit page into a multi-machine build dossier
- Updated `docs/LATEST.md`, `docs/README.md`, and `docs/GALLERY.md` so the current flagship is `G3ROG-DARK`
- Reframed the April 2026 `g3ROG-actual` docs as historical pre-rebuild records
- Updated validation to check the new machine docs, HTML exports, gallery assets, banner, social preview, and markdown links
- Sanitized the detailed `G3ROG-DARK` HTML export so local IP and private domain details are not published
- Updated repository-facing badge links for the intended `ThatGuySM/g3ROG` rename
- Refined the README with a clearer maintenance flow for future audit updates
- Modernized GitHub Actions workflow versions and aligned pre-commit behavior with the repo's intentional assets, Markdown formatting, and audit artifacts
- Polished the repo landing experience with release-aware README metadata and stronger GitHub storefront positioning
- Corrected the published snapshot to reflect the April 16, 2026 BIOS update, removed public firewall disclosure, and clarified that the app list is not a startup-folder inventory

- `docs/GALLERY.md` plus tracked speed-test proof images under `assets/gallery/`
- Approved battlestation photo and motion clip under `assets/gallery/` for public repo presentation

## [1.1.0] - 2026-04-15

### Changed

- Reworked repo validation so GitHub Actions runs real checks instead of placeholder jobs
- Clarified that the public system report is a point-in-time snapshot
- Improved repo scaffolding, contribution guidance, and issue/PR templates
- Added a stable latest-audit navigation flow and documentation hub
- Published the 2026 markdown audit snapshot and archived the older 2025 markdown report
- Refreshed the README, spec sheet, BIOS notes, and network data to match the 2026 snapshot
- Added a local PDF export script and regenerated the main report PDF from the published markdown

### Added

- `docs/LATEST.md` as a stable entrypoint for the latest published audit
- `docs/README.md` and `docs/archive/README.md` for documentation navigation
- `docs/drafts/README.md` and a scaffolded 2026 draft workflow
- `docs/g3ROG-actual_Battlestation_Spec_Sheet.md` as a tracked public spec sheet
- `docs/templates/system_health_report_template.md` for future report creation
- `logs/audits/2026-04-15/` as the sanitized local audit evidence set for the published 2026 snapshot
- `scripts/collect_system_audit.ps1`, `scripts/export_report_pdf.ps1`, `scripts/new_audit_report.ps1`, `scripts/validate_repo.ps1`, `.pre-commit-config.yaml`, and `.yamllint.yml`

### Removed

- Accidental tracked workspace file `G3-ROG-ACTUAL.code-workspace`

## [1.0.0] - 2025-09-05

### Added

- Initial public release of the **g3ROG-actual audit repo**
- README with badges & system overview
- docs/: System Health Report (PDF + MD)
- assets/: Clean banner (GitHub-ready)
- scripts/, logs/, benchmarks/ scaffolds
- .github/: CI workflows (lint, spellcheck, link-check, PDF check) + issue/PR templates
- CONTRIBUTING.md and MIT LICENSE
