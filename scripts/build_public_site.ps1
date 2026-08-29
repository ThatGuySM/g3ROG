[CmdletBinding()]
param(
    [string]$OutputRoot = "_site",
    [string]$ManifestPath = ".public-site-manifest"
)

$ErrorActionPreference = "Stop"

function Fail([string]$Message) {
    Write-Error $Message
    exit 1
}

$repoRoot = [System.IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$outputPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    [System.IO.Path]::GetFullPath($OutputRoot)
} else {
    [System.IO.Path]::GetFullPath((Join-Path $repoRoot $OutputRoot))
}
$manifest = if ([System.IO.Path]::IsPathRooted($ManifestPath)) {
    [System.IO.Path]::GetFullPath($ManifestPath)
} else {
    [System.IO.Path]::GetFullPath((Join-Path $repoRoot $ManifestPath))
}

$repoPrefix = $repoRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
if (-not $outputPath.StartsWith($repoPrefix, [System.StringComparison]::OrdinalIgnoreCase) -or $outputPath -eq $repoRoot) {
    Fail "Output path must be a child of the repository root: $outputPath"
}
if (-not (Test-Path -LiteralPath $manifest -PathType Leaf)) {
    Fail "Public-site manifest not found: $manifest"
}

$entries = @(
    Get-Content -LiteralPath $manifest |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith("#") }
)
if ($entries.Count -eq 0) {
    Fail "Public-site manifest is empty"
}

if (Test-Path -LiteralPath $outputPath) {
    Remove-Item -LiteralPath $outputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $outputPath | Out-Null

foreach ($entry in $entries) {
    if ($entry -match '[\\*?\[\]{}]' -or $entry.StartsWith("/") -or $entry.Split('/') -contains "..") {
        Fail "Manifest entry is not an exact normalized path: $entry"
    }
    $source = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $entry))
    if (-not $source.StartsWith($repoPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        Fail "Manifest entry escapes the repository: $entry"
    }
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        Fail "Manifest source does not exist: $entry"
    }
    $destination = Join-Path $outputPath ($entry -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command python3 -ErrorAction SilentlyContinue
}
if (-not $python) {
    Fail "Python is required for public privacy validation"
}

& $python.Source (Join-Path $PSScriptRoot "check_public_privacy.py") `
    --repo-root $repoRoot `
    --site-root $outputPath `
    --manifest $manifest
if ($LASTEXITCODE -ne 0) {
    Fail "Public-site privacy validation failed"
}

Write-Host "[OK] Built validated public site from $($entries.Count) explicitly allowed files: $outputPath" -ForegroundColor Green
