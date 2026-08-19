#requires -version 5.1
<#
  一键发布 v1.3.4 到 GitHub（维护者用）。
  前置条件：先执行 gh auth login 登录 GitHub。
  流程：克隆仓库 → 同步 3 个更新文件 → 提交 → 推送 main → 打 tag → 创建 Release 并上传 zip。
#>
param(
    [string]$Version = "1.3.4",
    [string]$Repo = "qibuliaoming/codex-zh-cn-agent"
)

$ErrorActionPreference = "Stop"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

Write-Host "== 检查 gh 登录状态 ==" -ForegroundColor Cyan
gh auth status 2>&1 | Out-String | Write-Host
if ($LASTEXITCODE -ne 0) {
    Write-Host "gh 未登录或令牌失效。请先运行：gh auth login" -ForegroundColor Yellow
    exit 1
}

$srcDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$tmp = Join-Path $env:TEMP ("codex-zh-cn-publish-" + [guid]::NewGuid().ToString("N"))
$zip = Join-Path $srcDir ("codex-zh-cn-agent-v" + $Version + ".zip")

Write-Host "== 克隆仓库 ==" -ForegroundColor Cyan
gh repo clone $Repo $tmp
if ($LASTEXITCODE -ne 0) { exit 1 }
$ghUser = gh api user --jq .login
$ghId = gh api user --jq .id
git -C $tmp config user.name $ghUser
git -C $tmp config user.email "$($ghId)+$($ghUser)@users.noreply.github.com"

Write-Host "== 同步更新文件 ==" -ForegroundColor Cyan
foreach ($name in @("README.md", "使用说明.txt", "versions.json")) {
    Copy-Item -LiteralPath (Join-Path $srcDir $name) -Destination (Join-Path $tmp $name) -Force
}

Write-Host "== 提交并推送 ==" -ForegroundColor Cyan
git -C $tmp add -A
git -C $tmp commit -m "v${Version}: support Codex 26.810.7004.0" --allow-empty
git -C $tmp push origin main
if ($LASTEXITCODE -ne 0) { Write-Host "推送失败，请检查网络/权限" -ForegroundColor Yellow; exit 1 }

Write-Host "== 打 tag 并推送 ==" -ForegroundColor Cyan
git -C $tmp tag "v$Version"
git -C $tmp push origin "v$Version"

Write-Host "== 创建 Release ==" -ForegroundColor Cyan
gh release create "v$Version" $zip `
    --repo $Repo `
    --title "v$Version" `
    --notes "新增支持 Codex 26.810.7004.0（2026-08-16 实测通过）。已测版本：26.803.5235.0 / 26.803.10989.0 / 26.810.7004.0。解压后双击「安装汉化.bat」，选 1 安装。"

Write-Host ""
Write-Host "发布完成：https://github.com/${Repo}/releases/tag/v${Version}" -ForegroundColor Green
Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
