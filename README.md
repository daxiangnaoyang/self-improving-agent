# Self-Improving Agent Skill

让Agent具备自我评估、学习和迭代的能力。

## 简介

**Agent不应该只是执行任务，还应该从执行中学习，不断优化自己的表现。**

这个技能为OpenClaw Agent添加了三层自我改进机制：

1. **Layer 1: 实时反馈循环** - 每次任务执行后立即评估，快速调整
2. **Layer 2: 周期性深度反思** - 每周/每月深度分析，识别系统性问题
3. **Layer 3: 跨Agent经验共享** - 所有Agent共享学习成果，集体进化

## 核心组件

### 1. Self-Evaluator（自我评估器）

评估维度：
- ✅ 任务完成度（是否达成目标）
- ✅ 执行效率（耗时是否合理）
- ✅ 质量评分（输出质量如何）
- ✅ 用户满意度（是否需要返工）
- ✅ 创新度（是否有新方法）

评分机制：
```
总分 = 完成度(30%) + 效率(20%) + 质量(30%) + 满意度(20%)

≥ 90分: 优秀 → 记录最佳实践
80-89分: 良好 → 继续保持
70-79分: 及格 → 识别改进点
< 70分: 不及格 → 触发深度反思
```

### 2. Lesson-Learner（经验学习器）

学习内容：
- ✅ 成功模式：什么方法效果好
- ✅ 失败模式：什么方法要避免
- ✅ 优化机会：哪里可以改进
- ✅ 知识缺口：缺少什么知识

### 3. Strategy-Optimizer（策略优化器）

优化策略：
- ✅ 流程优化：改进工作流程
- ✅ 工具优化：选择更好的工具
- ✅ Prompt优化：优化提示词
- ✅ 知识补充：学习新知识

## 安装

### 使用 ClawHub（推荐）

```bash
clawhub install self-improving-agent
```

### 手动安装

1. 下载最新的 `.skill` 文件
2. 复制到你的 OpenClaw skills 目录：
   - Windows: `%USERPROFILE%\.openclaw\skills\`
   - Mac/Linux: `~/.openclaw/skills/`
3. 重启 OpenClaw Gateway

## 使用方法

### 在任务执行后自动评估

```powershell
# 任务完成后自动评估
$metrics = @{
    completion = 90  # 完成度 0-100
    efficiency = 85   # 效率 0-100
    quality = 80      # 质量 0-100
    satisfaction = 85 # 满意度 0-100
}

# 脚本会自动检测当前 workspace
& "$env:USERPROFILE\.openclaw\workspace-<agent-id>\scripts\self-improvement\evaluate-task.ps1" `
    -AgentId "<agent-id>" `
    -TaskId "task-001" `
    -TaskType "创作" `
    -Metrics $metrics
```

**注意**: 将 `<agent-id>` 替换为实际的 Agent ID（例如：dajia, writer, creator 等）

### 记录经验教训

```powershell
& "$env:USERPROFILE\.openclaw\workspace-<agent-id>\scripts\self-improvement\learn-lesson.ps1" `
    -AgentId "<agent-id>" `
    -Lesson "文章创作后要验证链接有效性" `
    -Impact "high" `
    -Category "quality"
```

### 跨Agent同步学习

```powershell
& "$env:USERPROFILE\.openclaw\workspace-<agent-id>\scripts\self-improvement\sync-learning.ps1"
```

## 数据结构

### evaluations.json
存储每次任务的评估结果

### lessons-learned.json
存储学到的经验教训

### optimization-plan.json
存储优化计划和执行状态

### performance-metrics.json
存储Agent的性能指标和趋势

## 成功指标

- ✅ 平均任务得分提升10%
- ✅ 返工率下降50%
- ✅ 任务完成时间缩短20%
- ✅ 跨Agent知识复用率>30%

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 作者

大象 (Daxiang) - AI方案架构师
- 微信公众号：大象AI共学
- 抖音号：大象AI共学

---

**让每个Agent都成为终身学习者！**
