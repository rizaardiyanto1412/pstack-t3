#!/bin/zsh
# Build the T3 version of pstack from upstream/ into dist/skills/. Upstream text is copied unchanged except for
# the path rewrites in adapter/substitutions.tsv and one preamble line (adapter/preamble.md) under the first
# heading of every skill that has Cursor-specific text. The adapter (t3.md) and the agent files go into
# poteto-mode/references/.
set -euo pipefail
cd "${0:A:h}/.."
rm -rf dist && mkdir -p dist/skills
rsync -a upstream/skills/ dist/skills/
mkdir -p dist/skills/poteto-mode/references/agents
cp upstream/agents/*.md dist/skills/poteto-mode/references/agents/
cp adapter/t3.md dist/skills/poteto-mode/references/t3.md
cp upstream/LICENSE dist/LICENSE-pstack

python3 - <<'PY'
import pathlib, re
subs = [l.split("\t") for l in pathlib.Path("adapter/substitutions.tsv").read_text().splitlines()
        if l and not l.startswith("#")]
patterns = [re.compile(l) for l in pathlib.Path("adapter/cursor-patterns.txt").read_text().splitlines()
            if l and not l.startswith("#")]
preamble = pathlib.Path("adapter/preamble.md").read_text().strip()
always = {l.strip() for l in pathlib.Path("adapter/stamp-skills.txt").read_text().splitlines()
          if l.strip() and not l.startswith("#")}
stamped = 0
for md in pathlib.Path("dist/skills").rglob("*.md"):
    if md.name == "t3.md":
        continue
    text = md.read_text()
    for old, new in subs:
        text = text.replace(old, new)
    md.write_text(text)
for skill in sorted(pathlib.Path("dist/skills").iterdir()):
    main = skill / "SKILL.md"
    if not main.exists():
        continue
    body = "\n".join(p.read_text() for p in skill.rglob("*.md") if p.name != "t3.md")
    if skill.name not in always and not any(p.search(body) for p in patterns):
        continue
    text = main.read_text()
    # Under the first "# " heading, after the YAML front matter.
    m = re.search(r"^# .*$", text, re.M)
    if m:
        text = text[:m.end()] + "\n\n" + preamble + "\n" + text[m.end():]
    else:
        text = preamble + "\n\n" + text
    main.write_text(text)
    stamped += 1
print(f"built {sum(1 for d in pathlib.Path('dist/skills').iterdir() if d.is_dir())} skills, preamble on {stamped}")
PY
