# Self-Improving Agent Implementation

自动评估、学习和优化的Agent系统

## 使用方法

在每个Agent执行任务后，自动触发自我评估流程。

---

## 核心脚本

### 0. 通用配置脚本

保存为：`scripts/self-improvement/config.ps1`

```powershell
# 自动检测当前 Agent 工作区
function Get-AgentWorkspace {
    # 查找所有 workspace-* 目录
    $workspaces = Get-ChildItem "$env:USERPROFILE\.openclaw" -Directory | 
                  Where-Object { $_.Name -like "workspace-*" }
    
    if ($workspaces.Count -eq 1) {
        # 只有一个工作区，直接返回
        return $workspaces[0].FullName
    } elseif ($workspaces.Count -gt 1) {
        # 多个工作区，通过环境变量或当前目录判断
        $currentDir = Get-Location
        foreach ($ws in $workspaces) {
            if ($currentDir.Path -like "$($ws.FullName)*") {
                return $ws.FullName
            }
        }
        # 默认返回第一个
        return $workspaces[0].FullName
    } else {
        throw "No workspace found in .openclaw directory"
    }
}

# 导出配置
$SCRIPT:Workspace = Get-AgentWorkspace
$SCRIPT:SelfImprovementDir = Join-Path $SCRIPT:Workspace "self-improvement"
$SCRIPT:SharedContextDir = Join-Path $SCRIPT:Workspace "shared-context\self-improvement"

# 确保目录存在
if (-not (Test-Path $SCRIPT:SelfImprovementDir)) {
    New-Item -ItemType Directory -Path $SCRIPT:SelfImprovementDir -Force | Out-Null
}
if (-not (Test-Path $SCRIPT:SharedContextDir)) {
    New-Item -ItemType Directory -Path $SCRIPT:SharedContextDir -Force | Out-Null
}
```

### 1. 任务后评估脚本

保存为：`scripts/self-improvement/evaluate-task.ps1`

```powershell
param(
    [string]$AgentId,
    [string]$TaskId,
    [string]$TaskType,
    [hashtable]$Metrics
)

# 加载配置
. "$PSScriptRoot\config.ps1"

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
$evalPath = Join-Path $SCRIPT:SelfImprovementDir "evaluations.json"
if (-not (Test-Path $evalPath)) {
    @{evaluations = @()} | ConvertTo-Json | Set-Content $evalPath
}

$evalData = Get-Content $evalPath | ConvertFrom-Json
$evalData.evaluations += $evaluation
$evalData | ConvertTo-Json -Depth 10 | Set-Content $evalPath

# 触发优化（如果分数<70）
if ($totalScore -lt 70) {
    Write-Host "⚠️  Score below 70, triggering optimization..." -ForegroundColor Yellow
    & "$PSScriptRoot\optimize-agent.ps1" -AgentId $AgentId
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

# 加载配置
. "$PSScriptRoot\config.ps1"

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
$lessonsPath = Join-Path $SCRIPT:SelfImprovementDir "lessons-learned.json"
if (-not (Test-Path $lessonsPath)) {
    @{lessons = @()} | ConvertTo-Json | Set-Content $lessonsPath
}

$lessonsData = Get-Content $lessonsPath | ConvertFrom-Json
$lessonsData.lessons += $lessonRecord
$lessonsData | ConvertTo-Json -Depth 10 | Set-Content $lessonsPath

# 同步到共享知识库
$sharedPath = Join-Path $SCRIPT:SharedContextDir "collective-wisdom.json"
if (Test-Path $sharedPath) {
    $sharedData = Get-Content $sharedPath | ConvertFrom-Json
    if (-not $sharedData.lessons) {
        $sharedData | Add-Member -Type NoteProperty -Name "lessons" -Value @()
    }
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

# 加载配置
. "$PSScriptRoot\config.ps1"

Write-Host "=== Agent Optimization ===" -ForegroundColor Cyan
Write-Host "Agent: $AgentId"
Write-Host ""

# 分析最近的评估
$evalPath = Join-Path $SCRIPT:SelfImprovementDir "evaluations.json"
if (-not (Test-Path $evalPath)) {
    Write-Host "⚠️  No evaluations found" -ForegroundColor Yellow
    return
}

$evalData = Get-Content $evalPath | ConvertFrom-Json
$recentEvals = $evalData.evaluations | Where-Object { $_.agentId -eq $AgentId } | 
                Sort-Object timestamp -Descending | Select-Object -First 10

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
    $planPath = Join-Path $SCRIPT:SelfImprovementDir "optimization-plan.json"
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
# 加载配置
. "$PSScriptRoot\config.ps1"

Write-Host "=== Syncing Learning Across Agents ===" -ForegroundColor Cyan
Write-Host ""

# 读取共享知识库
$sharedPath = Join-Path $SCRIPT:SharedContextDir "collective-wisdom.json"
if (-not (Test-Path $sharedPath)) {
    Write-Host "⚠️  No shared knowledge found" -ForegroundColor Yellow
    return
}

$sharedData = Get-Content $sharedPath | ConvertFrom-Json
$lessonCount = if ($sharedData.lessons) { $sharedData.lessons.Count } else { 0 }
Write-Host "Shared lessons: $lessonCount" -ForegroundColor Cyan

# 获取所有Agent
$agentWorkspaces = Get-ChildItem "$env:USERPROFILE\.openclaw" -Directory | 
                   Where-Object { $_.Name -like "workspace-*" }

$syncedCount = 0
foreach ($workspace in $agentWorkspaces) {
    $sharedDir = Join-Path $workspace.FullName "shared-context\self-improvement"
    
    # 跳过源目录
    if ($sharedDir -eq $SCRIPT:SharedContextDir) {
        continue
    }
    
    # 创建目标目录
    if (-not (Test-Path $sharedDir)) {
        New-Item -ItemType Directory -Path $sharedDir -Force | Out-Null
    }

    # 复制共享知识
    $targetPath = Join-Path $sharedDir "collective-wisdom.json"
    Copy-Item $sharedPath $targetPath -Force
    $syncedCount++
}

Write-Host ""
Write-Host "✅ Synced to $syncedCount agents" -ForegroundColor Green
```

---

## 自动集成

### 在每个Agent的任务执行脚本末尾添加：

```powershell
# 加载配置
. "$env:USERPROFILE\.openclaw\workspace-<agent-id>\scripts\self-improvement\config.ps1"

# 任务完成后自动评估
$metrics = @{
    completion = 90  # 完成度 0-100
    efficiency = 85   # 效率 0-100
    quality = 80      # 质量 0-100
    satisfaction = 85 # 满意度 0-100
}

& "$env:USERPROFILE\.openclaw\workspace-<agent-id>\scripts\self-improvement\evaluate-task.ps1" `
    -AgentId "<agent-id>" `
    -TaskId "task-001" `
    -TaskType "创作" `
    -Metrics $metrics
```

**注意**: 将 `<agent-id>` 替换为实际的 Agent ID。

---

## 定时任务

### 每日同步（每天2:00）

```powershell
# 添加到定时任务
$workspace = Get-AgentWorkspace
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
