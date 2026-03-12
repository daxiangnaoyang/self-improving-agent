# Agent Optimization Script
# 分析评估记录并生成优化计划

param(
    [Parameter(Mandatory=$true)]
    [string]$AgentId
)

# 加载配置
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\config.ps1"

Write-Host ""
Write-Host "=== Agent Optimization ===" -ForegroundColor Cyan
Write-Host "Agent: $AgentId"
Write-Host ""

# 分析最近的评估
$evalPath = Join-Path $SCRIPT:SelfImprovementDir "evaluations.json"

if (-not (Test-Path $evalPath)) {
    Write-Host "⚠️  No evaluations found. Run evaluate-task.ps1 first." -ForegroundColor Yellow
    return
}

$evalData = Get-Content $evalPath -Raw | ConvertFrom-Json
$recentEvals = $evalData.evaluations | 
                Where-Object { $_.agentId -eq $AgentId } | 
                Sort-Object { $_.timestamp } -Descending | 
                Select-Object -First 10

if ($recentEvals.Count -eq 0) {
    Write-Host "⚠️  No evaluations for this agent" -ForegroundColor Yellow
    return
}

# 计算平均分
$avgScore = ($recentEvals | Measure-Object -Property score -Average).Average
Write-Host "Recent Performance:" -ForegroundColor Cyan
Write-Host "  Average Score: $([math]::Round($avgScore, 2))/100" -ForegroundColor $(if ($avgScore -ge 80) { "Green" } elseif ($avgScore -ge 70) { "Yellow" } else { "Red" })
Write-Host "  Evaluated Tasks: $($recentEvals.Count)"
Write-Host ""

# 识别改进点
$lowScores = $recentEvals | Where-Object { $_.score -lt 70 }

if ($lowScores.Count -gt 0) {
    Write-Host "Areas for Improvement:" -ForegroundColor Yellow
    
    foreach ($eval in $lowScores) {
        Write-Host "  - Task: $($eval.taskType)" -ForegroundColor Red
        Write-Host "    Score: $($eval.score)" -ForegroundColor Red
        Write-Host "    Time: $($eval.timestamp)" -ForegroundColor DarkGray
    }

    # 生成优化计划
    $optimizationPlan = @{
        planId = "opt-$(Get-Date -Format 'yyyyMMddHHmmss')"
        agent = $AgentId
        generatedAt = Get-Date -Format "o"
        currentScore = [math]::Round($avgScore, 2)
        targetScore = [math]::Min(90, [math]::Round($avgScore + 10, 2))
        actions = @()
    }

    # 添加优化动作
    foreach ($eval in $lowScores) {
        $optimizationPlan.actions += @{
            action = "Review and improve $($eval.taskType) workflow"
            status = "pending"
            priority = "high"
            relatedTask = $eval.taskId
        }
    }

    # 添加通用优化建议
    if ($avgScore -lt 70) {
        $optimizationPlan.actions += @{
            action = "Review recent lessons-learned.json for patterns"
            status = "pending"
            priority = "medium"
        }
        
        $optimizationPlan.actions += @{
            action = "Consider updating skills or tools"
            status = "pending"
            priority = "medium"
        }
    }

    # 保存优化计划
    $planPath = Join-Path $SCRIPT:SelfImprovementDir "optimization-plan.json"
    $optimizationPlan | ConvertTo-Json -Depth 10 | Set-Content $planPath -Encoding UTF8

    Write-Host ""
    Write-Host "✅ Optimization plan generated" -ForegroundColor Green
    Write-Host "   Target Score: $($optimizationPlan.targetScore)" -ForegroundColor Cyan
    Write-Host "   Actions: $($optimizationPlan.actions.Count)" -ForegroundColor Cyan
} else {
    Write-Host "✅ Performance is good, no immediate optimization needed" -ForegroundColor Green
    
    # 如果分数在 80-89 之间，提供主动优化建议
    if ($avgScore -ge 80 -and $avgScore -lt 90) {
        Write-Host ""
        Write-Host "💡 Suggestion for excellence:" -ForegroundColor Cyan
        Write-Host "   Review best practices in evaluations.json to reach >90" -ForegroundColor DarkGray
    }
}

Write-Host ""
