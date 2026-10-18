# werkbank

My own agent setup, built from zero. Source of truth for identity, skills, hooks
and agent rules. Deliberately not tied to one harness: Claude Code is the first
target, but nothing in here should assume `~/.claude`.

## Layers

Three layers, each in its own repo so a machine only ever has the code it is
allowed to have. Layers are additive; nothing in a lower layer may depend on a
higher one.

| Layer      | Repo                                  | Machines        | Contents |
|------------|---------------------------------------|-----------------|----------|
| `core`     | `werkbank` (this repo, public-safe)   | every machine   | how I want agents to behave, generic skills (planning, review, debugging, writing), safety hooks |
| `personal` | `werkbank-personal` (private)         | personal only   | identity/goals, self-hosting stack knowledge, secondBrain access, home infra skills |
| `work`     | work repo (employer-owned)            | work machines   | how coding agents run at work: sandboxing, permissions, approved MCPs, data rules; team skills |
| `project`  | each project's own `.claude/` + `AGENTS.md` | wherever the repo is | project-specific skills and rules; native, travels with the repo |

Boundary rule: **core never contains personal data or employer IP**, because it
lands on the work laptop. If something is in doubt, it goes one layer up.

Precedence when rules conflict: project > work > personal > core. Work policy
beats my personal defaults on work machines; personal never runs there.

### How a layer plugs into Claude Code

- Each layer repo is a **plugin marketplace** with one or more plugins
  (skills, agents, hooks, MCP servers). Hooks use `${CLAUDE_PLUGIN_ROOT}`, so they
  work in any profile.
- Plugins can't ship always-on instructions, so each layer also has a
  `RULES.md`, pulled in via `@` imports from the profile's `CLAUDE.md`.
- **chezmoi picks the layers per machine** from `.is_personal`: it renders
  `~/.claude/settings.json` (`extraKnownMarketplaces` + `enabledPlugins`) and
  `~/.claude/CLAUDE.md` (the `@` imports), and clones the layer repos the machine
  should have.
- Canonical content stays harness-neutral (SKILL.md, plain markdown, plain
  scripts). The plugin manifests are thin Claude Code adapters around it, so a
  layer can be pointed at Pi, opencode or Codex later.

### This repo (planned, grows as needed)

```
RULES.md             always-on core behavior (imported by CLAUDE.md)
skills/              Agent Skills format (SKILL.md), portable across harnesses
hooks/               plain scripts, no hardcoded ~/.claude
.claude-plugin/      marketplace.json + plugin manifest(s): the Claude Code adapter
migration/           one-off scripts from the LifeOS move
docs/                notes, inspiration, decisions
```

## Profiles

Claude Code reads everything (settings, hooks, skills, agents, plugins, MCP,
history) from `CLAUDE_CONFIG_DIR`, defaulting to `~/.claude`. Each setup gets its
own directory, so they never mix.

| Command        | Config dir                           | What it is                          |
|----------------|--------------------------------------|-------------------------------------|
| `claude`       | `~/.claude`                          | plain Claude Code, werkbank grows here |
| `lifeos`       | `~/.claude-lifeos`                   | the old LifeOS install, read-only-ish |
| `ccp <name>`   | `~/.config/claude-profiles/<name>`   | any other extension I want to try   |

The functions live in the chezmoi-managed `.zshrc`. Each profile needs one
`/login`, because the macOS keychain entry is keyed per config dir.

Things that cross profiles anyway:

- `CLAUDE.md` files in parent directories of the working dir (keep `~` clean).
- A project's own `.claude/` folder.
- claude.ai connectors, which belong to the account rather than the profile.
- The IDE extensions and the desktop app, which always use `~/.claude`.
