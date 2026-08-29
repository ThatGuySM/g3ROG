[CmdletBinding()]
param(
    [datetime]$SnapshotDate = (Get-Date),
    [string]$OutputRoot,
    [switch]$IncludeSensitive
)

$ErrorActionPreference = "Stop"

function To-PrettyJson($InputObject) {
    return ($InputObject | ConvertTo-Json -Depth 6)
}

function Protect-Value([string]$Value, [string]$Replacement = "[redacted]") {
    if ($IncludeSensitive -or [string]::IsNullOrWhiteSpace($Value)) {
        return $Value
    }

    return $Replacement
}

function Protect-PathText([string]$Value) {
    if ($IncludeSensitive -or [string]::IsNullOrWhiteSpace($Value)) {
        return $Value
    }

    $safe = $Value -replace 'C:\\Users\\[^\\"]+', 'C:\Users\<user>'
    $safe = $safe -replace 'THEGALLERS\\[^\\"]+', 'THEGALLERS\<user>'
    return $safe
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $localData = [Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)
    $OutputRoot = Join-Path $localData "g3ROG\audits"
} elseif (-not [System.IO.Path]::IsPathRooted($OutputRoot)) {
    $OutputRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputRoot))
}

$OutputRoot = [System.IO.Path]::GetFullPath($OutputRoot)
$repoPrefix = [System.IO.Path]::GetFullPath($repoRoot).TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
if ($OutputRoot.Equals([System.IO.Path]::GetFullPath($repoRoot), [System.StringComparison]::OrdinalIgnoreCase) -or $OutputRoot.StartsWith($repoPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Audit output must remain outside the public repository: $OutputRoot"
}

$runDir = Join-Path $OutputRoot $SnapshotDate.ToString("yyyy-MM-dd")
$rawDir = Join-Path $runDir "raw"

New-Item -ItemType Directory -Force -Path $rawDir | Out-Null

$computer = Get-CimInstance Win32_ComputerSystem
$os = Get-CimInstance Win32_OperatingSystem
$processor = Get-CimInstance Win32_Processor
$board = Get-CimInstance Win32_BaseBoard
$bios = Get-CimInstance Win32_BIOS
$memory = Get-CimInstance Win32_PhysicalMemory
$gpus = Get-CimInstance Win32_VideoController
$disks = Get-CimInstance Win32_DiskDrive
$startup = Get-CimInstance Win32_StartupCommand | Sort-Object Name
$firewallProfiles = Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
$networkAdapters = Get-NetAdapter | Where-Object { $_.Status -ne "Disabled" } | ForEach-Object {
    [pscustomobject]@{
        Name = $_.Name
        InterfaceDescription = $_.InterfaceDescription
        Status = $_.Status
        LinkSpeed = $_.LinkSpeed
        MacAddress = Protect-Value $_.MacAddress
    }
}
$hotfixes = Get-HotFix | Sort-Object InstalledOn -Descending

$defender = $null
if (Get-Command Get-MpComputerStatus -ErrorAction SilentlyContinue) {
    try {
        $defender = Get-MpComputerStatus | Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, BehaviorMonitorEnabled, IoavProtectionEnabled, IsTamperProtected, NISEnabled, QuickScanAge, RealTimeProtectionEnabled
    } catch {
        $defender = [pscustomobject]@{
            Error = "Get-MpComputerStatus failed: $($_.Exception.Message)"
        }
    }
}

$systemSummary = [pscustomobject]@{
    SnapshotDate = $SnapshotDate.ToString("yyyy-MM-dd")
    ComputerName = $computer.Name
    Manufacturer = $computer.Manufacturer
    Model = $computer.Model
    TotalMemoryGB = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)
    UserName = Protect-Value $computer.UserName "[review before publication]"
    Domain = Protect-Value $computer.Domain "[review before publication]"
    OperatingSystem = $os.Caption
    OSVersion = $os.Version
    BuildNumber = $os.BuildNumber
    LastBootUpTime = $os.LastBootUpTime
    CPU = ($processor | Select-Object -First 1 -ExpandProperty Name)
    Motherboard = "{0} {1}" -f $board.Manufacturer, $board.Product
    BIOSVersion = (($bios.SMBIOSBIOSVersion | Select-Object -First 1) -join ", ")
    BIOSReleaseDate = ($bios.ReleaseDate | Select-Object -First 1)
    LastInstalledHotfix = ($hotfixes | Select-Object -First 1 -ExpandProperty HotFixID)
    LastInstalledHotfixDate = ($hotfixes | Select-Object -First 1 -ExpandProperty InstalledOn)
}

