<!-- pstack-t3:begin -->
## pstack (T3 Code)

pstack's skills (poteto-mode, interrogate, arena, how, why, and the principle skills) are installed in
`~/.agents/skills`; Claude Code reads them through links in `~/.claude/skills`. Source:
`~/Documents/pstack-t3` on the MacBook, `rizaardiyanto1412/pstack-t3` on GitHub.

- They were written for Cursor. Before you spawn a subagent, pick a model, schedule, watch a PR, or use a
  Cursor-only command or path, read `~/.agents/skills/poteto-mode/references/t3.md`. It overrides the skills on
  those points.
- They are user-only upstream (`disable-model-invocation`), so they are **not in your skill list**; that does not
  mean they are missing. When the user names one anywhere in a message (`/poteto-mode`, `/swarm`,
  `$no-comments`, "use interrogate"), read `~/.agents/skills/<name>/SKILL.md` at once and follow it; do not
  search for it. A message that starts with the command has already loaded it.
- Models per role: `~/.agents/t3-pstack-models.md`.
- Outside T3 Code (no `t3-code` MCP tools), skills that dispatch subagents cannot run their panels. Say so.
<!-- pstack-t3:end -->
