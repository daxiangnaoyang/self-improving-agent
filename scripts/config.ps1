# Self-Improvement Agent Configuration
# 自动检测当前工作区并设置路径

function Get-AgentWorkspace {
    # 查找所有 workspace-* 目录
    $openclawDir = "$env:USERPROFILE\.openclaw"
    
    if (-not (Test-Path $openclawDir)) {
        throw "OpenClaw directory not found: $openclawDir"
    }

    $workspaces = Get-ChildItem $openclawDir -Directory | 
                  Where-Object { $_.Name -like "workspace-*" }

    if ($workspaces.Count -eq 0) {
        throw "No workspace found in .openclaw directory"
    }

    if ($workspaces.Count -eq 1) {
        # 只有一个工作区，直接返回
        return $workspaces[0].FullName
    }

    # 多个工作区，通过当前目录判断
    $currentDir = Get-Location
    foreach ($ws in $workspaces) {
        if ($currentDir.Path -like "$($ws.FullName)*") {
            return $ws.FullName
        }
    }

    # 默认返回第一个
    return $workspaces[0].FullName
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

# 输出配置信息（仅在调试时启用）
# Write-Host "Workspace: $SCRIPT:Workspace"
# Write-Host "Self-Improvement Dir: $SCRIPT:SelfImprovementDir"
