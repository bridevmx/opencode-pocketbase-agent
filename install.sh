#!/usr/bin/env bash
# install.sh — Instalador para Linux / macOS

set -e

REPO="https://raw.githubusercontent.com/bridevmx/opencode-pocketbase-agent/main"
AGENTS_DIR="$HOME/.config/opencode/agents"

echo "Instalando pocketbase-backend agent para OpenCode..."

mkdir -p "$AGENTS_DIR"

curl -fsSL "$REPO/agents/pocketbase-backend.md" -o "$AGENTS_DIR/pocketbase-backend.md"

echo "  Instalado: $AGENTS_DIR/pocketbase-backend.md"
echo ""
echo "Listo. Reinicia OpenCode y usa @pocketbase-backend en tus sesiones."
