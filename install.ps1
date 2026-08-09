# install.ps1 — Instalador para Windows

$repo = "https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
$agentsDir = "$env:USERPROFILE\.config\opencode\agents"

Write-Host "Instalando agencia de software para OpenCode..."

if (-not (Test-Path $agentsDir)) {
    New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null
    Write-Host "  Creado: $agentsDir"
}

$agents = @(
    @{ name = "orchestrator";  desc = "Director de la agencia (agente primario)" },
    @{ name = "back-dev";      desc = "Especialista PocketBase backend" },
    @{ name = "front-dev";     desc = "Especialista SvelteKit frontend" },
    @{ name = "web-search";    desc = "Investigador web profundo" },
    @{ name = "code-reviewer"; desc = "Auditor de calidad de codigo" },
    @{ name = "scribe";        desc = "Documentador del proyecto — mantiene CONTEXT.md" },
    @{ name = "guardian";      desc = "Git y seguridad — security scan + conventional commits" }
)

foreach ($agent in $agents) {
    $localDir = "$agentsDir\$($agent.name)"
    if (-not (Test-Path $localDir)) {
        New-Item -ItemType Directory -Path $localDir -Force | Out-Null
    }
    $url  = "$repo/agents/$($agent.name)/agent.md"
    $dest = "$localDir\agent.md"
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host "  OK  $($agent.name) — $($agent.desc)"
    } catch {
        Write-Error "Error descargando $($agent.name): $_"
        exit 1
    }
}

Write-Host ""
Write-Host "Agencia instalada. Reinicia OpenCode."
Write-Host ""
Write-Host "Agente primario:  @orchestrator  (punto de entrada)"
Write-Host "Subagentes:       @back-dev  @front-dev  @web-search  @code-reviewer  @scribe  @guardian"
