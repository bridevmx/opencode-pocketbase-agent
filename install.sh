#!/usr/bin/env bash
# install.sh — Instalador para Linux / macOS

set -e

REPO="https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
AGENTS_DIR="$HOME/.config/opencode/agents"

echo "Instalando agentes para OpenCode..."

mkdir -p "$AGENTS_DIR"

AGENTS=("pocketbase-backend" "sveltekit-frontend")

for agent in "${AGENTS[@]}"; do
  curl -fsSL "$REPO/agents/$agent.md" -o "$AGENTS_DIR/$agent.md"
  echo "  Instalado: $AGENTS_DIR/$agent.md"
done

echo ""
echo "Listo. Reinicia OpenCode y usa @pocketbase-backend o @sveltekit-frontend en tus sesiones."
