# Self-Improving Agent Skill

让Agent具备自我评估、学习和迭代的能力。

## 核心理念

**Agent不应该只是执行任务，还应该从执行中学习，不断优化自己的表现。**

---

## Skill 信息

- **名称**: self-improving-agent
- **版本**: 1.0.0
- **类型**: 系统增强 / 自动化
- **兼容性**: OpenClaw Agent System

---

## 使用场景

这个 Skill 适用于任何需要持续改进和优化的 Agent：

- ✅ 内容创作 Agent（文章、视频、脚本）
- ✅ 代码开发 Agent（编程、调试、重构）
- ✅ 数据分析 Agent（报告、洞察、预测）
- ✅ 任务管理 Agent（计划、执行、跟踪）
- ✅ 任何需要从错误中学习的 Agent

---

## 三层自我改进机制

### Layer 1: 实时反馈循环
每次任务执行后立即评估，快速调整

### Layer 2: 周期性深度反思
每周/每月深度分析，识别系统性问题

### Layer 3: 跨Agent经验共享
所有Agent共享学习成果，集体进化

---

## 核心组件

### 1. Self-Evaluator（自我评估器）

**评估维度**：
- ✅ 任务完成度（是否达成目标）
- ✅ 执行效率（耗时是否合理）
- ✅ 质量评分（输出质量如何）
- ✅ 用户满意度（是否需要返工）
- ✅ 创新度（是否有新方法）

**评分机制**：
```
总分 = 完成度(30%) + 效率(20%) + 质量(30%) + 满意度(20%)

≥ 90分: 优秀 → 记录最佳实践
80-89分: 良好 → 继续保持
70-79分: 及格 → 识别改进点
< 70分: 不及格 → 触发深度反思
```

### 2. Lesson-Learner（经验学习器）

**学习内容**：
- ✅ 成功模式：什么方法效果好
- ✅ 失败模式：什么方法要避免
- ✅ 优化机会：哪里可以改进
- ✅ 知识缺口：缺少什么知识

**存储格式**：
```json
{
  "timestamp": "2026-03-11T02:12:00Z",
  "taskId": "xxx",
  "agent": "dajia",
  "score": 85,
  "successPatterns": ["使用模板加速创作"],
  "failurePatterns": ["未验证链接有效性"],
  "optimizationOpportunities": ["添加链接检查步骤"],
  "knowledgeGaps": ["需要学习更多飞书API"]
}
```

### 3. Strategy-Optimizer（策略优化器）

**优化策略**：
- ✅ 流程优化：改进工作流程
- ✅ 工具优化：选择更好的工具
- ✅ Prompt优化：优化提示词
- ✅ 知识补充：学习新知识

**优化触发**：
- 评分 < 70分：立即优化
- 连续3次及格：主动优化
- 收到新反馈：针对性优化

---

## 实现架构

### 数据结构

#### performance-metrics.json
```json
{
  "agentId": "dajia",
  "totalTasks": 150,
  "averageScore": 82.5,
  "trend": "improving",
  "bestPractices": [
    {
      "pattern": "使用模板创作",
      "usage": 45,
      "successRate": 0.95
    }
  ],
  "areasForImprovement": [
    {
      "area": "链接验证",
      "currentScore": 65,
      "targetScore": 80
    }
  ]
}
```

#### lessons-learned.json
```json
{
  "lessons": [
    {
      "id": "lesson-001",
      "timestamp": "2026-03-11T02:00:00Z",
      "agent": "dajia",
      "task": "创作飞书文章",
      "lesson": "文章创作后要验证链接有效性",
      "impact": "high",
      "applied": false
    }
  ]
}
```

#### optimization-plan.json
```json
{
  "planId": "opt-001",
  "agent": "dajia",
  "priority": "high",
  "actions": [
    {
      "action": "添加链接检查步骤",
      "status": "pending",
      "deadline": "2026-03-12"
    }
  ]
}
```

---

## 工作流程

### 任务执行流程（带自我改进）

```
1. 接收任务
   ↓
2. 检查历史经验
   - 查看类似任务的成功模式
   - 应用最佳实践
   ↓
3. 执行任务
   - 记录过程数据
   - 标记关键决策点
   ↓
4. 自我评估
   - 计算任务得分
   - 识别成功/失败模式
   ↓
5. 存储经验
   - 保存到 lessons-learned.json
   - 更新 performance-metrics.json
   ↓
6. 触发优化（如果需要）
   - 生成优化计划
   - 调度优化任务
   ↓
7. 跨Agent共享
   - 同步到共享知识库
   - 其他Agent可复用
```

---

## 应用到所有Agent

### 1. 创建共享知识库

**位置**：`shared-context/self-improvement/`

**文件结构**：
```
shared-context/self-improvement/
├── best-practices.json      # 所有Agent的最佳实践
├── common-mistakes.json      # 常见错误清单
├── optimization-log.json     # 优化记录
└── collective-wisdom.json    # 集体智慧
```

### 2. Agent配置更新

**每个Agent添加**：
```json
{
  "selfImprovement": {
    "enabled": true,
    "evaluateAfterTask": true,
    "weeklyReflection": true,
    "shareLearning": true,
    "learnFromOthers": true
  }
}
```

### 3. 定期同步机制

**每日**：
- 各Agent同步最新最佳实践
- 更新集体智慧库

**每周**：
- 生成周度改进报告
- 识别系统性问题
- 制定优化计划

**每月**：
- 深度性能分析
- 策略大调整
- 知识库整理

---

## 评估矩阵

### 任务类型权重表

| 任务类型 | 完成度 | 效率 | 质量 | 满意度 |
|---------|-------|------|------|--------|
| 创作类 | 25% | 15% | 40% | 20% |
| 技术类 | 35% | 25% | 30% | 10% |
| 分析类 | 30% | 20% | 35% | 15% |
| 管理类 | 40% | 20% | 25% | 15% |

### 改进优先级矩阵

```
高影响 + 高频率 → 立即优化
高影响 + 低频率 → 计划优化
低影响 + 高频率 → 逐步优化
低影响 + 低频率 → 观察优化
```

---

## 实施步骤

### Phase 1: 基础设施（第1周）
1. 创建数据结构
2. 实现评估器
3. 部署到所有Agent

### Phase 2: 经验积累（第2-4周）
1. 收集执行数据
2. 识别模式
3. 建立基准

### Phase 3: 优化迭代（第5周+）
1. 应用优化
2. 测量效果
3. 持续改进

---

## 成功指标

- ✅ 平均任务得分提升10%
- ✅ 返工率下降50%
- ✅ 任务完成时间缩短20%
- ✅ 跨Agent知识复用率>30%

---

**核心目标：让每个Agent都成为终身学习者！**
