# install.ps1 — Instalador para Windows

$repo = "https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
$agentsDir = "$env:USERPROFILE\.config\opencode\agents"

Write-Host "Instalando agentes para OpenCode..."

if (-not (Test-Path $agentsDir)) {
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null
    Write-Host "  Creado: $agentsDir"
}

$agents = @("back-dev", "front-dev", "web-search")

foreach ($agent in $agents) {
    $localDir = "$agentsDir\$agent"
    if (-not (Test-Path $localDir)) {
        New-Item -ItemType Directory -Path $localDir -Force | Out-Null
    }
    $url  = "$repo/agents/$agent/agent.md"
    $dest = "$localDir\agent.md"
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host "  Instalado: $dest"
    } catch {
        Write-Error "Error descargando $agent`: $_"
        exit 1
    }
}

Write-Host ""
Write-Host "Listo. Reinicia OpenCode y usa @back-dev, @front-dev o @web-search en tus sesiones."
