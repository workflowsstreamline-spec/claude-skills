# universal-modder: setup on the gaming PC

Repo: https://github.com/rehan-remade/universal-modder

AI coding agents use it to mod PC games you own. The agent finds a game, works out which engine it runs on and the best way to mod it, reads the game's code, builds the mod, generates art, 3D and sound with fal, tests the mod in the running game, records a showcase video, and writes up what it learned in a shared knowledge base.

Assumes Windows with the games installed locally. WSL also works.

## 1. Prerequisites

PowerShell:

```powershell
winget install Git.Git Python.Python.3.12 Gyan.FFmpeg astral-sh.uv
winget install BlenderFoundation.Blender   # only for turning 3D models into sprites (um render3d)
```

Open a new terminal, then check:

```powershell
git --version; python --version; ffmpeg -version; uv --version
```

## 2. Claude Code

```powershell
irm https://claude.ai/install.ps1 | iex
claude
```

## 3. Install the plugin

Inside Claude Code:

```
/plugin marketplace add rehan-remade/universal-modder
/plugin install universal-modder@universal-modder
```

Restart Claude Code. The plugin's startup hook puts the `um` CLI on PATH automatically.

To use `um` outside Claude Code, or with another agent:

```powershell
uv tool install git+https://github.com/rehan-remade/universal-modder
```

## 4. fal API key (art, 3D, audio, video)

1. Get a key: https://fal.ai/dashboard/keys
2. Store it for the `um fal` commands:
   ```powershell
   um fal key set     # hidden prompt, saved to ~/.secrets/fal-key
   ```
3. The fal MCP server reads the key from the `FAL_KEY` environment variable, so set it before you start Claude Code:
   ```powershell
   $env:FAL_KEY = Get-Content "$HOME\.secrets\fal-key" -Raw
   claude
   ```

Without `FAL_KEY`, the fal MCP server gets a 401 error, and Claude Code won't fall back to browser sign-in on its own. To use browser sign-in instead, add fal's sign-in server and authenticate it in `/mcp`:

```powershell
claude mcp add --transport http fal-oauth https://mcp.fal.ai/mcp-relay
```

`um comfy` also makes images on a local ComfyUI server with no key.

## 5. Check the install

```powershell
um --version
um scan                    # lists installed Steam/Epic/Xbox games, with engine and route
um kb search "terraria"    # finds earlier write-ups for a game
um fal key status
```

## 6. First run

Start Claude Code in an empty working folder, not inside a game folder. Example prompts:

> What engine is `C:\Program Files (x86)\Steam\steamapps\common\<Game>`, and has anyone modded it before?

> Mod Terraria: add a homing missile launcher and a tactical nuke that craters the world. Make the sprites with fal.

> Make a new civilization for Age of Empires II with a unique unit rendered from 3D.

The agent starts with the `mod-any-game` skill (`/universal-modder:mod-any-game` when installed as a plugin). It backs up your saves, builds one small working piece first, and tests it in the game before going further.

For mods that take days, run the three-agent team (orchestrator plus two workers). It uses several times more tokens:

```powershell
claude --agent mod-orchestrator
```

## Rules

- Games you own: single-player, multiplayer, or servers you host. Never touch online clients protected by anti-cheat. Never write cheats against other players. Never bypass anti-cheat, DRM or ownership checks.
- The agent asks before it drives your mouse and keyboard, installs mod loaders into game folders, changes the registry, or publishes anything.
- Let the agent run `um backup` on your save folders before it changes anything.
- Run `um publish check <mod-folder>` before sharing a mod. It blocks game files, decompiled code and leaked keys.
- Knowledge-base write-ups go up as PRs (`um kb pr`). Only approve one after you've checked it works.
