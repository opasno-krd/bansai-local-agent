# Setup script for Bonsai workspace
# Deploys the complete workspace structure with memory, configs, and tools

$ErrorActionPreference = 'Continue'
$workspaceRoot = "C:\workspace"
$scriptDir = $PSScriptRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Bonsai Workspace Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Создаём структуру папок
Write-Host "[1/5] Creating workspace structure..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$workspaceRoot\.dsh\mem\lessons" -Force | Out-Null
New-Item -ItemType Directory -Path "$workspaceRoot\my-world\notes" -Force | Out-Null
New-Item -ItemType Directory -Path "$workspaceRoot\tasks" -Force | Out-Null
Write-Host "  ✓ Structure created" -ForegroundColor Green

# 2. Копируем основные конфиги
Write-Host "[2/5] Copying configuration files..." -ForegroundColor Yellow
Copy-Item "$scriptDir\cordis.patch.yml" "$workspaceRoot\cordis.patch.yml" -Force
Copy-Item "$scriptDir\AGENTS.md" "$workspaceRoot\AGENTS.md" -Force
Copy-Item "$scriptDir\mem.py" "$workspaceRoot\mem.py" -Force
Copy-Item "$scriptDir\start-server.ps1" "$workspaceRoot\start-server.ps1" -Force
Write-Host "  ✓ Configuration files copied" -ForegroundColor Green

# 3. Копируем production-скрипты
Write-Host "[3/5] Copying production scripts..." -ForegroundColor Yellow
if (Test-Path "$scriptDir\clean_logs.sh") {
    Copy-Item "$scriptDir\clean_logs.sh" "$workspaceRoot\clean_logs.sh" -Force
}
if (Test-Path "$scriptDir\ssh_stats.sh") {
    Copy-Item "$scriptDir\ssh_stats.sh" "$workspaceRoot\ssh_stats.sh" -Force
}
Write-Host "  ✓ Production scripts copied" -ForegroundColor Green

# 4. Копируем документацию
Write-Host "[4/5] Copying documentation..." -ForegroundColor Yellow
if (Test-Path "$scriptDir\plugin_docs.md") {
    Copy-Item "$scriptDir\plugin_docs.md" "$workspaceRoot\plugin_docs.md" -Force
}
if (Test-Path "$scriptDir\README-setup.md") {
    Copy-Item "$scriptDir\README-setup.md" "$workspaceRoot\README-setup.md" -Force
}
Write-Host "  ✓ Documentation copied" -ForegroundColor Green

# 5. Инициализируем память
Write-Host "[5/5] Initializing lesson memory..." -ForegroundColor Yellow
try {
    $memResult = py -3 "$workspaceRoot\mem.py" write --cat decision --task "workspace setup" --broke "fresh install" --fixed "workspace deployed via setup script" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Memory initialized" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Memory initialization skipped (Python not found or mem.py error)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠ Memory initialization skipped (Python not available)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Workspace deployed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Workspace location: $workspaceRoot" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Install DeepSeek Harness:" -ForegroundColor White
Write-Host "     https://www.deepseek.com/en/harness/" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Download the model:" -ForegroundColor White
Write-Host "     Ternary-Bonsai-2-27B-PQ2_0.gguf (~8 GB)" -ForegroundColor Cyan
Write-Host "     https://huggingface.co/PrismML/Ternary-Bonsai-2-27B-PQ2_0.gguf" -ForegroundColor Cyan
Write-Host ""
Write-Host "  3. Copy profile configuration:" -ForegroundColor White
Write-Host "     Copy '$workspaceRoot\cordis.patch.yml' to:" -ForegroundColor Cyan
Write-Host "     %USERPROFILE%\.dsh\profiles\desktop\cordis.patch.yml" -ForegroundColor Cyan
Write-Host ""
Write-Host "  4. Edit start-server.ps1:" -ForegroundColor White
Write-Host "     Update the path to your model location" -ForegroundColor Cyan
Write-Host ""
Write-Host "  5. Start the server:" -ForegroundColor White
Write-Host "     cd $workspaceRoot" -ForegroundColor Cyan
Write-Host "     .\start-server.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "  6. Open DeepSeek Harness and select model 'bonsai-2-27b'" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan