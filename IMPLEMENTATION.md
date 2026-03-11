# Self-Improving Agent Implementation

自动评估、学习和优化的Agent系统

## 使用方法

在每个Agent执行任务后，自动触发自我评估流程。

---

## 核心脚本

### 1. 任务后评估脚本

保存为：`scripts/self-improvement/evaluate-task.ps1`

```powershell
param(
    [string]$AgentId,
    [string]$TaskId,
    [string]$TaskType,
    [hashtable]$Metrics
)

# 评分计算
$completionScore = $Metrics.completion * 0.3
$efficiencyScore = $Metrics.efficiency * 0.2
$qualityScore = $Metrics.quality * 0.3
$satisfactionScore = $Metrics.satisfaction * 0.2

$totalScore = $completionScore + $efficiencyScore + $qualityScore + $satisfactionScore

# 创建评估记录
$evaluation = @{
    timestamp = Get-Date -Format "o"
    agentId = $AgentId
    taskId = $TaskId
    taskType = $TaskType
    score = [math]::Round($totalScore, 2)
    metrics = $Metrics
}

# 保存评估结果
$evalPath = "$env:USERPROFILE\.openclaw\workspace-dajia\self-improvement\evaluations.json"
if (-not (Test-Path $evalPath)) {
    @{evaluations = @()} | ConvertTo-Json | Set-Content $evalPath
}

$evalData = Get-Content $evalPath | ConvertFrom-Json
$evalData.evaluations += $evaluation
$evalData | ConvertTo-Json -Depth 10 | Set-Content $evalPath

# 触发优化（如果分数<70）
if ($totalScore -lt 70) {
    Write-Host "⚠️  Score below 70, triggering optimization..." -ForegroundColor Yellow
    & "$env:USERPROFILE\.openclaw\workspace-dajia\scripts\self-improvement\optimize-agent.ps1" -AgentId $AgentId
}

return $evaluation
```

### 2. 经验学习脚本

保存为：`scripts/self-improvement/learn-lesson.ps1`

```powershell
param(
    [string]$AgentId,
    [string]$Lesson,
    [string]$Impact,
    [string]$Category
)

# 创建经验记录
$lessonRecord = @{
    id = "lesson-$(Get-Date -Format 'yyyyMMddHHmmss')"
    timestamp = Get-Date -Format "o"
    agent = $AgentId
    lesson = $Lesson
    impact = $Impact
    category = $Category
    applied = $false
}

# 保存到经验库
$lessonsPath = "$env:USERPROFILE\.openclaw\workspace-dajia\self-improvement\lessons-learned.json"
if (-not (Test-Path $lessonsPath)) {
    @{lessons = @()} | ConvertTo-Json | Set-Content $lessonsPath
}

$lessonsData = Get-Content $lessonsPath | ConvertFrom-Json
$lessonsData.lessons += $lessonRecord
$lessonsData | ConvertTo-Json -Depth 10 | Set-Content $lessonsPath

# 同步到共享知识库
$sharedPath = "$env:USERPROFILE\.openclaw\workspace-dajia\shared-context\self-improvement\collective-wisdom.json"
if (-not (Test-Path (Split-Path $sharedPath))) {
    New-Item -ItemType Directory -Path (Split-Path $sharedPath) -Force | Out-Null
}

if (Test-Path $sharedPath) {
    $sharedData = Get-Content $sharedPath | ConvertFrom-Json
    $sharedData.lessons += $lessonRecord
    $sharedData | ConvertTo-Json -Depth 10 | Set-Content $sharedPath
}

Write-Host "✅ Lesson learned and shared" -ForegroundColor Green
```

### 3. 优化执行脚本

保存为：`scripts/self-improvement/optimize-agent.ps1`

