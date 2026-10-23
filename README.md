# claude-skills

Every Claude Code skill and slash command from `~/.claude`, plus the list of installed plugins.

- `skills/` - copy of `~/.claude/skills`
- `commands/` - copy of `~/.claude/commands`
- `plugins.txt` - one line per plugin: `<github repo> <plugin>@<marketplace>`
- `agents-skills.txt` - Codex skills (`~/.agents/skills`) identical to one in `skills/`, by name
- `agents-skills/` - Codex skills that differ from their Claude copy or exist only for Codex
- `docs/` - setup guides that need more than a plugin install, e.g. [universal-modder](docs/universal-modder-setup.md) on the gaming PC

## New machine

```powershell
git clone <this repo> $HOME\claude-skills
powershell -ExecutionPolicy Bypass -File $HOME\claude-skills\sync.ps1 -Install
```

Restart Claude Code afterwards. Later updates: `git pull`, then the same `-Install` line.

## After adding or changing a skill

```powershell
powershell -ExecutionPolicy Bypass -File $HOME\claude-skills\sync.ps1
```

Copies the current skills in, commits, and pushes. Edit skills in `~/.claude`, never in this folder: the sync mirrors over it.

## Not in here

Plugins that come from the Claude desktop app or the claude.ai account (sales, marketing, zoominfo, anthropic-skills and so on) follow the account, not the machine. Sign in and they appear.
