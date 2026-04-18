#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Brave Browser Debloater for Windows
    Disables all non-core Brave features to mimic Brave Origin

.DESCRIPTION
    This script applies Group Policy registry entries to disable:
      - Leo AI Chat
      - Brave News
      - Brave Rewards & Ads
      - Speedreader
      - Telemetry (P3A, crash logs, daily usage ping)
      - Brave Talk
      - Tor private windows
      - Brave VPN
      - Brave Wallet & Web3
      - Wayback Machine integration
      - Web Discovery Project

    You must run this script as Administrator.

.USAGE
    Right-click PowerShell → Run as Administrator
    Set-ExecutionPolicy -Scope Process RemoteSigned
    .\debloat-brave-windows.ps1

    To restore:
    .\debloat-brave-windows.ps1 -Restore
#>

[CmdletBinding()]
param(
    [switch]$Restore,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

# Configuration
$RegPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
$BackupDir = Join-Path $env:USERPROFILE ".brave-debloat-backups"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Policy definitions: Name -> @{ Value = ...; Type = ... }
# For *Disabled keys: 1 = disabled
# For *Enabled keys: 0 = disabled
$Policies = @{
    BraveRewardsDisabled        = @{ Value = 1;  Type = "DWord" }
    BraveWalletDisabled         = @{ Value = 1;  Type = "DWord" }
    BraveVPNDisabled            = @{ Value = 1;  Type = "DWord" }
    BraveAIChatEnabled          = @{ Value = 0;  Type = "DWord" }
    BraveNewsDisabled           = @{ Value = 1;  Type = "DWord" }
    BraveTalkDisabled           = @{ Value = 1;  Type = "DWord" }
    TorDisabled                 = @{ Value = 1;  Type = "DWord" }
    SyncDisabled                = @{ Value = 1;  Type = "DWord" }
    BraveSpeedreaderEnabled     = @{ Value = 0;  Type = "DWord" }
    BraveWaybackMachineEnabled  = @{ Value = 0;  Type = "DWord" }
    BraveP3AEnabled             = @{ Value = 0;  Type = "DWord" }
    BraveStatsPingEnabled       = @{ Value = 0;  Type = "DWord" }
    BraveWebDiscoveryEnabled    = @{ Value = 0;  Type = "DWord" }
    MetricsReportingEnabled     = @{ Value = 0;  Type = "DWord" }
    PromotionsEnabled           = @{ Value = 0;  Type = "DWord" }
    BackgroundModeEnabled       = @{ Value = 0;  Type = "DWord" }
    BrowserSignin               = @{ Value = 0;  Type = "DWord" }
}

function Write-Header {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║          Brave Browser Debloater for Windows                 ║" -ForegroundColor Cyan
    Write-Host "║     Disables bloat to mimic Brave Origin experience          ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-BraveRunning {
    $proc = Get-Process -Name "brave" -ErrorAction SilentlyContinue
    return ($null -ne $proc)
}

function Backup-Registry {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        Write-Host "   No existing policies to backup." -ForegroundColor DarkGray
        return $null
    }
    
    $backupPath = Join-Path $BackupDir $Timestamp
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    
    $regFile = Join-Path $backupPath "brave-policies-backup.reg"
    
    # Export existing registry key
    $cmd = "reg.exe export `"HKLM\SOFTWARE\Policies\BraveSoftware\Brave`" `"$regFile`" /y 2>&1"
    $output = Invoke-Expression $cmd
    
    if (Test-Path $regFile) {
        Write-Host "   ✓ Backed up existing policies to: $regFile" -ForegroundColor Green
        return $regFile
    } else {
        Write-Host "   ⚠ Could not export registry backup. Proceeding anyway..." -ForegroundColor Yellow
        return $null
    }
}

function Apply-Policies {
    Write-Host "Applying Brave debloat policies to registry..." -ForegroundColor Cyan
    Write-Host ""
    
    # Create/ensure registry path exists
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }
    
    foreach ($policy in $Policies.GetEnumerator() | Sort-Object Name) {
        $name = $policy.Key
        $value = $policy.Value.Value
        $type = $policy.Value.Type
        
        Set-ItemProperty -Path $RegPath -Name $name -Value $value -Type $type -Force
        Write-Host "   ✓ Set $name = $value" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "✓ All policies applied successfully." -ForegroundColor Green
}