$memorySummary = $memory | Select-Object Manufacturer, PartNumber, Capacity, Speed, ConfiguredClockSpeed
$gpuSummary = $gpus | Select-Object Name, AdapterRAM, DriverVersion, VideoProcessor
$diskSummary = $disks | Select-Object Model, InterfaceType, MediaType, Size
$startupSummary = $startup | ForEach-Object {
    [pscustomobject]@{
        Name = $_.Name
        Command = Protect-PathText $_.Command
        User = Protect-Value $_.User "[redacted]"
    }
}

$reportLines = @(
    "# g3ROG-actual Local Audit Collection",
    "",
    "Snapshot date: $($systemSummary.SnapshotDate)",
    "",
    "## System Summary",
    "",
    "- Computer: $($systemSummary.ComputerName)",
    "- Model: $($systemSummary.Model)",
    "- Operating system: $($systemSummary.OperatingSystem) ($($systemSummary.OSVersion) build $($systemSummary.BuildNumber))",
    "- User/domain: $($systemSummary.UserName) / $($systemSummary.Domain)",
    "- Total memory: $($systemSummary.TotalMemoryGB) GB",
    "- CPU: $($systemSummary.CPU)",
    "- Motherboard: $($systemSummary.Motherboard)",
    "- BIOS: $($systemSummary.BIOSVersion)",
    "- Last Windows hotfix: $($systemSummary.LastInstalledHotfix) on $($systemSummary.LastInstalledHotfixDate)",
    "",
    "## GPU Summary",
    ""
)

foreach ($gpu in $gpuSummary) {
    $vramGB = if ($gpu.AdapterRAM) { [math]::Round($gpu.AdapterRAM / 1GB, 2) } else { "Unknown" }
    $reportLines += "- $($gpu.Name) | VRAM: $vramGB GB | Driver: $($gpu.DriverVersion)"
}

$reportLines += @(
    "",
    "## Storage Summary",
    ""
)

foreach ($disk in $diskSummary) {
    $sizeTB = if ($disk.Size) { [math]::Round($disk.Size / 1TB, 2) } else { "Unknown" }
    $reportLines += "- $($disk.Model) | Interface: $($disk.InterfaceType) | Size: $sizeTB TB"
}

$reportLines += @(
    "",
    "## Firewall Profiles",
    ""
)

foreach ($profile in $firewallProfiles) {
    $reportLines += "- $($profile.Name): Enabled=$($profile.Enabled), Inbound=$($profile.DefaultInboundAction), Outbound=$($profile.DefaultOutboundAction)"
}

$reportLines += @(
    "",
    "## Defender",
    ""
)

if ($defender) {
    $reportLines += "- Antivirus enabled: $($defender.AntivirusEnabled)"
    $reportLines += "- Real-time protection: $($defender.RealTimeProtectionEnabled)"
    $reportLines += "- Tamper protection: $($defender.IsTamperProtected)"
} else {
    $reportLines += "- Defender status unavailable on this system"
}

$reportLines += @(
    "",
    "## Notes",
    "",
    "- Sensors and benchmark results still need manual export from your preferred tools.",
    "- Review usernames, network details, and startup entries before publishing anything from this collection."
)

Set-Content -Path (Join-Path $runDir "summary.md") -Value ($reportLines -join [Environment]::NewLine)
Set-Content -Path (Join-Path $rawDir "system-summary.json") -Value (To-PrettyJson $systemSummary)
Set-Content -Path (Join-Path $rawDir "memory.json") -Value (To-PrettyJson $memorySummary)
Set-Content -Path (Join-Path $rawDir "gpus.json") -Value (To-PrettyJson $gpuSummary)
Set-Content -Path (Join-Path $rawDir "disks.json") -Value (To-PrettyJson $diskSummary)
Set-Content -Path (Join-Path $rawDir "network-adapters.json") -Value (To-PrettyJson $networkAdapters)
Set-Content -Path (Join-Path $rawDir "firewall-profiles.json") -Value (To-PrettyJson $firewallProfiles)
Set-Content -Path (Join-Path $rawDir "startup.json") -Value (To-PrettyJson $startupSummary)

if ($defender) {
    Set-Content -Path (Join-Path $rawDir "defender.json") -Value (To-PrettyJson $defender)
}

Write-Host "[OK] Audit collection written to $runDir" -ForegroundColor Green
Write-Host "[NEXT] Review summary.md and raw/*.json, then update docs/drafts with the sanitized results." -ForegroundColor Cyan
