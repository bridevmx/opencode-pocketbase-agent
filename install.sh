#!/usr/bin/env bash
# install.sh — Instalador para Linux / macOS

set -e

REPO="https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
AGENTS_DIR="$HOME/.config/opencode/agents"

echo "Instalando agentes para OpenCode..."

mkdir -p "$AGENTS_DIR"

declare -A AGENTS=(
  ["pocketbase-backend"]="pocketbase-backend"
  ["front-dev"]="front-dev"
)

for repo_name in "${!AGENTS[@]}"; do
  local_name="${AGENTS[$repo_name]}"
  local_dir="$AGENTS_DIR/$local_name"
  mkdir -p "$local_dir"
  curl -fsSL "$REPO/agents/$repo_name/agent.md" -o "$local_dir/agent.md"
  echo "  Instalado: $local_dir/agent.md"
done

echo ""
echo "Listo. Reinicia OpenCode y usa @pocketbase-backend o @front-dev en tus sesiones."
