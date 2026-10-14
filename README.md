# pstack-t3

[poteto's pstack](https://github.com/cursor/plugins/tree/main/pstack) for **T3 Code**, one install for both Claude
Code and Codex. Private.

## How it works

```
cursor/plugins/pstack ──weekly PR──▶ upstream/ (exact copy) ──build──▶ dist/skills ──install──▶ ~/.agents/skills
                                      adapter/ (ours)                                          ~/.claude/skills (links)
```

- **`upstream/`** is an exact copy of `cursor/plugins/pstack`. Never edit it by hand.
- **`adapter/t3.md`** says how to do each Cursor-specific thing in T3 (subagents → `delegate_task`, models →
  `orchestrator_capabilities` + the sheet, `/loop` → `schedule_task`, babysit → `watch-pr` + `watch_pull_request`,
  and so on). The build puts it at `~/.agents/skills/poteto-mode/references/t3.md`.
- **The build** changes upstream text in two ways only: the path rewrites in `adapter/substitutions.tsv`, and one
  line (`adapter/preamble.md`) under the heading of each skill that has Cursor-specific text or is listed in
  `adapter/stamp-skills.txt`.
- **`adapter/sheets/`** has the default model sheet per Mac. `install.sh` writes it to
  `~/.agents/t3-pstack-models.md` only when that file is missing; after that the sheet is yours (`/setup-pstack`).
- **`adapter/instructions.md`** is a marked block that `install.sh` keeps in `~/.claude/CLAUDE.md` and
  `~/.codex/AGENTS.md`.

Codex reads `~/.agents/skills` directly; Claude Code reads the links. 52 of the 53 skills are user-only upstream
(`disable-model-invocation`): start them with `/interrogate` (Claude Code) or `$interrogate` (Codex).

## Updates

1. **Weekly** (Monday 02:00 UTC, or Actions → "Update from upstream pstack" → Run): the workflow copies the newest
   upstream, builds, runs `scripts/check.sh`, and opens a PR with the version change, the changed skills, the
   upstream commits, and any **new Cursor-specific lines**.
2. **Review and merge.** A new Cursor-specific line means upstream started using a Cursor feature in a new place:
   make sure `adapter/t3.md` covers it, then `scripts/check.sh --accept` on the branch.
3. **Each Mac installs `main`** by itself once a day (09:15, LaunchAgent `local.pstack-t3.update`, log
   `~/.agents/pstack-t3-update.log`), or now: `~/.agents/pstack-t3-src/scripts/install.sh`.

## New Mac

```sh
zsh -c "$(gh api repos/rizaardiyanto1412/pstack-t3/contents/scripts/setup-machine.sh --jq .content | base64 -d)"
```

## Scripts

| Script | Does |
|---|---|
| `scripts/sync-upstream.sh` | Copy the newest upstream into `upstream/`, update `upstream.json` |
| `scripts/build.sh` | Build `dist/skills` |
| `scripts/check.sh` | List new Cursor-specific lines (`--accept` records them as reviewed) |
| `scripts/install.sh` | Build and install on this Mac |
| `scripts/setup-machine.sh` | First-time setup on a Mac (clone + install + daily job) |

pstack is © Lauren Tan (poteto) and contributors, MIT (`upstream/LICENSE`). The T3 adapter was written with
[chhoumann/t3-pstack](https://github.com/chhoumann/t3-pstack) and
[michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude) as references.
