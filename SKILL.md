# Self-Improvement Agent Skill

**当Agent需要从任务执行中学习并自我优化时，激活此技能。**

---

## 🎯 激活条件

当用户提到以下关键词时，激活此技能：
- "自我改进"、"自我优化"、"学习经验"
- "任务评估"、"性能分析"
- "优化工作流程"、"提升效率"
- 或任何需要Agent从错误中学习的场景

---

## 🎯 核心概念

**Agent不应该只是执行任务，还应该从执行中学习，不断优化自己的表现。**

三层自我改进机制：
1. **Layer 1: 实时反馈循环** - 每次任务执行后立即评估
2. **Layer 2: 周期性深度反思** - 每周/每月深度分析
3. **Layer 3: 跨Agent经验共享** - 所有Agent共享学习成果

---

## 📊 任务评估标准

### 评分公式
```
总分 = 完成度(30%) + 效率(20%) + 质量(30%) + 满意度(20%)
```

### 评分等级
- **≥ 90分**: 优秀 → 记录最佳实践
- **80-89分**: 良好 → 继续保持
- **70-79分**: 及格 → 识别改进点
- **< 70分**: 不及格 → 触发深度反思

---

## 🚀 使用方法

### 方式1：任务后自动评估（推荐）

在每个Agent的任务执行脚本末尾添加：

```powershell
# 加载自我改进配置
$siDir = "$env:USERPROFILE\.openclaw\skills\self-improvement-agent"
. "$siDir\scripts\config.ps1"

# 定义评估指标
$metrics = @{
    completion = 90   # 完成度 0-100
    efficiency = 85    # 效率 0-100
    quality = 80       # 质量 0-100
    satisfaction = 85  # 满意度 0-100
}

# 执行评估
& "$siDir\scripts\evaluate-task.ps1" `
    -AgentId "dajia" `
    -TaskId "task-001" `
    -TaskType "内容创作" `
    -Metrics $metrics
```

### 方式2：手动记录经验

```powershell
& "$env:USERPROFILE\.openclaw\skills\self-improving-agent\scripts\learn-lesson.ps1" `
    -AgentId "dajia" `
    -Lesson "使用 Write-Output 而非消息API，避免定时任务失败" `
    -Impact "避免消息发送失败" `
    -Category "工具使用"
```

### 方式3：触发优化流程

```powershell
& "$env:USERPROFILE\.openclaw\skills\self-improving-agent\scripts\optimize-agent.ps1" `
    -AgentId "dajia"
```

### 方式4：跨Agent同步学习

```powershell
& "$env:USERPROFILE\.openclaw\skills\self-improvement-agent\scripts\sync-learning.ps1"
```

---

## 📁 数据存储位置

评估记录：`self-improvement/evaluations.json`
经验库：`self-improvement/lessons-learned.json`
优化计划：`self-improvement/optimization-plan.json`
性能指标：`self-improvement/performance-metrics.json`

---

## 🎓 最佳实践

### 1. 何时评估
- ✅ 完成重要任务后
- ✅ 完成复杂任务后
- ✅ 任务失败或返工后
- ❌ 简单重复性任务（可选）

### 2. 如何记录经验
- 记录具体的失败场景
- 记录成功的关键因素
- 记录工具使用的注意事项
- 记录优化的具体方法

### 3. 如何应用学习
- 定期回顾经验库
- 主动应用已验证的最佳实践
- 分享给其他Agent
- 更新工作流程

---

## 📈 预期效果

- 平均任务得分提升 10%
- 返工率降低 50%
- 任务完成时间减少 20%
- 跨Agent知识复用率 > 30%

---

## 🔧 故障排查

### 问题：评估脚本找不到工作区
**解决**：检查 `config.ps1` 中的工作区检测逻辑

### 问题：经验没有同步到其他Agent
**解决**：手动运行 `sync-learning.ps1`

### 问题：优化计划生成失败
**解决**：检查 `evaluations.json` 是否有足够的历史数据

---

**让每个Agent都成为终身学习者！**

---

*Version: 1.0.0*
*Tags: agent, automation, self-improvement, learning, optimization*
