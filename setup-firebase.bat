@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ==== 健身菜單：第一次設定 Firebase（只需要做一次）====
echo.
where node >nul 2>nul
if errorlevel 1 (
  echo [1/3] 正在安裝 Node.js（官方長期支援版，來源 nodejs.org，約 30 MB）...
  winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
  if errorlevel 1 (echo 安裝失敗。請到 https://nodejs.org 下載「LTS」版本手動安裝，再重新雙擊本檔案。& pause & exit /b 1)
  echo.
  echo Node.js 安裝完成。請「關閉這個視窗」，再重新雙擊 setup-firebase.bat 繼續下一步。
  pause & exit /b 0
)
echo [1/3] 已有 Node.js
where firebase >nul 2>nul
if errorlevel 1 (
  echo [2/3] 正在安裝 Firebase 部署工具（官方 npm 套件 firebase-tools，約 150 MB）...
  call npm install -g firebase-tools
  if errorlevel 1 (echo 安裝失敗，請看上面的錯誤訊息。& pause & exit /b 1)
) else (
  echo [2/3] 已有 Firebase 部署工具
)
echo [3/3] 接下來會打開瀏覽器，請用你的 Google 帳號登入並按「允許」...
call firebase login
echo.
echo 設定完成！接下來：
echo   1. 到 https://console.firebase.google.com 建立專案（免費方案即可）
echo   2. 用記事本打開 .firebaserc，把 your-firebase-project-id 換成你的專案 ID
echo   3. 雙擊 deploy.bat 部署
pause