```powershell
param(
    [string]$AgentId
)

Write-Host "=== Agent Optimization ===" -ForegroundColor Cyan
Write-Host "Agent: $AgentId"
Write-Host ""

# 分析最近的评估
$evalPath = "$env:USERPROFILE\.openclaw\workspace-dajia\self-improvement\evaluations.json"
if (-not (Test-Path $evalPath)) {
    Write-Host "⚠️  No evaluations found" -ForegroundColor Yellow
    return
}

$evalData = Get-Content $evalPath | ConvertFrom-Json
$recentEvals = $evalData.evaluations | Where-Object { $_.agentId -eq $AgentId } | Sort-Object timestamp -Descending | Select-Object -First 10

if ($recentEvals.Count -eq 0) {
    Write-Host "⚠️  No evaluations for this agent" -ForegroundColor Yellow
    return
}

# 计算平均分
$avgScore = ($recentEvals | Measure-Object score -Average).Average
Write-Host "Average Score: $([math]::Round($avgScore, 2))" -ForegroundColor Cyan

# 识别改进点
$lowScores = $recentEvals | Where-Object { $_.score -lt 70 }
if ($lowScores.Count -gt 0) {
    Write-Host ""
    Write-Host "Areas for Improvement:" -ForegroundColor Yellow

    foreach ($eval in $lowScores) {
        Write-Host "  - Task: $($eval.taskType)" -ForegroundColor Red
        Write-Host "    Score: $($eval.score)" -ForegroundColor Red
        Write-Host "    Time: $($eval.timestamp)" -ForegroundColor Gray
    }

    # 生成优化计划
    $optimizationPlan = @{
        planId = "opt-$(Get-Date -Format 'yyyyMMddHHmmss')"
        agent = $AgentId
        generatedAt = Get-Date -Format "o"
        currentScore = $avgScore
        targetScore = [math]::Min(90, $avgScore + 10)
        actions = @()
    }

    # 添加优化动作
    foreach ($eval in $lowScores) {
        $optimizationPlan.actions += @{
            action = "Review and improve $($eval.taskType) workflow"
            status = "pending"
            priority = "high"
        }
    }

    # 保存优化计划
    $planPath = "$env:USERPROFILE\.openclaw\workspace-dajia\self-improvement\optimization-plan.json"
    $optimizationPlan | ConvertTo-Json -Depth 10 | Set-Content $planPath

    Write-Host ""
    Write-Host "✅ Optimization plan generated" -ForegroundColor Green
} else {
    Write-Host "✅ Performance is good, no immediate optimization needed" -ForegroundColor Green
}
```

### 4. 跨Agent同步脚本

保存为：`scripts/self-improvement/sync-learning.ps1`

```powershell
Write-Host "=== Syncing Learning Across Agents ===" -ForegroundColor Cyan
Write-Host ""

# 读取共享知识库
$sharedPath = "$env:USERPROFILE\.openclaw\workspace-dajia\shared-context\self-improvement\collective-wisdom.json"
if (-not (Test-Path $sharedPath)) {
    Write-Host "⚠️  No shared knowledge found" -ForegroundColor Yellow
    return
}

$sharedData = Get-Content $sharedPath | ConvertFrom-Json
Write-Host "Shared lessons: $($sharedData.lessons.Count)" -ForegroundColor Cyan

# 获取所有Agent
$agentWorkspaces = Get-ChildItem "$env:USERPROFILE\.openclaw" -Directory | Where-Object { $_.Name -like "workspace-*" }

$syncedCount = 0
foreach ($workspace in $agentWorkspaces) {
    $agentId = $workspace.Name -replace "workspace-", ""

    # 同步到各Agent
    $localPath = "$($workspace.FullName)\self-improvement\collective-wisdom.json"
    if (-not (Test-Path (Split-Path $localPath))) {
        New-Item -ItemType Directory -Path (Split-Path $localPath) -Force | Out-Null
    }

    Copy-Item $sharedPath $localPath -Force
    $syncedCount++
}

Write-Host ""
Write-Host "✅ Synced to $syncedCount agents" -ForegroundColor Green
```

---

## 自动集成

### 在每个Agent的任务执行脚本末尾添加：

```powershell
# 任务完成后自动评估
$metrics = @{
    completion = 90  # 完成度 0-100
    efficiency = 85   # 效率 0-100
    quality = 80      # 质量 0-100
    satisfaction = 85 # 满意度 0-100
}

& "$env:USERPROFILE\.openclaw\workspace-dajia\scripts\self-improvement\evaluate-task.ps1" `
    -AgentId "dajia" `
    -TaskId "task-001" `
    -TaskType "创作" `
    -Metrics $metrics
```

---

## 定时任务

### 每日同步（每天2:00）

```powershell
# 添加到定时任务
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File `"$workspace\scripts\self-improvement\sync-learning.ps1`""
$trigger = New-ScheduledTaskTrigger -Daily -At "02:00"
Register-ScheduledTask -TaskName "Self-Improvement Daily Sync" -Action $action -Trigger $trigger
```

### 每周反思（每周日3:00）

```powershell
# 生成周度报告
& "$workspace\scripts\self-improvement\generate-weekly-report.ps1"
```

---

## 监控仪表板

创建仪表板查看所有Agent的改进情况：

位置：`reports\self-improvement-dashboard.html`

---

**让每个Agent都成为终身学习者！**
