# ZhanQi Agent Installer v0.1.0

$ErrorActionPreference = "Stop"

$DownloadUrl = "https://github.com/ZaneJason/ZhanQi-Cloud-Agent/releases/download/v0.1.0/ZhanQi-Agent.exe"

$InstallDir = "$env:LOCALAPPDATA\ZhanQi"
$ExePath = Join-Path $InstallDir "ZhanQi-Agent.exe"

# 替换成你本地 EXE 的实际 SHA256
$ExpectedHash = "E64E51F12CCC46A3E34717ADC96366873D1295507537848290CB085F2694CEB1"

Write-Host "=== ZhanQi Agent Installer ==="

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

Write-Host "[1/3] Downloading Agent..."

Invoke-WebRequest -Uri $DownloadUrl -OutFile $ExePath -UseBasicParsing

Write-Host "[2/3] Verifying SHA256..."

$ActualHash = (Get-FileHash $ExePath -Algorithm SHA256).Hash

if ($ActualHash -ne $ExpectedHash) {
    Remove-Item $ExePath -Force
    throw "SHA256 verification failed"
}

if (-not $env:ZQ_SERVER -or
    -not $env:ZQ_TOKEN -or
    -not $env:ZQ_AGENT) {
    throw "Missing ZQ_SERVER, ZQ_TOKEN or ZQ_AGENT"
}

Write-Host "[3/3] Starting Agent..."

& $ExePath
