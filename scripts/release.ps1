Param(
    [Parameter(Mandatory=$true)][string]$Version,   # e.g., v1.1.0
    [Parameter(Mandatory=$true)][string]$Notes      # short summary
)

function Step($m){ Write-Host ">> $m" -ForegroundColor Cyan }
function Ok($m){ Write-Host "[OK] $m" -ForegroundColor Green }
function Warn($m){ Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Err($m){ Write-Host "[ERR] $m" -ForegroundColor Red }

# Pre-checks
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Err "Git not found"; exit 1 }

# Ensure we're in a git repo
if (-not (Test-Path ".git")) { Err "Not a git repo. Run inside your repo root."; exit 1 }

Step "Validating repository and explicit public-site boundary"
& "$PSScriptRoot\validate_repo.ps1"
if ($LASTEXITCODE -ne 0) { Err "Repository validation failed"; exit 1 }

$stagedPaths = @(git diff --cached --name-only --diff-filter=ACMRD)
if ($stagedPaths.Count -eq 0) {
  Err "No explicitly staged release changes. Review and stage the exact intended files before running this script."
  exit 1
}
$publishableStagedPaths = @(git diff --cached --name-only --diff-filter=ACMR)
$unstagedPaths = @(git diff --name-only)
$indexWorktreeMismatch = @($publishableStagedPaths | Where-Object { $_ -in $unstagedPaths })
if ($indexWorktreeMismatch.Count -gt 0) {
  Err "Staged files differ from the privacy-validated working tree: $($indexWorktreeMismatch -join ', ')"
  exit 1
}

$allowedReleasePaths = @(
  Get-Content -LiteralPath ".public-site-manifest", ".release-allowlist" |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith("#") }
)
foreach ($path in $publishableStagedPaths) {
  if ($path -notin $allowedReleasePaths) {
    Err "Staged release path is not explicitly allowlisted: ${path}"
    exit 1
  }
}

# Create release branch
$branch = "release/$Version"
git rev-parse --verify $branch 1>$null 2>$null
if ($LASTEXITCODE -eq 0) { Err "Branch $branch already exists."; exit 1 }
Step "Creating branch $branch"
git checkout -b $branch 2>$null

# Commit
if ($stagedPaths.Count -gt 0) {
  Step "Committing changes"
  git commit -m "${Version}: $Notes" | Out-Null
} else {
  Warn "No changes detected to commit"
}

# Push branch
Step "Pushing branch $branch"
git push -u origin $branch

Warn "Open a Pull Request on GitHub for $branch, review and merge when green."
Read-Host "Press ENTER after PR is merged to continue tagging"

# Sync main and tag
Step "Syncing main"
git checkout main
git pull

Step "Tagging $Version"
git tag $Version -m "g3ROG-actual $Version — $Notes"
git push --tags

Ok "Done. Tagged $Version."
