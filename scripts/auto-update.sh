#!/bin/zsh
# Daily job (LaunchAgent local.pstack-t3.update): install main when it changed since the last install.
set -euo pipefail
cd "${0:A:h}/.."
before="$(git rev-parse HEAD)"
git pull -q --ff-only
after="$(git rev-parse HEAD)"
stamp="$HOME/.agents/.pstack-t3-installed-commit"
if [[ "$after" != "$before" || "$(cat "$stamp" 2>/dev/null)" != "$after" ]]; then
  print "$(date '+%F %T') installing ${after:0:7}"
  ./scripts/install.sh
  print "$after" > "$stamp"
fi
