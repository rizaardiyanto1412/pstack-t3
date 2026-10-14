#!/bin/zsh
# One-time setup on a Mac: clone this repo to ~/.agents/pstack-t3-src (outside Documents, which a background job
# cannot read without a hidden privacy dialog), install pstack, and add a daily LaunchAgent that pulls main and
# reinstalls when it changed. Run again to repair.
#   zsh -c "$(gh api repos/rizaardiyanto1412/pstack-t3/contents/scripts/setup-machine.sh --jq .content | base64 -d)"
set -euo pipefail
SRC="$HOME/.agents/pstack-t3-src"
REPO="rizaardiyanto1412/pstack-t3"
LABEL="local.pstack-t3.update"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# HTTPS with gh as the credential helper, set in this clone only: a background job may not reach an SSH key.
if [[ ! -d "$SRC/.git" ]]; then
  git clone -q -c credential.helper= -c 'credential.helper=!gh auth git-credential' "https://github.com/$REPO.git" "$SRC"
fi
git -C "$SRC" pull -q --ff-only
"$SRC/scripts/install.sh"

mkdir -p "${PLIST:h}"
cat > "$PLIST" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key><array><string>/bin/zsh</string><string>$SRC/scripts/auto-update.sh</string></array>
  <key>StartCalendarInterval</key><dict><key>Hour</key><integer>9</integer><key>Minute</key><integer>15</integer></dict>
  <key>EnvironmentVariables</key><dict><key>PATH</key><string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string></dict>
  <key>StandardOutPath</key><string>$HOME/.agents/pstack-t3-update.log</string>
  <key>StandardErrorPath</key><string>$HOME/.agents/pstack-t3-update.log</string>
</dict>
</plist>
PL
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"
print "daily update job: $LABEL (09:15), log ~/.agents/pstack-t3-update.log"
