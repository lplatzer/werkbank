# Inspiration

Collected 2026-10-18. Star counts and feature lists come from search snippets
and blog roundups, so check the repo before adopting anything.

## Directories (where to look first)

- [hesreallyhim/awesome-claude-code](https://gittrend.io/repo/hesreallyhim/awesome-claude-code):
  the canonical hand-curated list of skills, hooks, commands, orchestrators.
- [ClaudeFast: 11 curated lists](https://claudefa.st/blog/tools/resources/awesome-claude-code):
  meta-list; points at punkpeye/awesome-mcp-servers, affaan-m/everything-claude-code
  (the firehose), quemsah/awesome-claude-plugins.
- [ithiria894/awesome-claude-code-hooks](https://awesome.ecosyste.ms/projects/github.com%2Fithiria894%2Fawesome-claude-code-hooks):
  hooks only.
- Anthropic's official plugin marketplace (`claude-plugins-official`), already
  known to Claude Code. Start here for LSPs, code-review, security-guidance
  ([roundup](https://designrevision.com/blog/best-claude-code-plugins)).

## Workflow frameworks (steal ideas, don't install wholesale)

- **Superpowers** (obra): brainstorm → spec → plan → TDD execution with review
  between tasks, fresh subagent per task
  ([guide](https://www.developersdigest.tech/blog/claude-code-superpowers-plugin-guide)).
  Strongest reference for "skills that enforce a process".
- **Compound Engineering** (EveryInc): Plan → Work → Review → Compound loop; the
  "compound" step turns each session's lessons into reusable rules. Ships a CLI
  that converts Claude Code plugins to OpenCode/Codex/Gemini CLI
  ([overview](https://mintlify.com/EveryInc/compound-engineering-plugin/plugin/overview)).
  Relevant to keeping werkbank harness-independent.
- **Get Shit Done (GSD)**: spec-driven, phase-based, atomic commits, built
  around fighting context rot
  ([docs](https://www.mintlify.com/gsd-build/get-shit-done)). Repo home may
  have moved to open-gsd/gsd-core; check before relying on it.

## Memory / second brain (closest to what LifeOS did)

- [coleam00/second-brain-starter](https://github.com/coleam00/second-brain-starter):
  a skill that interviews you and writes a PRD for your own assistant. Markdown +
  Obsidian + a few hooks, no framework. Good model for "start from zero".
- [SirCharan/second-brain](https://github.com/SirCharan/second-brain): hooks write
  session captures into an Obsidian-compatible vault, recall at prompt time,
  snapshot before compaction. Hooks-only sibling: *continuum*.
- [eugeniughelbur/obsidian-second-brain](https://github.com/eugeniughelbur/obsidian-second-brain):
  Obsidian-vault memory shared across Claude Code, Codex and others. Relevant to
  ~/secondBrain and the G8 sync idea.
- [mikeadolan/claude-brain](https://github.com/mikeadolan/claude-brain): SQLite +
  MCP + hooks variant, if markdown stops scaling.
- Built-in auto memory (MEMORY.md) is the zero-dependency baseline to beat.

## Hooks (safety and quality gates)

- [dwarvesf/claude-guardrails and friends](https://awesome.ecosyste.ms/projects/github.com%2Fithiria894%2Fawesome-claude-code-hooks):
  destructive-command blocking, pipe-to-shell blocking, prompt-injection scan.
- [Hook examples you can copy](https://www.morphllm.com/claude-code-hooks-examples):
  formatting, test gating, protected files, commit linting, notifications.
- Lesson from LifeOS: 30+ hooks made sessions noisy and slow. Add a hook only
  when a rule keeps getting broken *and* can be checked deterministically.

## Portability

- **Agent Skills** (agentskills.io): SKILL.md is an open standard read by Claude
  Code, Codex CLI, Gemini CLI, Copilot, Cursor and others; loading details
  differ per tool ([write-up](https://codex.danielvaughan.com/2026/05/05/agent-skills-open-standard-portable-skills-codex-cli-cross-agent/)).
  werkbank skills should stick to the core spec.
- **Profiles via CLAUDE_CONFIG_DIR**: the [classmethod write-up](https://dev.classmethod.jp/articles/2026-03-28-claude-config-dir-multi-profile/)
  and [wmedia tip](https://wmedia.es/en/tips/claude-code-multiple-profiles-config-dir)
  match what we built. Known gotchas: hooks hardcoding `~/.claude` leak across
  profiles; one (closed) bug had plugin installs bleed between profiles.

## Worth salvaging from LifeOS (in ~/.claude-lifeos)

Candidates to rebuild small, not copy: TELOS/identity files (content is yours),
the FirstPrinciples / RedTeam / Council thinking skills, the CreateSkill
discipline, the statusline. Probably leave behind: the Algorithm/ISA ceremony,
format gates, Pulse.
