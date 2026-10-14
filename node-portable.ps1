$ErrorActionPreference = 'Stop'
$v = 'v24.20.0'
$z = Join-Path $env:TEMP 'node.zip'
Invoke-WebRequest "https://nodejs.org/dist/$v/node-$v-win-x64.zip" -OutFile $z
$d = Join-Path $env:LOCALAPPDATA 'Programs'
New-Item -ItemType Directory -Force $d | Out-Null
$target = Join-Path $d 'nodejs'
if (Test-Path $target) { Remove-Item -Recurse -Force $target }
Expand-Archive $z $d -Force
Rename-Item (Join-Path $d "node-$v-win-x64") 'nodejs'
Remove-Item $z
$p = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($p -notlike "*$target*") { [Environment]::SetEnvironmentVariable('Path', ($p.TrimEnd(';') + ';' + $target), 'User') }
