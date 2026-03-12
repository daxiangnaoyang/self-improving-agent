# Lesson Learning Script
# Simplified version

param(
    [Parameter(Mandatory=$true)]
    [string]$AgentId,
    [Parameter(Mandatory=$true)]
    [string]$Lesson,
    [Parameter(Mandatory=$true)]
    [string]$Impact,
    [Parameter(Mandatory=$true)]
    [string]$Category
)

# Load configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\config.ps1"

# Create lesson record
$lessonRecord = @{
    id = "lesson-$(Get-Date -Format 'yyyyMMddHHmmss')"
    timestamp = Get-Date -Format "o"
    agent = $AgentId
    lesson = $Lesson
    impact = $Impact
    category = $Category
    applied = $false
}

# Save to local lessons
$lessonsPath = Join-Path $SCRIPT:SelfImprovementDir "lessons-learned.json"

if (-not (Test-Path $lessonsPath)) {
    @{lessons = @()} | ConvertTo-Json | Set-Content $lessonsPath -Encoding UTF8
}

$lessonsData = Get-Content $lessonsPath -Raw | ConvertFrom-Json
$lessonsData.lessons += $lessonRecord
$lessonsData | ConvertTo-Json -Depth 10 | Set-Content $lessonsPath -Encoding UTF8

# Sync to shared knowledge
$sharedPath = Join-Path $SCRIPT:SharedContextDir "collective-wisdom.json"

if (Test-Path $sharedPath) {
    $sharedData = Get-Content $sharedPath -Raw | ConvertFrom-Json
    
    if (-not $sharedData.lessons) {
        $sharedData | Add-Member -Type NoteProperty -Name "lessons" -Value @() -Force
    }
    
    $sharedData.lessons += $lessonRecord
    $sharedData | ConvertTo-Json -Depth 10 | Set-Content $sharedPath -Encoding UTF8
} else {
    @{lessons = @($lessonRecord)} | ConvertTo-Json -Depth 10 | Set-Content $sharedPath -Encoding UTF8
}

# Output
Write-Host ""
Write-Host "=== Lesson Learned ===" -ForegroundColor Green
Write-Host "Agent: $AgentId"
Write-Host "Category: $Category"
Write-Host "Lesson: $Lesson"
Write-Host ""
Write-Host "Lesson recorded and shared" -ForegroundColor Green
Write-Host ""
