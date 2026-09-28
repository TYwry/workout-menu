@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
set REPO=workout-menu
set GHUSER=
for /f "delims=" %%i in ('gh api user -q .login 2^>nul') do set GHUSER=%%i

rem ---- 把 README 最上方的連結換成你的帳號，並設定儲存庫 About 欄的網址 ----
if "%GHUSER%"=="" goto :skiplink
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p='README.md'; $t=[IO.File]::ReadAllText($p); if($t.Contains('__GH_USER__')){ [IO.File]::WriteAllText($p, $t.Replace('__GH_USER__','%GHUSER%'), (New-Object Text.UTF8Encoding $false)) }"
:skiplink

git add -A
git diff --cached --name-only | findstr /i /r "config\.json history\.json \.env \.log$ \.key$ \.pem$" >nul
if not errorlevel 1 (
  echo [中止] 發現不應上傳的檔案，已取消暫存。
  git reset -q
  pause & exit /b 1
)
git diff --cached --quiet && (echo 沒有新的變更。& pause & exit /b 0)
if exist ".commit-message.txt" (
  git commit -F ".commit-message.txt" && del ".commit-message.txt"
) else (
  set /p MSG=請輸入這次修改的說明：
  call git commit -m "%%MSG%%"
)
git push
if not "%GHUSER%"=="" gh repo edit "%GHUSER%/%REPO%" --homepage "https://%GHUSER%.github.io/%REPO%/" >nul 2>nul
echo 已上傳，GitHub Pages 約 1 分鐘後更新。
pause
