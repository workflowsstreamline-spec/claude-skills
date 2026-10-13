---
description: Write a session handoff doc so the next session starts with full context
argument-hint: [optional filename, defaults to SESSION_HANDOFF.md]
---

Write a handoff document for the current project so a fresh session — or the
other Claude account — can pick this up cold.

Target file: **$ARGUMENTS** (default `SESSION_HANDOFF.md` in the project root).

Gather first, then write:

1. `git status` and `git log --oneline -15` if this is a repo. If it is not a
   repo, say so — that itself is worth recording.
2. What changed this session, from the actual diff, not from memory.
3. Anything left running (dev servers, background tasks) and on which port.

Then write the file with these sections:

- **State** — one paragraph: what works right now, what is half-done.
- **Changed this session** — bullet list, each with the file path.
- **Next steps** — ordered, specific, each one actionable without this
  conversation. "Fix the auth bug" is useless; name the file and the symptom.
- **Open questions** — decisions that need the user, not guesses.
- **Gotchas** — anything that cost time this session and would cost it again.
- **How to run it** — the exact command and port.

Rules:

- Absolute file paths or repo-relative, never "the file we were editing".
- If a credential or client data is involved, name the file, never the contents.
- If there is an existing handoff file, read it first and supersede it cleanly —
  do not append a second stale copy underneath.
- Date it with today's date in absolute form.
