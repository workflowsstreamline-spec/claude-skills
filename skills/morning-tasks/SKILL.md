---
name: morning-tasks
description: Show today's Satori work tasks from EOD Desk and capture new ones. Use whenever Aditya opens the day — "Morning Claude", "good morning", "morning", "what's on today", "my tasks", "task list", "what do I have on", "add a task", "remind me to", "put this on my list" — or when a conversation surfaces something he needs to do later. Reads and writes the local EOD Desk database at C:\Users\adity\eod-desk.
---

# Morning tasks

Aditya's Satori Craft work lives in **EOD Desk**, a local SQLite app at
`C:\Users\adity\eod-desk` (port 8890). This skill is the read/write front door
for it in an ordinary chat.

State persists in the database, so day-to-day continuity is automatic — a task
added on Monday is still there on Tuesday. Do not keep task state in the
conversation; always read and write through the commands below.

## Showing the day

Run this first, always:

```
cd C:\Users\adity\eod-desk && python run.py today
```

It prints, in order: **Not started**, **Waiting on someone**, **In flight**, then
what closed in the last few days, with an `#id` against each row.

Relay it in prose rather than dumping the raw table. Lead with the shortest,
most decision-shaped list — usually **Not started**, since those are the ones
that quietly roll over — then anything blocked that has been blocked since
before today. In flight is context, not a call to action; keep it brief.

Do not editorialise about volume ("you've got a lot on"), and do not scold about
anything still open. State what is there and stop.

## Adding a task

```
cd C:\Users\adity\eod-desk && python run.py add "Title" --ws SEA --detail "..." --status open
```

- `--ws` — SEA, SFC, Sales, Scotty, Warpdrive Hiring, Virtual Internships,
  Employer Brand, Ops. Default Ops. Infer it from the task; ask only when it is
  genuinely ambiguous.
- `--status` — `open` (not started), `in_flight`, `blocked`, `closed`, `parked`.
  Default `in_flight`. Something he has not begun is `open`.
- `--blocked-on` — a name, when he is waiting on someone. Use `Ranaq` exactly
  when it is Ranaq, because the EOD composer keys its "Waiting on Ranaq" section
  off that string.

After showing the day, offer once to add anything — a single short line, not a
form. Take whatever he gives in plain language and turn it into the flags
yourself. Confirm each add in a few words and move on.

**Capture in passing too.** If he mentions something he needs to do while the
conversation is about something else, offer to add it. Do not add it silently.

## Changing a task

To close, unblock or re-status something, use its `#id` from `run.py today`:

```
cd C:\Users\adity\eod-desk && python -c "import sys; sys.path.insert(0,'.'); from eod import db; con=db.connect(); con.execute('BEGIN'); db.set_status(con,ID,'closed'); con.commit(); con.close()"
```

## What this skill does not do

- **It does not send anything.** The end-of-day message to Ranaq is drafted by
  `python run.py eod` and pasted into Teams by Aditya himself. There is no send
  path, by design.
- **It does not sync from Teams, Outlook or Granola.** Two scheduled tasks do
  that: `eod-desk-morning` on weekdays at 10:30, which sweeps everything since
  18:00 the previous business day and ingests it, and `eod-desk-sync` at 18:07,
  which does the full evening gather plus the EOD message and Ranaq's view. Both
  read chat, mail and meeting notes; both live on the **workflows.streamline**
  account, where the Microsoft 365 and Granola connectors are authorised.

  Meeting outcomes therefore arrive in the list at 10:30 and 18:07, not live. If
  he asks about a call that just ended, read Granola directly
  (`list_meetings` → `get_meetings`) and say the list has not caught up yet
  rather than reporting the stale row.

  So the freshness of what this skill shows depends on when you ask. Before
  10:30 you are looking at where last evening's sync left things — say so rather
  than implying the list reflects this morning's mail.
- **It does not touch compensation.** Salary analysis lives in a separate private
  document; nothing about pay belongs in the task list or in anything exported.

## Related

`/morning` (the anthropic-skills brief) covers calendar, inbox and chat for the
day. This covers the task list. They compose well — run the brief for the shape
of the day, this for the work carried into it — but neither needs the other.
