# Cross-Agent Learning Synchronization
# Simplified version

# Load configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\config.ps1"

Write-Host ""
Write-Host "=== Syncing Learning Across Agents ===" -ForegroundColor Cyan
Write-Host ""

# Read shared knowledge
$sharedPath = Join-Path $SCRIPT:SharedContextDir "collective-wisdom.json"

if (-not (Test-Path $sharedPath)) {
    Write-Host "No shared knowledge found. Run learn-lesson.ps1 first." -ForegroundColor Yellow
    exit 0
}

$sharedData = Get-Content $sharedPath -Raw | ConvertFrom-Json
$lessonCount = if ($sharedData.lessons) { $sharedData.lessons.Count } else { 0 }

if ($lessonCount -eq 0) {
    Write-Host "No lessons to sync" -ForegroundColor Yellow
    exit 0
}

Write-Host "Source: $SCRIPT:Workspace"
Write-Host "Lessons to sync: $lessonCount"
Write-Host ""

# Get all agent workspaces
$openclawDir = "$env:USERPROFILE\.openclaw"
$agentWorkspaces = Get-ChildItem $openclawDir -Directory | 
                   Where-Object { $_.Name -like "workspace-*" }

$syncedCount = 0
$skippedCount = 0

foreach ($workspace in $agentWorkspaces) {
    # Skip source directory
    if ($workspace.FullName -eq $SCRIPT:Workspace) {
        $skippedCount++
        continue
    }

    # Create target directory
    $targetDir = Join-Path $workspace.FullName "shared-context\self-improvement"
    
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Copy shared knowledge
    $targetPath = Join-Path $targetDir "collective-wisdom.json"
    Copy-Item $sharedPath $targetPath -Force
    $syncedCount++

    Write-Host "Synced to: $($workspace.Name)" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Sync Summary ===" -ForegroundColor Cyan
Write-Host "Synced to: $syncedCount agents"
Write-Host "Skipped: $skippedCount (source)"
Write-Host "Total lessons: $lessonCount"
Write-Host ""
Write-Host "All agents now have access to shared knowledge" -ForegroundColor Green
Write-Host ""
