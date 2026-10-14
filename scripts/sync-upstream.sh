#!/bin/zsh
# Copy the newest cursor/plugins/pstack into upstream/ (exact copy) and record it in upstream.json.
# Prints "unchanged" and exits 0 when upstream has no new commit for pstack/.
set -euo pipefail
cd "${0:A:h}/.."
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
git clone -q --depth 1 --filter=blob:none --sparse https://github.com/cursor/plugins.git "$tmp/plugins"
git -C "$tmp/plugins" sparse-checkout set pstack
commit="$(git -C "$tmp/plugins" rev-parse HEAD)"
old="$(python3 -c "import json;print(json.load(open('upstream.json'))['commit'])")"
rsync -a --delete --exclude .git "$tmp/plugins/pstack/" upstream/
if git diff --quiet -- upstream && [[ -z "$(git ls-files --others --exclude-standard upstream)" ]]; then
  print unchanged; exit 0
fi
version="$(python3 -c "import json;print(json.load(open('upstream/.cursor-plugin/plugin.json'))['version'])")"
python3 - "$commit" "$version" <<'PY'
import json, sys, datetime
data = json.load(open("upstream.json"))
data.update(commit=sys.argv[1], version=sys.argv[2],
            synced=datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%MZ"))
json.dump(data, open("upstream.json", "w"), indent=2); open("upstream.json", "a").write("\n")
PY
print "updated $old → $commit ($version)"
