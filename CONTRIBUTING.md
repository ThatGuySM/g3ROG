# Contributing to the g3ROG Build Dossier

Thanks for helping keep this build dossier clean, useful, and trustworthy.

## What belongs here

- `docs/`: published health reports, summaries, machine pages, and export-ready documentation
- `docs/machines/`: per-machine records for active, historical, and future builds
- `assets/`: public images, social previews, banners, and proof artifacts
- `benchmarks/`: benchmark exports, screenshots, and result summaries
- `logs/`: policy notes only; raw logs and audits remain outside the repository
- `bios/`: BIOS notes, profiles, and tuning guides
- `scripts/`: repeatable repo maintenance and validation helpers

## Contribution rules

- Keep the README as a high-level summary and link out to deeper reports instead of duplicating large blocks of data.
- Put machine-specific material under `docs/machines/<machine>/`.
- When you update time-sensitive data, note the snapshot date in the edited document.
- Redact serial numbers, license keys, local usernames, hostnames, and anything else you would not want indexed publicly.
- Add a file to `.public-site-manifest` only after it passes the repository privacy checks.
- Prefer descriptive filenames with dates or versions when adding new reports or benchmarks.
- Update `CHANGELOG.md` for meaningful repo changes.

## Before opening a PR

- Run `pwsh ./scripts/validate_repo.ps1`
- Run `pwsh ./scripts/build_public_site.ps1` and review only the generated `_site/` artifact
- Run `pre-commit install --hook-type pre-commit --hook-type pre-push` once, then `pre-commit run --all-files`
- Review new media, PDFs, and exports for sensitive information
- Make sure links in `README.md` still point to the latest report files

## Publishing new audits

- Add new long-form reports under the owning machine page or `docs/` and move superseded versions into `docs/archive/` or a dated machine snapshot folder.
- Keep work-in-progress reports outside the repository; `new_audit_report.ps1` defaults to the local application-data folder.
- Keep `docs/LATEST.md` updated so visitors always have one stable place to start.
- Use `docs/templates/system_health_report_template.md` when creating a new report from scratch.
- Use `pwsh ./scripts/new_audit_report.ps1 -SnapshotDate YYYY-MM-DD` if you want a dated draft scaffolded automatically.
- Use `pwsh ./scripts/collect_system_audit.ps1` to gather fresh local inventory and security data outside the repository before writing the next report.
