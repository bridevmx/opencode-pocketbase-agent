# install.ps1 — Instalador para Windows

$repo = "https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
$agentsDir = "$env:USERPROFILE\.config\opencode\agents"

Write-Host "Instalando agentes para OpenCode..."

# Crear directorio base si no existe
if (-not (Test-Path $agentsDir)) {
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null
    Write-Host "  Creado: $agentsDir"
}

# Agentes: nombre de carpeta en el repo -> nombre de carpeta local
$agents = @(
    @{ repo = "pocketbase-backend"; local = "pocketbase-backend" },
    @{ repo = "front-dev";          local = "front-dev" }
)

foreach ($agent in $agents) {
    $localDir = "$agentsDir\$($agent.local)"
    if (-not (Test-Path $localDir)) {
        New-Item -ItemType Directory -Path $localDir -Force | Out-Null
    }
    $url  = "$repo/agents/$($agent.repo)/agent.md"
    $dest = "$localDir\agent.md"
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host "  Instalado: $dest"
    } catch {
        Write-Error "Error descargando $($agent.repo): $_"
        exit 1
    }
}

Write-Host ""
Write-Host "Listo. Reinicia OpenCode y usa @pocketbase-backend o @front-dev en tus sesiones."
