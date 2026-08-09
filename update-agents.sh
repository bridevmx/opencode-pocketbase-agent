#!/bin/bash
# update-agents.sh
# Pulls every repo under REPOS_DIR and syncs agents, commands, and skills
# into the global opencode config directory.

set -euo pipefail

REPOS_DIR="/home/opencode-usr/.config/opencode/repos"
CONFIG_DIR="/home/opencode-usr/.config/opencode"
AGENTS_DIR="$CONFIG_DIR/agents"
COMMANDS_DIR="$CONFIG_DIR/commands"
SKILLS_DIR="$CONFIG_DIR/skills"

# Ensure target directories exist
mkdir -p "$AGENTS_DIR" "$COMMANDS_DIR" "$SKILLS_DIR"

echo "======================================="
echo " opencode — sync agents, commands, skills"
echo "======================================="

# -----------------------------------------------------------------------
# Helper: remove previously synced files from a repo before re-syncing.
# Reads a manifest file (.opencode-manifest) written on the previous run.
# -----------------------------------------------------------------------
remove_previous() {
    local manifest="$1"
    if [ -f "$manifest" ]; then
        while IFS= read -r file; do
            [ -e "$file" ] && rm -f "$file" && echo "  removed: $file"
        done < "$manifest"
        rm -f "$manifest"
    fi
}

# -----------------------------------------------------------------------
# Process each repo under REPOS_DIR
# -----------------------------------------------------------------------
for repo_dir in "$REPOS_DIR"/*/; do
    [ -d "$repo_dir/.git" ] || continue

    repo_name=$(basename "$repo_dir")
    manifest="$repo_dir/.opencode-manifest"

    echo ""
    echo "---------------------------------------"
    echo " Repo: $repo_name"
    echo "---------------------------------------"

    # Pull latest changes
    git -C "$repo_dir" pull --ff-only 2>&1 | sed 's/^/  /'

    # Remove files installed by the previous run of this repo
    remove_previous "$manifest"

    # Start a fresh manifest for this run
    : > "$manifest"

    # -------------------------------------------------------------------
    # AGENTS — repo/agents/<name>/agent.md  →  config/agents/<name>.md
    # -------------------------------------------------------------------
    if [ -d "$repo_dir/agents" ]; then
        for agent_dir in "$repo_dir/agents"/*/; do
            [ -d "$agent_dir" ] || continue
            agent_name=$(basename "$agent_dir")
            src="$agent_dir/agent.md"
            dst="$AGENTS_DIR/${agent_name}.md"

            if [ -f "$src" ]; then
                cp "$src" "$dst"
                echo "$dst" >> "$manifest"
                echo "  [agent]   $agent_name"
            fi
        done
    fi

    # -------------------------------------------------------------------
    # COMMANDS — repo/commands/<name>/<name>.md  →  config/commands/<name>.md
    # Also handles flat: repo/commands/<name>.md  →  config/commands/<name>.md
    # -------------------------------------------------------------------
    if [ -d "$repo_dir/commands" ]; then
        for entry in "$repo_dir/commands"/*/; do
            if [ -d "$entry" ]; then
                # Subdirectory format: commands/<name>/<name>.md
                cmd_name=$(basename "$entry")
                src="$entry/${cmd_name}.md"
                # Fallback: any .md inside the subdirectory
                if [ ! -f "$src" ]; then
                    src=$(find "$entry" -maxdepth 1 -name "*.md" | head -1)
                fi
                dst="$COMMANDS_DIR/${cmd_name}.md"

                if [ -f "$src" ]; then
                    cp "$src" "$dst"
                    echo "$dst" >> "$manifest"
                    echo "  [command] $cmd_name"
                fi
            fi
        done

        # Flat format: commands/<name>.md directly
        for src in "$repo_dir/commands"/*.md; do
            [ -f "$src" ] || continue
            cmd_name=$(basename "$src" .md)
            dst="$COMMANDS_DIR/${cmd_name}.md"
            cp "$src" "$dst"
            echo "$dst" >> "$manifest"
            echo "  [command] $cmd_name (flat)"
        done
    fi

    # -------------------------------------------------------------------
    # SKILLS — repo/skills/<name>/SKILL.md  →  config/skills/<name>/SKILL.md
    # -------------------------------------------------------------------
    if [ -d "$repo_dir/skills" ]; then
        for skill_dir in "$repo_dir/skills"/*/; do
            [ -d "$skill_dir" ] || continue
            skill_name=$(basename "$skill_dir")
            src="$skill_dir/SKILL.md"
            dst_dir="$SKILLS_DIR/$skill_name"
            dst="$dst_dir/SKILL.md"

            if [ -f "$src" ]; then
                mkdir -p "$dst_dir"
                cp "$src" "$dst"
                echo "$dst" >> "$manifest"
                echo "  [skill]   $skill_name"
            fi
        done
    fi
done

# -----------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------
echo ""
echo "======================================="
echo " Installed agents:"
ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} || echo "  (none)"

echo ""
echo " Installed commands:"
ls -1 "$COMMANDS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} || echo "  (none)"

echo ""
echo " Installed skills:"
ls -1 "$SKILLS_DIR"/*/SKILL.md 2>/dev/null | awk -F/ '{print $(NF-1)}' || echo "  (none)"
echo "======================================="
