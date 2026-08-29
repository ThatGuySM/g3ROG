# Docs Hub

This folder is the public documentation center for the **g3ROG** build dossier.
If you are visiting for the first time, start with `LATEST.md`.

## Start Here

- [Latest published entrypoint](LATEST.md)
- [Machine index](machines/README.md)
- [G3ROG-DARK machine page](machines/g3rog-dark/README.md)
- [G3ROG-DARK current spec](machines/g3rog-dark/specs/G3ROG-DARK-current-spec-2026-05-09.md)
- [G3ROG-DARK current spec HTML](machines/g3rog-dark/exports/G3ROG-DARK-current-spec-2026-05-09.html)
- [G3ROG-DARK BIOS settings](machines/g3rog-dark/bios-settings.md)
- [G3ROG-DARK stability validation](machines/g3rog-dark/validation/stability-validation-2026-05-09.md)
- [AIDA64 source notes](aida64/README.md)
- [G3ROG-DARK friends showcase HTML](machines/g3rog-dark/exports/G3ROG-DARK-showcase-spec-2026-05-08.html)
- [G3ROG-DARK detailed actual HTML](machines/g3rog-dark/exports/G3ROG-DARK-actual-spec-2026-05-08.html)
- [Visual gallery](GALLERY.md)

## Historical g3ROG-actual Records

- [g3ROG-actual machine page](machines/g3rog-actual/README.md)
- [April 2026 system health report](g3ROG-actual_System_Health_Report.md)
- [April 2026 PDF report](g3ROG-actual_System_Health_Report.pdf)
- [April 2026 battlestation spec sheet](g3ROG-actual_Battlestation_Spec_Sheet.md)
- [BIOS tuning notes](../bios/g3rog_actual_bios_full_profile.md)

## Folder Layout

- `machines/`: active, retired, and future machine pages
- `drafts/`: in-progress report drafts that have not been published yet
- `archive/`: older reports and retired published snapshots
- `templates/`: reusable templates for future report updates
- `aida64/`: sanitized AIDA64-derived source summaries and privacy notes
- root of `docs/`: stable docs, current spec, BIOS settings, stability plan, galleries, historical reports, and entrypoints

## Publishing Flow

1. Decide which machine owns the update.
2. Run `pwsh ../scripts/new_audit_report.ps1 -SnapshotDate YYYY-MM-DD` when creating a new report draft.
3. Use `pwsh ../scripts/collect_system_audit.ps1` to gather fresh local system data into `logs/audits/`.
4. Review every public page for private identifiers before publication.
5. Keep current machine pages under `machines/<machine>/`.
6. Save superseded public reports into `archive/` or a dated machine snapshot folder.
7. Run `pwsh ../scripts/export_report_pdf.ps1` only for reports that need a PDF export.
8. Update `LATEST.md` so visitors always land on the newest published snapshot first.

## Notes

- Treat markdown in this docs folder as publishable public content unless a page explicitly says otherwise.
- Keep raw reports and private identifiers outside public docs.
- The old `g3ROG-actual_Battlestation_Spec_Sheet.md` is now historical, not the current flagship spec.
