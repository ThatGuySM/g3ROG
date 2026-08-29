Param(
    [string]$RepoName = "g3ROG-actual",
    [string]$GitHubUser = "ThatGuySM",
    [switch]$ForceHttps,
    [switch]$AutoCommit
)
function Msg($t,$c) { Write-Host $t -ForegroundColor $c }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Msg "Git not installed" Red; exit 1 }
$userProfile = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
$hasSSH = Test-Path (Join-Path $userProfile ".ssh\id_rsa.pub")
$hasGh  = [bool](Get-Command gh -ErrorAction SilentlyContinue)
if (-not (Test-Path ".git")) { git init | Out-Null; git checkout -b main 2>$null | Out-Null }
git rev-parse --verify HEAD 1>$null 2>$null
$hasCommit = ($LASTEXITCODE -eq 0)
$hasChanges = [bool](git status --porcelain)
if (-not $hasCommit -and $hasChanges -and -not $AutoCommit) {
  Msg "No initial commit exists yet. Commit manually or rerun with -AutoCommit." Yellow
  exit 1
}
if ($hasChanges -and $AutoCommit) {
  Msg "Automatic staging is disabled for this public repository. Review files, run scripts/validate_repo.ps1, and stage an explicit file list." Red
  exit 1
}
$ssh = "git@github.com:$GitHubUser/$RepoName.git"
$https = "https://github.com/$GitHubUser/$RepoName.git"
$remote = if ($hasSSH -and -not $ForceHttps) { $ssh } else { $https }
if (-not (git remote | Select-String -SimpleMatch "origin")) { git remote add origin $remote }
if ($hasGh) {
  gh repo view "$GitHubUser/$RepoName" 1>$null 2>$null
  if ($LASTEXITCODE -ne 0) { gh repo create "$GitHubUser/$RepoName" --public --source "." --push; exit 0 }
} else {
  Write-Host "If repo doesn't exist, create it at https://github.com/new (Name: $RepoName) then press ENTER..."
  Read-Host
}
git push -u origin main
if (-not ((git tag) -contains "v1.0.0")) { git tag v1.0.0 -m "Launch: g3ROG-actual v1.0.0"; git push --tags }
Msg "Done. https://github.com/$GitHubUser/$RepoName" Green
