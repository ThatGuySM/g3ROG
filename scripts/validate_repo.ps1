[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

function Pass([string]$Message) {
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Assert-Contains {
    param(
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$Expected,
        [Parameter(Mandatory = $true)][string]$Context
    )

    if (-not $Content.Contains($Expected)) {
        Fail "$Context is missing expected content: $Expected"
    }
}

function Assert-FileExistsFromMarkdown {
    param(
        [Parameter(Mandatory = $true)][string]$SourceFile,
        [Parameter(Mandatory = $true)][string]$RawPath
    )

    if ([string]::IsNullOrWhiteSpace($RawPath)) {
        return
    }

    $candidate = $RawPath.Trim()

    # Ignore external URLs, mailto links, and intra-document anchors.
    if ($candidate -match '^(https?:|mailto:|#)') {
        return
    }

    # Normalize optional title segment: path "title"
    $normalized = ($candidate -replace '\s+".*$','').Trim()
    if ([string]::IsNullOrWhiteSpace($normalized)) {
        return
    }

    $sourceFullPath = (Resolve-Path -LiteralPath $SourceFile).Path
    $sourceDirectory = Split-Path -Parent $sourceFullPath

    $resolvedPath = [System.IO.Path]::GetFullPath((Join-Path $sourceDirectory $normalized))
    if (-not (Test-Path $resolvedPath)) {
        Fail "$SourceFile references missing local path: $normalized"
    }
}

function Validate-MarkdownLocalLinks {
    param(
        [Parameter(Mandatory = $true)][string]$MarkdownPath
    )

    $content = Get-Content $MarkdownPath -Raw

    # Standard markdown links and image links.
    $matches = [regex]::Matches($content, '!??\[[^\]]+\]\(([^)]+)\)')
    foreach ($match in $matches) {
        $rawTarget = $match.Groups[1].Value
        Assert-FileExistsFromMarkdown -SourceFile $MarkdownPath -RawPath $rawTarget
    }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$requiredFiles = @(
    "README.md",
    "LICENSE",
    "CONTRIBUTING.md",
    "CHANGELOG.md",
    "RELEASE_NOTES_v2.0.0.md",
    "docs/README.md",
    "docs/LATEST.md",
    "docs/machines/README.md",
    "docs/machines/g3rog-dark/README.md",
    "docs/machines/g3rog-dark/specs/G3ROG-DARK-showcase-spec-2026-05-08.md",
    "docs/machines/g3rog-dark/specs/G3ROG-DARK-actual-spec-2026-05-08.md",
    "docs/machines/g3rog-dark/exports/G3ROG-DARK-showcase-spec-2026-05-08.html",
    "docs/machines/g3rog-dark/exports/G3ROG-DARK-actual-spec-2026-05-08.html",
    "docs/machines/g3rog-actual/README.md",
    "docs/machines/son-pc/README.md",
    "assets/images/g3rog-dark-banner-2026-05-08.jpg",
    "assets/social/g3rog-dark-social-preview-2026-05-08.jpg",
    "assets/gallery/g3rog-dark/g3rog-dark-angled-chassis-2026-05-08.jpeg",
    "assets/gallery/g3rog-dark/g3rog-dark-side-panel-front-2026-05-08.jpeg",
    "assets/gallery/g3rog-dark/g3rog-dark-side-panel-close-2026-05-08.jpeg",
    "docs/g3ROG-actual_System_Health_Report.md",
    "docs/g3ROG-actual_System_Health_Report.pdf",
    "docs/g3ROG-actual_Battlestation_Spec_Sheet.md",
    "docs/archive/README.md",
    "docs/drafts/README.md",
    "docs/templates/system_health_report_template.md",
    ".public-site-manifest",
    ".release-allowlist",
    "scripts/build_public_site.ps1",
    "scripts/check_public_privacy.py",
    "scripts/render_markdown_pdf.py",
    "scripts/collect_system_audit.ps1",
    "scripts/export_report_pdf.ps1",
    "scripts/init_repo.ps1",
    "scripts/new_audit_report.ps1",
    "scripts/release.ps1"
)

$requiredDirs = @(
    "assets",
    "benchmarks",
    "bios",
    "docs",
    "docs/machines",
    "logs",
    "scripts"
)

foreach ($path in $requiredFiles) {
    if (-not (Test-Path $path -PathType Leaf)) {
        Fail "Missing required file: $path"
    }
}

foreach ($path in $requiredDirs) {
    if (-not (Test-Path $path -PathType Container)) {
        Fail "Missing required directory: $path"
    }
}

$readme = Get-Content "README.md" -Raw
$docsHub = Get-Content "docs/README.md" -Raw
$latest = Get-Content "docs/LATEST.md" -Raw
$darkMachine = Get-Content "docs/machines/g3rog-dark/README.md" -Raw
$report = Get-Content "docs/g3ROG-actual_System_Health_Report.md" -Raw

$readmeChecks = @(
    "Snapshot Notice",
    "[Latest published entrypoint](docs/LATEST.md)",
    "[Documentation hub](docs/README.md)",
    "[G3ROG-DARK machine page](docs/machines/g3rog-dark/README.md)",
    "Machine Roster"
)

$docsHubChecks = @(
    "[Latest published entrypoint](LATEST.md)",
    "[Machine index](machines/README.md)",
    "[G3ROG-DARK machine page](machines/g3rog-dark/README.md)",
    "archive/",
    "drafts/",
    "templates/"
)

$latestChecks = @(
    "stable entrypoint",
    "[G3ROG-DARK machine page](machines/g3rog-dark/README.md)",
    "[Share-safe friends showcase HTML](machines/g3rog-dark/exports/G3ROG-DARK-showcase-spec-2026-05-08.html)",
    "[g3ROG-actual machine page](machines/g3rog-actual/README.md)"
)

$darkMachineChecks = @(
    "G3ROG-DARK",
    "[Share-safe friends showcase HTML](exports/G3ROG-DARK-showcase-spec-2026-05-08.html)",
    "[Detailed markdown spec](specs/G3ROG-DARK-actual-spec-2026-05-08.md)",
    "![G3ROG-DARK angled chassis photo](../../../assets/gallery/g3rog-dark/g3rog-dark-angled-chassis-2026-05-08.jpeg)",
    "Baseline Snapshot"
)

$reportChecks = @(
    "## Audit Snapshot",
    "point-in-time snapshot"
)

foreach ($check in $readmeChecks) {
    Assert-Contains -Content $readme -Expected $check -Context "README.md"
}

foreach ($check in $docsHubChecks) {
    Assert-Contains -Content $docsHub -Expected $check -Context "docs/README.md"
}

foreach ($check in $latestChecks) {
    Assert-Contains -Content $latest -Expected $check -Context "docs/LATEST.md"
}

foreach ($check in $darkMachineChecks) {
    Assert-Contains -Content $darkMachine -Expected $check -Context "docs/machines/g3rog-dark/README.md"
}

foreach ($check in $reportChecks) {
    Assert-Contains -Content $report -Expected $check -Context "docs/g3ROG-actual_System_Health_Report.md"
}

$bannerMatch = [regex]::Match($readme, '!\[[^\]]*\]\((assets/images/[^)]+)\)')
if (-not $bannerMatch.Success) {
    Fail "README.md is missing the expected top banner image reference"
}

$bannerPath = $bannerMatch.Groups[1].Value
if (-not (Test-Path $bannerPath -PathType Leaf)) {
    Fail "README.md banner image path does not exist: $bannerPath"
}

$markdownFilesToValidate = @(
    "README.md",
    "docs/README.md",
    "docs/LATEST.md",
    "docs/machines/README.md",
    "docs/machines/g3rog-dark/README.md",
    "docs/machines/g3rog-dark/specs/G3ROG-DARK-showcase-spec-2026-05-08.md",
    "docs/machines/g3rog-dark/specs/G3ROG-DARK-actual-spec-2026-05-08.md",
    "docs/machines/g3rog-actual/README.md",
    "docs/machines/son-pc/README.md",
    "docs/GALLERY.md",
    "docs/g3ROG-actual_System_Health_Report.md",
    "docs/g3ROG-actual_Battlestation_Spec_Sheet.md"
)

foreach ($markdownFile in $markdownFilesToValidate) {
    Validate-MarkdownLocalLinks -MarkdownPath $markdownFile
}

$deletedWorkingTreePaths = @(git ls-files --deleted)
$trackedPaths = @(git ls-files | Where-Object { $_ -notin $deletedWorkingTreePaths })
if ($LASTEXITCODE -ne 0) {
    Fail "Unable to inventory tracked files"
}
$forbiddenTrackedPatterns = @(
    '(^|/)\.trash/',
    '^logs/audits/(?!README\.md$)',
    '^docs/drafts/(?!README\.md$)',
    '^docs/aida64/(?!README\.md$)',
    '(^|/)(backups?|browser-data|browser-profile|private|raw)/',
    '(^|/)\.env(?:\.|$)',
    '(?i)(^|/)(Bookmarks|Cookies|History|Login Data|Web Data)$'
)
foreach ($path in $trackedPaths) {
    foreach ($pattern in $forbiddenTrackedPatterns) {
        if ($path -match $pattern) {
            Fail "Tracked path violates the public repository privacy boundary: $path"
        }
    }
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command python3 -ErrorAction SilentlyContinue
}
if (-not $python) {
    Fail "Python is required for public privacy validation"
}
& $python.Source -m unittest discover -s tests -p "test_*.py"
if ($LASTEXITCODE -ne 0) {
    Fail "Public privacy unit tests failed"
}
& "$PSScriptRoot\build_public_site.ps1"
if ($LASTEXITCODE -ne 0) {
    Fail "Public-site build or privacy validation failed"
}

Pass "Required files and directories are present"
Pass "README.md includes machine navigation and snapshot guidance"
Pass "Docs hub and latest-audit entrypoint are present"
Pass "G3ROG-DARK machine page is present"
Pass "System health report includes an audit snapshot notice"
Pass "README banner image path exists"
Pass "Core markdown local links resolve to existing files"
Pass "Tracked files satisfy the public repository privacy boundary"
Pass "Public privacy unit tests pass"
Pass "Explicit public-site artifact builds and validates"
