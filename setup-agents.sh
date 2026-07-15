#!/usr/bin/env sh
# Link the portable agent configuration on macOS, Linux, or WSL.
set -eu

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

link_file() {
  source=$1
  target=$2
  mkdir -p "$(dirname -- "$target")"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Refusing to replace existing file: $target" >&2
    exit 1
  fi

  ln -sfn "$source" "$target"
  echo "Linked $target"
}

link_skills() {
  source_dir=$1
  target_dir=$2
  mkdir -p "$target_dir"

  for skill in "$source_dir"/*; do
    [ -d "$skill" ] || continue
    target="$target_dir/$(basename -- "$skill")"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "Refusing to replace existing skill: $target" >&2
      exit 1
    fi

    ln -sfn "$skill" "$target"
    echo "Linked $target"
  done
}

link_file "$DIR/home/AGENTS.md" "$HOME/.codex/AGENTS.md"
link_file "$DIR/home/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_file "$DIR/home/AGENTS.md" "$HOME/.copilot/copilot-instructions.md"

link_skills "$DIR/home/skills/codex" "$HOME/.codex/skills"
link_skills "$DIR/home/skills/claude" "$HOME/.claude/skills"
link_skills "$DIR/home/skills/copilot" "$HOME/.copilot/skills"

echo "Agent configuration is ready."
