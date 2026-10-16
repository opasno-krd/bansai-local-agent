$env:BONSAI_CTX = '131072'
$env:BONSAI_KV4 = '1'
Set-Location 'C:\AI\bonsai\Bonsai-demo'
.\scripts\start_llama_server.ps1 --reasoning-preserve --alias bonsai-2-27b -b 4096 -ub 512 --parallel 1 --no-mmap