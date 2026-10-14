# pstack model configuration (T3). One line per role; see ~/.agents/skills/poteto-mode/references/t3.md → The sheet.
# MacBook default: Claude and Codex through the CLI Proxy pool (claudeProxy, codexProxy), Grok direct.
# budget: medium (high)
feature, refactoring: codexProxy/gpt-6.1-sol reasoningEffort=high
bug-fix: codexProxy/gpt-6.1-sol reasoningEffort=xhigh
perf-issue: codexProxy/gpt-6.1-sol reasoningEffort=xhigh
hillclimb: codexProxy/gpt-6.1-sol reasoningEffort=xhigh
judgment and prose: claudeProxy/claude-opus-5-5 effort=high
hardest tasks: claudeProxy/claude-fable-5-1 effort=xhigh
how explorer: grok/grok-4.7-build-fast
how explainer: claudeProxy/claude-opus-5-5 effort=high
why investigators: grok/grok-4.7-build-fast
why synthesizer: claudeProxy/claude-opus-5-5 effort=high
reflect tooling: grok/grok-4.7-build-fast
reflect judgment, divergent, synthesizer: claudeProxy/claude-opus-5-5 effort=high
arena runners: claudeProxy/claude-opus-5-5 effort=high, codexProxy/gpt-6.1-sol reasoningEffort=high, grok/grok-4.7-build-fast
arena cross-judge pool: claudeProxy/claude-opus-5-5 effort=high, codexProxy/gpt-6.1-sol reasoningEffort=high, grok/grok-4.7-build-fast
swarm workers: codexProxy/gpt-6.1-sol reasoningEffort=medium
architect runners: claudeProxy/claude-opus-5-5 effort=high, codexProxy/gpt-6.1-sol reasoningEffort=high, grok/grok-4.7-build-fast
interrogate reviewers: claudeProxy/claude-opus-5-5 effort=high, codexProxy/gpt-6.1-sol reasoningEffort=high, grok/grok-4.7-build-fast
