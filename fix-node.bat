@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ==== 重新安裝 Node.js 與 Firebase 工具（第 2 次）====
echo.
set "NODEDIR=C:\Program Files\nodejs"
echo [1/3] 先移除 Windows 記錄裡殘留的舊 Node.js...
echo       如果跳出「是否允許此 App 變更」視窗，請按「是」。
winget uninstall --id OpenJS.NodeJS.LTS -e --silent --accept-source-agreements
echo.
echo [2/3] 重新安裝 Node.js LTS（官方來源 nodejs.org）...
winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
if exist "%NODEDIR%\node.exe" goto havenode
echo.
echo 安裝版失敗，改用免安裝版（官方 nodejs.org zip，放在你的使用者資料夾，不需要管理員）...
set "NODEDIR=%LOCALAPPDATA%\Programs\nodejs"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $v='v24.20.0'; $z=Join-Path $env:TEMP 'node.zip'; Invoke-WebRequest \"https://nodejs.org/dist/$v/node-$v-win-x64.zip\" -OutFile $z; $d=Join-Path $env:LOCALAPPDATA 'Programs'; New-Item -ItemType Directory -Force $d | Out-Null; if (Test-Path \"$d\nodejs\") { Remove-Item -Recurse -Force \"$d\nodejs\" }; Expand-Archive $z $d -Force; Rename-Item \"$d\node-$v-win-x64\" 'nodejs'; Remove-Item $z; $p=[Environment]::GetEnvironmentVariable('Path','User'); if ($p -notlike \"*$d\nodejs*\") { [Environment]::SetEnvironmentVariable('Path', ($p.TrimEnd(';') + ';' + \"$d\nodejs\"), 'User') }"
if not exist "%NODEDIR%\node.exe" (echo. & echo Node.js 還是安裝失敗，請把這個畫面截圖給 Claude。& pause & exit /b 1)
:havenode
set "PATH=%NODEDIR%;%APPDATA%\npm;%PATH%"
echo Node.js 版本：
node -v
echo.
echo [3/3] 安裝 Firebase 部署工具（官方 npm 套件 firebase-tools）...
call npm install -g firebase-tools
if errorlevel 1 (echo. & echo Firebase 工具安裝失敗，請把這個畫面截圖給 Claude。& pause & exit /b 1)
echo Firebase 工具版本：
call firebase --version
echo.
echo ==== 全部完成 ====
pause
