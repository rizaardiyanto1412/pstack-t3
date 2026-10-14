#!/bin/zsh
# List Cursor-specific lines in the built skills that are not in adapter/known-cursor-lines.txt.
# Every line in that file was reviewed against adapter/t3.md. A new line means upstream added a Cursor usage:
# check that t3.md covers it, extend t3.md if not, then run `check.sh --accept` to record it.
set -euo pipefail
cd "${0:A:h}/.."
[[ -d dist/skills ]] || ./scripts/build.sh >/dev/null
python3 - "${1:-}" <<'PY'
import pathlib, re, sys
root = pathlib.Path("dist/skills")
pats = [re.compile(l) for l in pathlib.Path("adapter/cursor-patterns.txt").read_text().splitlines()
        if l and not l.startswith("#")]
preamble = pathlib.Path("adapter/preamble.md").read_text().strip()
found = set()
for md in sorted(root.rglob("*.md")):
    if md.name == "t3.md":
        continue
    for line in md.read_text().splitlines():
        line = line.strip()
        if line and line != preamble and any(p.search(line) for p in pats):
            found.add(f"{md.relative_to(root)}\t{line}")
known_file = pathlib.Path("adapter/known-cursor-lines.txt")
if sys.argv[1] == "--accept":
    known_file.write_text("".join(sorted(f + "\n" for f in found)))
    print(f"recorded {len(found)} reviewed lines")
    sys.exit(0)
known = set(known_file.read_text().splitlines()) if known_file.exists() else set()
new = sorted(found - known)
gone = len(known - found)
print(f"Cursor-specific lines: {len(found)} total, {len(new)} new, {gone} no longer present")
for line in new:
    path, text = line.split("\t", 1)
    print(f"- `{path}`: {text[:240]}")
PY
