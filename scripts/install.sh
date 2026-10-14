#!/bin/zsh
# Install the T3 build of pstack for Claude Code and Codex at once:
#   - skills  → ~/.agents/skills/<skill>        (Codex reads this folder)
#   - links   → ~/.claude/skills/<skill>        (Claude Code reads them; they point at the same files)
#   - sheet   → ~/.agents/t3-pstack-models.md   (written from adapter/sheets/<profile>.md only if missing)
#   - a marked instruction block in ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md
# Safe to run again: it updates its own skills, removes the ones upstream dropped, and never touches a skill or
# link it did not create.
set -euo pipefail
cd "${0:A:h}/.."
REPO="$PWD"

AGENTS_SKILLS="$HOME/.agents/skills"
CLAUDE_SKILLS="$HOME/.claude/skills"
MANIFEST="$HOME/.agents/.pstack-t3-installed"
SHEET="$HOME/.agents/t3-pstack-models.md"
case "$(scutil --get LocalHostName 2>/dev/null)" in
  *mini*|*Mini*) PROFILE=mini ;;
  *) PROFILE=macbook ;;
esac

./scripts/build.sh
mkdir -p "$AGENTS_SKILLS" "$CLAUDE_SKILLS"
typeset -a previous current skipped
[[ -f "$MANIFEST" ]] && previous=("${(@f)$(<"$MANIFEST")}")
current=(${(f)"$(cd dist/skills && ls -d */ | tr -d /)"})

for skill in $current; do
  dest="$AGENTS_SKILLS/$skill"
  if [[ -e "$dest" && ${previous[(Ie)$skill]} -eq 0 ]]; then
    skipped+=("$skill (~/.agents/skills/$skill is not ours)")
    continue
  fi
  rsync -a --delete "dist/skills/$skill/" "$dest/"
  link="$CLAUDE_SKILLS/$skill"
  if [[ -L "$link" || ! -e "$link" ]]; then
    ln -sfn "../../.agents/skills/$skill" "$link"
  else
    skipped+=("$skill (~/.claude/skills/$skill is a real folder, not linked)")
  fi
done

# Skills upstream removed since the last install.
for skill in $previous; do
  if [[ -n "$skill" && ${current[(Ie)$skill]} -eq 0 ]]; then
    rm -rf "$AGENTS_SKILLS/$skill"
    [[ -L "$CLAUDE_SKILLS/$skill" ]] && rm "$CLAUDE_SKILLS/$skill"
    print "removed $skill (dropped upstream)"
  fi
done
print -l $current > "$MANIFEST"

if [[ ! -f "$SHEET" ]]; then
  cp "adapter/sheets/$PROFILE.md" "$SHEET"
  print "wrote $SHEET from the $PROFILE default"
fi

# The marked block is replaced on every run, so editing adapter/instructions.md and reinstalling updates it.
block="$(cat adapter/instructions.md)"
for file in "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"; do
  mkdir -p "${file:h}"; touch "$file"
  python3 - "$file" "$block" <<'PY'
import re, sys
path, block = sys.argv[1], sys.argv[2].strip()
text = open(path).read()
marked = re.compile(r"<!-- pstack-t3:begin -->.*?<!-- pstack-t3:end -->\n?", re.S)
text = marked.sub("", text).rstrip()
open(path, "w").write((text + "\n\n" if text else "") + block + "\n")
PY
done

version="$(python3 -c "import json;print(json.load(open('upstream.json'))['version'])")"
print "pstack $version (T3) installed: ${#current} skills in ~/.agents/skills, linked in ~/.claude/skills, profile $PROFILE"
(( ${#skipped} )) && print -l "skipped:" "  "${^skipped}
exit 0
