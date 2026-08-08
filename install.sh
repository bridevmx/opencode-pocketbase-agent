#!/usr/bin/env bash
# install.sh — Instalador para Linux / macOS

set -e

REPO="https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
AGENTS_DIR="$HOME/.config/opencode/agents"

echo "Instalando agentes para OpenCode..."

mkdir -p "$AGENTS_DIR"

AGENTS=("back-dev" "front-dev" "web-search")

for agent in "${AGENTS[@]}"; do
  local_dir="$AGENTS_DIR/$agent"
  mkdir -p "$local_dir"
  curl -fsSL "$REPO/agents/$agent/agent.md" -o "$local_dir/agent.md"
  echo "  Instalado: $local_dir/agent.md"
done

echo ""
echo "Listo. Reinicia OpenCode y usa @back-dev, @front-dev o @web-search en tus sesiones."
