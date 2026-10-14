# Working on pstack-t3

Read `README.md` first. Rules:

- Never edit `upstream/`. It is replaced by `scripts/sync-upstream.sh` on every update.
- Put every T3 difference in `adapter/`. Prefer a line in `adapter/t3.md` over a text rewrite; add a rewrite to
  `adapter/substitutions.tsv` only for a plain path.
- Every T3 tool name in `t3.md` must exist in the installed T3 Code. Check new ones in
  `/Applications/T3 Code (Nightly).app/Contents/Resources/app.asar` (search for `"<tool_name>"`).
- After a change: `scripts/build.sh`, `scripts/check.sh` (0 new lines, or `--accept` after review), then
  `scripts/install.sh` to try it locally.
