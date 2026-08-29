# Drafts

Store in-progress report drafts here before they are published.

Recommended flow:

1. Create a new draft with `pwsh ../scripts/new_audit_report.ps1 -SnapshotDate YYYY-MM-DD`
2. Collect fresh local data with `pwsh ../scripts/collect_system_audit.ps1`
3. Review and redact anything sensitive
4. Promote the finished report into the root of `docs/`
