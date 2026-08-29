[CmdletBinding()]
param(
    [string]$InputMarkdown = "docs/g3ROG-actual_System_Health_Report.md",
    [string]$OutputPdf = "docs/g3ROG-actual_System_Health_Report.pdf"
)

$ErrorActionPreference = "Stop"

function Resolve-RepoPath([string]$PathValue, [string]$RepoRoot) {
    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }
    return [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $PathValue))
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$inputPath = Resolve-RepoPath $InputMarkdown $repoRoot
$outputPath = Resolve-RepoPath $OutputPdf $repoRoot

if (-not (Test-Path -LiteralPath $inputPath -PathType Leaf)) {
    throw "Input markdown not found: $inputPath"
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command python3 -ErrorAction SilentlyContinue
}
if (-not $python) {
    throw "Python with reportlab and pypdf is required to export and validate PDFs"
}

& $python.Source (Join-Path $PSScriptRoot "render_markdown_pdf.py") --input $inputPath --output $outputPath
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $outputPath -PathType Leaf)) {
    throw "PDF export failed: $outputPath"
}

& $python.Source (Join-Path $PSScriptRoot "check_public_privacy.py") --file $outputPath
if ($LASTEXITCODE -ne 0) {
    throw "Generated PDF failed privacy validation"
}

Write-Host "[OK] Exported and privacy-validated PDF: $outputPath" -ForegroundColor Green
