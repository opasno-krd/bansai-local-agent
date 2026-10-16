# start-server.ps1 — запуск Bonsai 2 27B (Vulkan)
# Папка модели: BONSAI_MODEL_DIR > bonsai.config.json > дефолт

$configPath = Join-Path $PSScriptRoot 'bonsai.config.json'
$config = $null
if (Test-Path $configPath) {
    try { $config = Get-Content $configPath -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue } catch { }
}

# Приоритет: переменная окружения > конфиг > дефолт
function Get-Setting([string]$Name, [string]$Default) {
    if ($env:$Name) { return $env:$Name }
    if ($config -and $config.$Name) { return [string]$config.$Name }
    return $Default
}

$env:BONSAI_CTX   = Get-Setting 'BONSAI_CTX'       '131072'
$env:BONSAI_KV4   = Get-Setting 'BONSAI_KV4'       '1'
$modelDir         = Get-Setting 'BONSAI_MODEL_DIR' 'C:\AI\bonsai\Bonsai-demo'

# Валидация: папка должна содержать скрипт запуска llama-server
$serverScript = Join-Path $modelDir 'scripts\start_llama_server.ps1'
if (-not (Test-Path $serverScript)) {
    Write-Host ''
    Write-Host '  ✗ Не найдена папка модели или скрипт запуска: ' $modelDir -ForegroundColor Red
    Write-Host ''
    Write-Host '    Укажите, где лежит ваш .gguf, одним из способов:' -ForegroundColor Yellow
    Write-Host '      1) Задайте переменную: $env:BONSAI_MODEL_DIR = "D:\models\bonsai"' -ForegroundColor Cyan
    Write-Host '      2) Создайте файл C:\workspace\bonsai.config.json' -ForegroundColor Cyan
    Write-Host '         (скопируйте и переименуйте bonsai.config.json.example)' -ForegroundColor Cyan
    Write-Host '      3) Положите модель в C:\AI\bonsai\Bonsai-demo (дефолт)' -ForegroundColor Cyan
    Write-Host ''
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

Write-Host "[stack] Запуск сервера из: $modelDir" -ForegroundColor Cyan
Push-Location $modelDir
try {
    .\scripts\start_llama_server.ps1 --reasoning-preserve --alias bonsai-2-27b -b 4096 -ub 512 --parallel 1 --no-mmap
} finally {
    Pop-Location
}
