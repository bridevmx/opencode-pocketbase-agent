# opencode-pocketbase-agent

Subagente y skill para OpenCode especializado en **PocketBase v0.23+ backend** (JSVM/pb_hooks, migraciones, API rules, auth, transacciones).

## Contenido

```
agents/
  pocketbase-backend.md   ← subagente con system prompt completo
skills/
  pocketbase-backend/
    SKILL.md              ← skill cargable bajo demanda
```

## Instalación

### Opción A — Script automático (recomendado)

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/TU_USUARIO/opencode-pocketbase-agent/main/install.ps1 | iex
```

**Linux / macOS (bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/TU_USUARIO/opencode-pocketbase-agent/main/install.sh | bash
```

### Opción B — Manual

1. Clona el repo:
```bash
git clone https://github.com/TU_USUARIO/opencode-pocketbase-agent.git
```

2. Copia el agente a tu carpeta global de OpenCode:

**Windows:**
```powershell
Copy-Item "agents\pocketbase-backend.md" "$env:USERPROFILE\.config\opencode\agents\"
```

**Linux / macOS:**
```bash
cp agents/pocketbase-backend.md ~/.config/opencode/agents/
```

3. Reinicia OpenCode.

### Opción C — Skill via URL (sin instalar el agente)

Si solo quieres la skill (cargada bajo demanda), agrega esto a tu `opencode.json` global (`~/.config/opencode/opencode.json`):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "skills": {
    "urls": [
      "https://raw.githubusercontent.com/TU_USUARIO/opencode-pocketbase-agent/main/.well-known/skills/"
    ]
  }
}
```

> La Opción C requiere que el repo publique un endpoint `.well-known/skills/` — ver sección abajo.

## Uso

Una vez instalado, reinicia OpenCode y luego:

```
# Invocar manualmente el agente
@pocketbase-backend cómo creo una migración que agrega un campo a articles?

# El agente principal también lo invoca automáticamente
# cuando detecta trabajo en pb_hooks o pb_migrations
```

## Qué cubre el agente

- `pb_hooks/**/*.pb.js` — hooks, rutas, middlewares, crons
- Migraciones JS en `pb_migrations/`
- API rules, expand, enrich, hidden fields
- `runInTransaction` — anti-deadlock
- Límites del motor goja (no async, no Node APIs, scope isolation)
- Breaking changes v0.22 → v0.23+
- Campos JSON no nativos (unmarshalJSONField / POJO round-trip)
- Archivos estáticos con `$apis.static` + `{path...}`
- Contrato de API hacia agente frontend (handoff estructurado)

## Requisitos

- OpenCode instalado
- PocketBase v0.23+
