---
description: Pre-deploy checklist for this project — tests, secrets, diff, gotchas
---

Run before deploying anything. Report a go / no-go with reasons. **Do not
deploy** — this command only checks.

1. **Tests.** Find and run them. `casedesk` has `test_*.py`; `satori-recruit-v2`
   self-tests via `python engine/db.py` and `python engine/normalize.py`;
   `vellum-local` has `python run.py doctor` and `selftest.py`. If a project has
   no tests, say so plainly rather than reporting a pass.
2. **Secrets.** Confirm nothing staged or committed contains a credential.
   Specifically check that `.env.local`, `.env`, service-role keys, and Gmail
   credentials are gitignored and not in the diff. Grep the diff for
   `SB_SECRET`, `service_role`, `api_key`, `password`, `BEGIN PRIVATE KEY`.
3. **Diff review.** `git status` and `git diff`. Summarise what actually changed.
   Flag anything touched that the user did not ask about.
4. **Data integrity invariants** — check the ones that apply:
   - No code path rewrites a whole table (satori-recruit-v2, casedesk).
   - Event logs stay append-only (satori-recruit-v2, vellum-local).
   - Status history is appended, not overwritten (billion-hair-bookings).
   - Pre-migration backup still fires (daybook).
5. **Client-facing check.** `casedesk` and `thakar-legal-portal` are a real law
   firm's; `billion-hair-bookings` is a real salon's. If this is one of those,
   confirm no real client data is in the deployed payload or in seed files.
6. **Known drift points.**
   - `thakar-legal-portal`: `data.js` and `api/_lib/matters.json` must agree.
   - Satori repos: the two shared context docs may be stale — suggest
     `/sync-satori`.
7. **Local render.** Serve it and confirm the page loads without console errors.

Finish with an explicit **GO** or **NO-GO** line and, if no-go, the shortest
path to green. Deployment itself stays a separate, explicitly-asked-for step.
