# install.ps1 — Instalador para Windows

$repo = "https://raw.githubusercontent.com/TU_USUARIO/opencode-pocketbase-agent/main"
$agentsDir = "$env:USERPROFILE\.config\opencode\agents"

Write-Host "Instalando pocketbase-backend agent para OpenCode..."

# Crear directorio si no existe
if (-not (Test-Path $agentsDir)) {
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null
    Write-Host "  Creado: $agentsDir"
}

# Descargar el agente
$agentUrl = "$repo/agents/pocketbase-backend.md"
$agentDest = "$agentsDir\pocketbase-backend.md"

try {
    Invoke-WebRequest -Uri $agentUrl -OutFile $agentDest -UseBasicParsing
    Write-Host "  Instalado: $agentDest"
} catch {
    Write-Error "Error descargando el agente: $_"
    exit 1
}

Write-Host ""
Write-Host "Listo. Reinicia OpenCode y usa @pocketbase-backend en tus sesiones."
