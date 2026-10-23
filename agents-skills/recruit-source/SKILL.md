---
name: recruit-source
description: Source candidates for a role via LinkedIn X-ray search driven through the user's authenticated Chrome. Generates X-ray queries from the role, opens and verifies every real profile, then adds only verified candidates with provenance into Talent Desk. Use when the user asks to source, find, search for, or pull candidates for a role.
---

# /recruit source — authentic LinkedIn sourcing

## Core principle
The model is NEVER the source of truth. Every candidate must come from a real LinkedIn
profile opened and read in the user's logged-in Chrome. Nothing the model recalls or invents
is stored as fact. This is the single rule that prevents the v1 fabrication problem.

## Where the data goes
`C:\Users\adity\talent-desk` — SQLite at `data/talent.db`, dashboard on
<http://127.0.0.1:8860>. Run everything from the project root.

The old Supabase engine in `satori-recruit-v2` is **gone** — the project host no longer
resolves in DNS and the 2026-08-09 export captured nothing. Do not call `engine/` code.

## Prerequisites
- Codex-in-Chrome extension connected; the user is signed into LinkedIn in that Chrome.
  The LinkedIn Windows app cannot be used for sourcing: it is a native WinUI app with no
  DOM and no address bar, so it cannot yield the profile URL that dedup depends on.
- A `roles` row exists for the target role. Most rows are thin — `industries`, `exp_range`,
  `comp_range` and `exclusions` are usually NULL. Fill them before generating queries;
  the queries are only as good as the role.

## Workflow

1. **Load the role.** `SELECT * FROM roles WHERE title LIKE ...`. Confirm titles, locations,
   industries, seniority and exclusions with the user if anything is missing.

2. **Write the X-ray queries** from those fields (templates below). Show them to the user.

3. **Run each query** in Google through Chrome. Collect the `linkedin.com/in/...` result links.
   Do not record anything from the search snippet — snippets are stale and partial.

4. **Open and verify every result.** For each profile link:
   - Open the profile in Chrome and read the rendered page.
   - Confirm name, current title, current company and location against what the page shows.
   - Take the canonical URL from the address bar. That URL is the dedup key.
   - If the URL does not resolve, or the page does not match the result (wrong person,
     redirect, dead profile) → REJECT it. Do not add. Record the reason.

5. **Build and ingest.** From `C:\Users\adity\talent-desk`:

```python
from talent.sourcing import make_candidate, run_batch, format_summary

queries = ['site:linkedin.com/in "business development manager" "Bangalore"']
candidates = [
    make_candidate(
        name="...", linkedin_url="https://www.linkedin.com/in/...",
        query=queries[0],                       # the query that surfaced them
        title="...", company="...", location="...",
        role_name="Business Development Manager",
    ),
    # ... one per profile you actually opened and verified ...
]
print(format_summary(run_batch(
    candidates, role_name="Business Development Manager", queries=queries,
    rejected=[{"url": "...", "reason": "profile did not resolve"}])))
```

`make_candidate` refuses a record with no usable `linkedin.com/in/...` URL. `run_batch`
backs up first, dedups on the normalised URL with `strict_linkedin=True`, fills only empty
fields on an existing row, never overwrites, writes a `sourced` event per person and one
`sourced_batch` event holding the queries and the rejects.

6. **Present the authenticity summary** — `format_summary` prints it: created / enriched /
   duplicate / rejected, plus the backup path and every query run. `python run.py batches`
   replays past batches.

## Hard rules (non-negotiable)
- Open every profile. No snippet-only saves, ever.
- Never pad to a target number. If a query yields 12 real people, add 12 — not 30.
- Only what is on the page goes into a column: name, title, company, location, URL.
  Comp, availability and notice period are judgement calls — put them in `notes`, worded
  as inferences, never in a field that reads as verified.
- A candidate with no resolvable, matching profile is rejected, not added.
- Never promote a `v1_unverified` row. If a sourced profile matches one, the tool logs
  `quarantine_match` and leaves trust alone — bring it to the user.

## X-ray query templates

```
site:linkedin.com/in "<title>" "<location>"
site:linkedin.com/in ("<title>" OR "<synonym>") "<location>" -intern -assistant
site:linkedin.com/in "<title>" "<location>" "<industry>"
```

Run the broad one first, then one per industry and per location from the role row. Record
every query you ran in `queries` — the batch event is the audit trail.

## What this skill does NOT do
- It does not score candidates.
- It does not contact anyone. Drafting lives in `talent/outreach.py`, and sending is a
  human clicking send in LinkedIn — never automated.
