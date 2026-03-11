# Self-Improving Agent Skill - GitHub 上传指南

## 方法1: 使用 GitHub CLI（推荐，如果已安装）

```bash
# 1. 在 GitHub 上创建仓库
gh repo create self-improving-agent --public --description "让Agent具备自我评估、学习和迭代的能力 - OpenClaw Skill"

# 2. 推送代码
cd C:\Users\Administrator\.openclaw\workspace-dajia\skills\self-improving-agent
git remote add origin https://github.com/starqi55/self-improving-agent.git
git branch -M main
git push -u origin main
```

## 方法2: 手动创建仓库（如果 GitHub CLI 未安装）

### 步骤1: 在 GitHub 上创建仓库

1. 访问 https://github.com/new
2. 仓库名称：`self-improving-agent`
3. 描述：`让Agent具备自我评估、学习和迭代的能力 - OpenClaw Skill`
4. 选择 Public
5. **不要**勾选 "Add a README file"（我们已经有了）
6. 点击 "Create repository"

### 步骤2: 推送代码

创建仓库后，GitHub 会显示推送命令。在 PowerShell 中运行：

```powershell
cd C:\Users\Administrator\.openclaw\workspace-dajia\skills\self-improving-agent
git remote add origin https://github.com/starqi55/self-improving-agent.git
git branch -M main
git push -u origin main
```

## 上传 .skill 文件到 GitHub Releases

推送代码后，还需要将打包好的 `.skill` 文件上传到 GitHub Releases：

1. 访问 https://github.com/starqi55/self-improving-agent/releases
2. 点击 "Create a new release"
3. Tag: `v1.0.0`
4. Title: `v1.0.0 - Initial Release`
5. Description:
   ```markdown
   ## Features
   - 三层自我改进机制（实时反馈、周期反思、跨Agent共享）
   - 自动评估和评分系统
   - 经验学习和知识共享
   - 优化计划和执行

   ## Installation
   ```bash
   clawhub install self-improving-agent
   ```
   ```
6. Attach binaries: 上传 `skills\dist\self-improving-agent.skill`
7. 点击 "Publish release"

## 验证安装

发布后，其他人可以通过以下命令安装：

```bash
clawhub install self-improving-agent
```

或手动下载 `.skill` 文件并安装。
