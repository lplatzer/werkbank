# werkbank

My own agent setup, built from zero. Source of truth for identity, skills, hooks
and agent rules. Deliberately not tied to one harness: Claude Code is the first
target, but nothing in here should assume `~/.claude`.

## Layout (planned, grows as needed)

```
identity/            who I am, what I'm working toward (plain markdown)
skills/              Agent Skills format (SKILL.md), portable across harnesses
hooks/               plain scripts; resolve paths via $CLAUDE_CONFIG_DIR, never ~/.claude
adapters/
  claude-code/       settings.json + CLAUDE.md, linked into a profile dir
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
