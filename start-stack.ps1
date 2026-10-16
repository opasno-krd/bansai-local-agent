$uri  = 'http://localhost:8080/v1/models'
$here = $PSScriptRoot

function Test-Server {
    try { $null = Invoke-RestMethod $uri -TimeoutSec 2; return $true } catch { return $false }
}

if (Test-Server) {
    Write-Host '[stack] Server already running - skip start' -ForegroundColor Green
} else {
    Write-Host '[stack] Starting Bonsai 2 27B (Vulkan)...' -ForegroundColor Cyan
    Start-Process powershell -ArgumentList '-NoExit','-NoProfile','-ExecutionPolicy','Bypass','-File',"$here\start-server.ps1"
    Write-Host '[stack] Waiting up to 5 minutes for the model...' -ForegroundColor Yellow
    $ok = $false
    for ($i = 0; $i -lt 150; $i++) {
        Start-Sleep -Seconds 2
        if (Test-Server) { $ok = $true; break }
    }
    if (-not $ok) {
        Write-Host '[stack] FAIL: no response in 5 min. Look at the server window (OOM? still warming up?)' -ForegroundColor Red
        exit 1
    }
    Write-Host '[stack] Model is online!' -ForegroundColor Green
}

try {
    Write-Host '[stack] Models served:' -ForegroundColor Cyan
    (Invoke-RestMethod $uri).data | ForEach-Object { Write-Host ('  - ' + $_.id) }
} catch {
    Write-Host '[stack] FAIL: server died right after start' -ForegroundColor Red
    exit 1
}