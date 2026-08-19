# 发布指南（维护者用）— v1.3.4

本目录是 v1.3.4 的发布快照，与 GitHub 仓库内容一致（LF 换行），包含：

- 3 个更新文件：`README.md`、`使用说明.txt`、`versions.json`（新增已测版本 Codex 26.810.7004.0）
- 正式发布包：`codex-zh-cn-agent-v1.3.4.zip`（SHA256 见下方命令输出）

## 一键发布（推荐）

1. 先登录 GitHub：`gh auth login`
2. 在本目录打开 PowerShell，运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\发布到GitHub.ps1
```

脚本会：克隆仓库 → 同步 3 个更新文件 → 提交 → 推送 main → 打 tag v1.3.4 → 创建 GitHub Release 并上传 zip。

## 手动发布（备用）

```powershell
gh auth login
gh repo clone qibuliaoming/codex-zh-cn-agent $env:TEMP\codex-zh-cn-publish
Copy-Item README.md,使用说明.txt,versions.json $env:TEMP\codex-zh-cn-publish -Force
git -C $env:TEMP\codex-zh-cn-publish add -A
git -C $env:TEMP\codex-zh-cn-publish commit -m "v1.3.4: support Codex 26.810.7004.0"
git -C $env:TEMP\codex-zh-cn-publish push origin main
git -C $env:TEMP\codex-zh-cn-publish tag v1.3.4
git -C $env:TEMP\codex-zh-cn-publish push origin v1.3.4
gh release create v1.3.4 .\codex-zh-cn-agent-v1.3.4.zip --title "v1.3.4" --notes "新增支持 Codex 26.810.7004.0（2026-08-16 实测）"
```

## Release 说明建议

```text
v1.3.4
- 新增已测版本：Codex 26.810.7004.0（2026-08-16 实测通过）
- 已测版本：26.803.5235.0 / 26.803.10989.0 / 26.810.7004.0
- 用法：解压后双击「安装汉化.bat」，UAC 点「是」，选 1 安装
- 全程离线、不登录 OpenAI 账号、不改原版安装、可一键恢复英文
```
