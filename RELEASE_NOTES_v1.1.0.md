# g3ROG-actual v1.1.0 - 2026 Audit Refresh

This release promotes the April 15, 2026 system snapshot into the main public report set and turns the repo into a cleaner repeatable audit workflow.

---

## Highlights

- Published the 2026 system health report as the primary markdown snapshot
- Regenerated the public PDF so it matches the current markdown report
- Added a stable docs entrypoint with `docs/LATEST.md` and a clearer docs hub
- Added a public battlestation spec sheet and refreshed BIOS profile notes
- Archived the 2025 markdown and PDF snapshots for historical reference
- Added reusable audit tooling for collection, validation, report scaffolding, and PDF export
- Replaced placeholder CI behavior with real repository validation checks
- Removed the accidental tracked workspace file from the repo

---

## 2026 Snapshot Highlights

- Computer name normalized to `g3ROG-actual`
- Windows 11 Enterprise build `26200.8246`
- AMD Ryzen 7 9800X3D
- NVIDIA GeForce RTX 5090
- Frontier multi-gig connectivity with fresh desktop and gateway speed tests
- Updated monitor inventory, BIOS restore profile, sensor snapshot, and AIDA64 benchmark results

---

## Repo Improvements

- `docs/` now has a current-vs-archive structure with draft and template support
- `logs/audits/` now holds sanitized evidence for published snapshots
- `scripts/` now supports repeatable audit collection and PDF generation
- `.gitignore`, contribution docs, and issue/PR templates are aligned with the new workflow

---

## Tag Info

- Tag: `v1.1.0`
- Release date: `2026-04-15`
- Base commit: `b391356`
