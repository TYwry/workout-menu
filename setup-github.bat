@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
set REPO=workout-menu
echo ==== 健身菜單：第一次連結 GitHub 並開啟 GitHub Pages ====

where git >nul 2>nul || winget install --id Git.Git -e --source winget
where gh  >nul 2>nul || winget install --id GitHub.cli -e --source winget
where gh  >nul 2>nul || (echo 請關閉視窗後重新雙擊本檔案（剛安裝完需要重開）。& pause & exit /b 1)

gh auth status >nul 2>nul || gh auth login --web --git-protocol https
gh auth setup-git

for /f "delims=" %%i in ('gh api user -q .login') do set GHUSER=%%i

rem ---- 把 README 最上方的連結換成你的帳號，並設定儲存庫 About 欄的網址 ----
if "%GHUSER%"=="" goto :skiplink
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p='README.md'; $t=[IO.File]::ReadAllText($p); if($t.Contains('__GH_USER__')){ [IO.File]::WriteAllText($p, $t.Replace('__GH_USER__','%GHUSER%'), (New-Object Text.UTF8Encoding $false)) }"
:skiplink

if not exist ".git" git init -b main
git add -A

rem ---- 安全檢查：不可上傳的檔案 ----
git diff --cached --name-only | findstr /i /r "config\.json history\.json \.env \.log$ \.key$ \.pem$" >nul
if not errorlevel 1 (
  echo [中止] 發現不應上傳的檔案，已取消暫存。
  git reset -q
  pause & exit /b 1
)

if exist ".commit-message.txt" (git commit -F ".commit-message.txt" && del ".commit-message.txt") else (git commit -m "初版：健身菜單網頁")

rem GitHub Pages 免費方案需要公開儲存庫；內容只有菜單，沒有個資
gh repo create %REPO% --public --source . --push || git push -u origin main

gh api -X POST "repos/%GHUSER%/%REPO%/pages" -f "source[branch]=main" -f "source[path]=/" >nul 2>nul
gh repo edit "%GHUSER%/%REPO%" --homepage "https://%GHUSER%.github.io/%REPO%/" >nul 2>nul
echo.
echo 完成！約 1 分鐘後可用 iPhone Safari 開啟：
echo   https://%GHUSER%.github.io/%REPO%/
echo 開啟後點「分享」→「加入主畫面」。
pause
