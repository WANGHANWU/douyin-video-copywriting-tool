$ErrorActionPreference = 'Stop'
$env:Path = "$PSScriptRoot\.venv\Scripts;" + $env:Path
$appDir = Join-Path $PSScriptRoot 'prototype'
try {
    $null = Invoke-RestMethod 'http://127.0.0.1:5176/api/health' -TimeoutSec 2
} catch {
    Start-Process -FilePath (Get-Command node).Source -ArgumentList 'server.mjs' -WorkingDirectory $appDir -WindowStyle Hidden -RedirectStandardOutput "$PSScriptRoot\server.log" -RedirectStandardError "$PSScriptRoot\server-error.log"
    for ($i = 0; $i -lt 30; $i++) {
        Start-Sleep -Milliseconds 500
        try { $null = Invoke-RestMethod 'http://127.0.0.1:5176/api/health' -TimeoutSec 1; break } catch {}
    }
}
Start-Process 'http://127.0.0.1:5176'
