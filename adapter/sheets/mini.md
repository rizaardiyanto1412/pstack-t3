# pstack model configuration (T3). One line per role; see ~/.agents/skills/poteto-mode/references/t3.md → The sheet.
# Mac mini default: claudeAgent and codex (both routed through the local CLI Proxy). No Grok here, so fast roles use gpt-6-luna.
# budget: medium (high)
feature, refactoring: codex/gpt-6.1-sol reasoningEffort=high
bug-fix: codex/gpt-6.1-sol reasoningEffort=xhigh
perf-issue: codex/gpt-6.1-sol reasoningEffort=xhigh
hillclimb: codex/gpt-6.1-sol reasoningEffort=xhigh
judgment and prose: claudeAgent/claude-opus-5-5 effort=high
hardest tasks: claudeAgent/claude-fable-5-1 effort=xhigh
how explorer: codex/gpt-6-luna reasoningEffort=medium
how explainer: claudeAgent/claude-opus-5-5 effort=high
why investigators: codex/gpt-6-luna reasoningEffort=medium
why synthesizer: claudeAgent/claude-opus-5-5 effort=high
reflect tooling: codex/gpt-6-luna reasoningEffort=medium
reflect judgment, divergent, synthesizer: claudeAgent/claude-opus-5-5 effort=high
arena runners: claudeAgent/claude-opus-5-5 effort=high, codex/gpt-6.1-sol reasoningEffort=high
arena cross-judge pool: claudeAgent/claude-opus-5-5 effort=high, codex/gpt-6.1-sol reasoningEffort=high
swarm workers: codex/gpt-6.1-sol reasoningEffort=medium
architect runners: claudeAgent/claude-opus-5-5 effort=high, codex/gpt-6.1-sol reasoningEffort=high
interrogate reviewers: claudeAgent/claude-opus-5-5 effort=high, codex/gpt-6.1-sol reasoningEffort=high