function Show-Summary {
    Write-Host ""
    Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "  Debloating complete!" -ForegroundColor Green
    Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "The following features have been DISABLED:"
    Write-Host "  • Leo AI Chat"
    Write-Host "  • Brave News"
    Write-Host "  • Brave Rewards & Ads"
    Write-Host "  • Speedreader"
    Write-Host "  • Telemetry (P3A, crash logs, daily usage ping)"
    Write-Host "  • Brave Talk"
    Write-Host "  • Tor private windows"
    Write-Host "  • Brave VPN"
    Write-Host "  • Brave Wallet & Web3"
    Write-Host "  • Wayback Machine integration"
    Write-Host "  • Web Discovery Project"
    Write-Host ""
    Write-Host "IMPORTANT: Please restart Brave Browser for all changes to take effect." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You can verify policies are active by visiting:"
    Write-Host "  brave://policy"
    Write-Host ""
    Write-Host "To undo these changes, run:" -ForegroundColor Cyan
    Write-Host "  .\debloat-brave-windows.ps1 -Restore" -ForegroundColor Cyan
    Write-Host ""
}

function Restore-Backup {
    Write-Host ""
    Write-Host "Available backups:" -ForegroundColor Cyan
    
    if (-not (Test-Path $BackupDir)) {
        Write-Host "   No backup directory found." -ForegroundColor Red
        return
    }
    
    $backups = Get-ChildItem -Path $BackupDir -Directory | Sort-Object Name
    
    if ($backups.Count -eq 0) {
        Write-Host "   No backups found." -ForegroundColor Red
        return
    }
    
    $index = 1
    foreach ($b in $backups) {
        Write-Host "  $index) $($b.Name)"
        $index++
    }
    Write-Host ""
    
    $choice = Read-Host "Select a backup to restore (1-$($backups.Count))"
    
    if ($choice -match '^\d+$') {
        $num = [int]$choice
        if ($num -ge 1 -and $num -le $backups.Count) {
            $selected = $backups[$num - 1]
            $regFile = Join-Path $selected.FullName "brave-policies-backup.reg"
            
            if (Test-Path $regFile) {
                Write-Host ""
                Write-Host "Restoring from: $($selected.Name)" -ForegroundColor Yellow
                $confirm = Read-Host "Are you sure? [y/N]"
                if ($confirm -match '^[Yy]$') {
                    $cmd = "reg.exe import `"$regFile`" 2>&1"
                    $output = Invoke-Expression $cmd
                    Write-Host "   ✓ Registry restored." -ForegroundColor Green
                    Write-Host "   Please restart Brave Browser." -ForegroundColor Cyan
                } else {
                    Write-Host "   Restore cancelled." -ForegroundColor Gray
                }
            } else {
                Write-Host "   Backup file not found inside folder." -ForegroundColor Red
            }
        } else {
            Write-Host "   Invalid selection." -ForegroundColor Red
        }
    } else {
        Write-Host "   Invalid input." -ForegroundColor Red
    }
}

function Show-Help {
    @"
Brave Browser Debloater for Windows

Usage:
  .\debloat-brave-windows.ps1          Apply debloat policies
  .\debloat-brave-windows.ps1 -Restore Restore from a previous backup
  .\debloat-brave-windows.ps1 -Help    Show this help message

This script disables Brave's non-core features by writing Group Policy registry
entries under HKLM:\SOFTWARE\Policies\BraveSoftware\Brave.

You must run PowerShell as Administrator to use this script.

Quick start:
  1. Close Brave completely
  2. Right-click PowerShell → Run as Administrator
  3. cd to the folder containing this script
  4. Set-ExecutionPolicy -Scope Process RemoteSigned
  5. .\debloat-brave-windows.ps1
  6. Restart Brave and visit brave://policy to verify
"@
}

# ─── Main Entry ───
if ($Help) {
    Show-Help
    exit 0
}

Write-Header

if (-not (Test-Admin)) {
    Write-Host "ERROR: This script must be run as Administrator." -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'." -ForegroundColor Yellow
    exit 1
}

if ($Restore) {
    Restore-Backup
    exit 0
}

if (Test-BraveRunning) {
    Write-Host "WARNING: Brave Browser appears to be running." -ForegroundColor Yellow
    Write-Host "Please close Brave completely before continuing." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Press [Enter] to continue after closing Brave, or type 'exit' to quit"
    if ($continue -eq "exit") { exit 0 }
    
    if (Test-BraveRunning) {
        Write-Host "Brave is still running. Exiting." -ForegroundColor Red
        exit 1
    }
}

Write-Host "Creating backup of existing policies..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
$backupFile = Backup-Registry -Path $RegPath

Apply-Policies
Show-Summary
