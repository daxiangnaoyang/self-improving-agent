# Task Evaluation Script
# Simplified version

param(
    [Parameter(Mandatory=$true)]
    [string]$AgentId,
    [Parameter(Mandatory=$true)]
    [string]$TaskId,
    [Parameter(Mandatory=$true)]
    [string]$TaskType,
    [Parameter(Mandatory=$true)]
    [int]$Completion,
    [Parameter(Mandatory=$true)]
    [int]$Efficiency,
    [Parameter(Mandatory=$true)]
    [int]$Quality,
    [Parameter(Mandatory=$true)]
    [int]$Satisfaction
)

# Load configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\config.ps1"

# Calculate score
$totalScore = ($Completion * 0.3) + ($Efficiency * 0.2) + ($Quality * 0.3) + ($Satisfaction * 0.2)

# Create evaluation record
$evaluation = @{
    timestamp = Get-Date -Format "o"
    agentId = $AgentId
    taskId = $TaskId
    taskType = $TaskType
    score = [math]::Round($totalScore, 2)
    metrics = @{
        completion = $Completion
        efficiency = $Efficiency
        quality = $Quality
        satisfaction = $Satisfaction
    }
}

# Save to file
$evalPath = Join-Path $SCRIPT:SelfImprovementDir "evaluations.json"

if (-not (Test-Path $evalPath)) {
    @{evaluations = @()} | ConvertTo-Json | Set-Content $evalPath -Encoding UTF8
}

$evalData = Get-Content $evalPath -Raw | ConvertFrom-Json
$evalData.evaluations += $evaluation
$evalData | ConvertTo-Json -Depth 10 | Set-Content $evalPath -Encoding UTF8

# Output
Write-Host ""
Write-Host "=== Task Evaluation ===" -ForegroundColor Cyan
Write-Host "Agent: $AgentId"
Write-Host "Task: $TaskType ($TaskId)"
Write-Host "Score: $([math]::Round($totalScore, 2))/100"
Write-Host ""

# Trigger optimization if score < 70
if ($totalScore -lt 70) {
    Write-Host "Score below 70, triggering optimization..." -ForegroundColor Yellow
    & "$ScriptDir\optimize-agent.ps1" -AgentId $AgentId
}

return $evaluation
