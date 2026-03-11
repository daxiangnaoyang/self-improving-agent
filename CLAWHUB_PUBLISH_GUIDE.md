# ClawHub 发布指南

## 方法 1: 使用 ClawHub CLI（推荐）

### 步骤 1: 登录 ClawHub

```bash
# 方式 A: 浏览器登录（推荐）
clawhub login
# 这会打开浏览器，完成 GitHub OAuth 授权

# 方式 B: 使用 Token
# 1. 访问 https://clawhub.ai
# 2. 登录后进入设置
# 3. 生成 API Token
# 4. 使用 token 登录
clawhub login --token <your-token>
```

### 步骤 2: 发布 Skill

```bash
cd C:\Users\Administrator\.openclaw\workspace-dajia\skills\self-improving-agent

clawhub publish . `
    --slug self-improving-agent `
    --name "Self-Improving Agent" `
    --version "1.0.0" `
    --tags "latest,agent,automation,self-improvement" `
    --changelog "Initial release: Three-layer self-improvement mechanism for OpenClaw agents"
```

## 方法 2: 通过 GitHub PR（备选）

如果 CLI 方法不可行，可以通过提交 PR 到 ClawHub 仓库：

### 步骤 1: Fork ClawHub 仓库

```bash
# 1. 访问 https://github.com/openclaw/clawhub
# 2. 点击 Fork 按钮
# 3. Clone 你的 fork
git clone https://github.com/daxiangnaoyang/clawhub.git
cd clawhub
```

### 步骤 2: 添加你的 Skill

ClawHub 的 skill 注册格式可能在以下位置：
- `registry/skills/` 目录
- 或者通过 API 提交

### 步骤 3: 提交 PR

```bash
git add .
git commit -m "Add self-improving-agent skill"
git push origin main
# 然后在 GitHub 上创建 Pull Request
```

## 方法 3: 使用 Web 界面（最简单）

### 直接在 ClawHub 网站发布：

1. 访问 https://clawhub.ai
2. 使用 GitHub 登录
3. 点击 "Publish" 或 "Upload" 按钮
4. 上传 `self-improving-agent.skill` 文件
5. 填写元数据：
   - Slug: `self-improving-agent`
   - Name: `Self-Improving Agent`
   - Version: `1.0.0`
   - Description: 让Agent具备自我评估、学习和迭代的能力
   - Tags: `agent`, `automation`, `self-improvement`, `learning`
6. 点击发布

## 当前状态

- ✅ GitHub 仓库已创建
- ✅ Release 已发布
- ⏳ 等待登录 ClawHub（遇到速率限制）
- ⏳ 待发布到 ClawHub registry

## 建议

由于遇到了 API 速率限制，建议：

1. **等待一段时间**（15-30分钟）后重试 CLI 方法
2. **使用 Web 界面**直接发布（最简单）
3. **通过 GitHub PR** 提交到 ClawHub 仓库

## 手动发布清单

如果使用 Web 界面或手动 API：

- [ ] Skill 名称: self-improving-agent
- [ ] 显示名称: Self-Improving Agent
- [ ] 版本: 1.0.0
- [ ] 描述: 让Agent具备自我评估、学习和迭代的能力
- [ ] 标签: agent, automation, self-improvement, learning, optimization
- [ ] GitHub 仓库: https://github.com/daxiangnaoyang/self-improving-agent
- [ ] 文件: self-improving-agent.skill
- [ ] SKILL.md 路径: SKILL.md
- [ ] License: MIT

## 验证发布

发布后验证：

```bash
# 搜索你的 skill
clawhub search self-improving-agent

# 查看 skill 详情
clawhub inspect self-improving-agent

# 测试安装
clawhub install self-improving-agent
```
