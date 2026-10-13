---
description: Start a local project app on its assigned port and open the dashboard
argument-hint: [project name, e.g. daybook]
---

Start the local app for: **$ARGUMENTS**

Use the port map in the global CLAUDE.md. Never reassign a port.

| Port | Project | Start command |
|---|---|---|
| 8811 | noi-tool | `python run.py serve` |
| 8823 | daybook | `python run.py serve` |
| 8833 | sales-navigator | `python run.py serve` |
| 8840 | claude-credit-monitor | `python ccm.py serve` |
| 8850 | vellum-local | `python run.py serve` |
| 8860 | talent-desk | `python run.py serve` |
| 8877 | casedesk | `python server.py` |

Static sites have no server of their own — `python -m http.server <port> --directory <folder>`:
`thakar-legal-portal` (5173), `billion-hair-bookings` (4519), `aditya-portfolio` (4602),
`satori-eor` (8790), `cuhrious-show-site/next` (8899).

**`C:\Users\adity\.claude\launch.json` already defines most of these.** Prefer
`preview_start` with the config *name* over building a command by hand — the
names are `satori-site`, `satori-recruit`, `portal`, `billion-hair-bookings`,
`portfolio`, `satori-eor`, `sales-navigator`, `cuhrious-next`, `credit-monitor`,
`vellum-local`, `talent-desk`, `casedesk`, `casedesk-static`. If launch.json and
the table above ever disagree, **launch.json wins** — then fix the table.

Steps:

1. If no project was named, list the table above and ask which one.
2. Check whether the port is already in use before starting anything —
   `Get-NetTCPConnection -LocalPort <port> -ErrorAction SilentlyContinue`.
   If it is already serving, say so and skip to step 4 rather than starting a
   second copy.
3. Start it with `preview_start` (never a raw background Bash server), pointing
   at `http://127.0.0.1:<port>`.
4. Open the dashboard, read the page to confirm it rendered, and check
   `preview_logs` and the browser console for errors.
5. Report the URL and anything in the logs that looks wrong.

Do not run any `reset` command. Those wipe data.
