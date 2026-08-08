# install.ps1 — Instalador para Windows

$repo = "https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
$agentsDir = "$env:USERPROFILE\.config\opencode\agents"

Write-Host "Instalando agentes para OpenCode..."

# Crear directorio si no existe
if (-not (Test-Path $agentsDir)) {
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null
    Write-Host "  Creado: $agentsDir"
}

# Agentes a instalar
$agents = @(
    "pocketbase-backend",
    "sveltekit-frontend"
)

foreach ($agent in $agents) {
    $url = "$repo/agents/$agent.md"
    $dest = "$agentsDir\$agent.md"
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host "  Instalado: $dest"
    } catch {
        Write-Error "Error descargando $agent`: $_"
        exit 1
    }
}

Write-Host ""
Write-Host "Listo. Reinicia OpenCode y usa @pocketbase-backend o @sveltekit-frontend en tus sesiones."
