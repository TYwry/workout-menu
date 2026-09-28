@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
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
echo 已上傳，GitHub Pages 約 1 分鐘後更新。
pause
