#!/usr/bin/env bash
# install.sh — Instalador para Linux / macOS

set -e

REPO="https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
AGENTS_DIR="$HOME/.config/opencode/agents"

echo "Instalando agencia de software para OpenCode..."

mkdir -p "$AGENTS_DIR"

declare -A AGENTS=(
  ["orchestrator"]="Director de la agencia (agente primario)"
  ["back-dev"]="Especialista PocketBase backend"
  ["front-dev"]="Especialista SvelteKit frontend"
  ["web-search"]="Investigador web profundo"
  ["code-reviewer"]="Auditor de calidad de codigo"
  ["scribe"]="Documentador del proyecto — mantiene CONTEXT.md"
  ["guardian"]="Git y seguridad — security scan + conventional commits"
)

ORDER=("orchestrator" "back-dev" "front-dev" "web-search" "code-reviewer" "scribe" "guardian")

for agent in "${ORDER[@]}"; do
  desc="${AGENTS[$agent]}"
  local_dir="$AGENTS_DIR/$agent"
  mkdir -p "$local_dir"
  curl -fsSL "$REPO/agents/$agent/agent.md" -o "$local_dir/agent.md"
  echo "  OK  $agent — $desc"
done

echo ""
echo "Agencia instalada. Reinicia OpenCode."
echo ""
echo "Agente primario:  @orchestrator  (punto de entrada)"
echo "Subagentes:       @back-dev  @front-dev  @web-search  @code-reviewer  @scribe  @guardian"
