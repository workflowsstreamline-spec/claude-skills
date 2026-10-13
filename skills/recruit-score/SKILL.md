---
name: recruit-score
description: Score sourced candidates against a role using the STAR framework (Skills, Trajectory, Availability, Role-fit) and persist the score with a confidence value. Use when the user asks to score, qualify, grade, or assess candidates for a role.
---

# /recruit score — STAR scoring with honest confidence

## PARKED — do not run as written (2026-08-13)

This skill drives `satori-recruit-v2/engine` against Supabase, and that project is gone —
the host no longer resolves in DNS. `save_score` cannot run, and Talent Desk has no
`scores` table to write to instead.

Sourcing has moved to Talent Desk (`C:\Users\adity\talent-desk`) — see `recruit-source`.
To bring scoring across, Talent Desk needs an append-only `scores` table plus a
`talent/score.py` mirroring the confidence rule below. Until then, tell the user scoring
is unavailable rather than improvising a grade — an ungrounded score is the v1 failure
in a different costume.

The framework below is kept because it is still the right one.

## Core principle
Score only what you can see. The four STAR subscores must be grounded in the candidate's
VERIFIED data (what was read off the real profile). Do not inflate subscores to compensate for
missing data — the engine derives a confidence from the verified-field ratio and will flag a
thin profile as `needs_review`. A confident-looking grade on guessed data is exactly the v1
failure we are avoiding.

## Prerequisites
- `engine/.env.local` points at the active Supabase project and the data API is live.
- The candidates already exist (added by `/recruit source`) and their source batch is approved.

## STAR framework (each 0..100)
- **Skills** — relevant B2B SaaS / HR-tech sales skills evident from the verified history.
- **Trajectory** — career progression and tenure pattern (within the ICP's seniority band?).
- **Availability** — signals of openness to move. NOTE: availability is almost always an
  `inferred` field, so weight it cautiously and let confidence reflect that.
- **Role-fit** — match to this specific role's ICP (titles, industries, location).

Overall defaults to the mean of the four. Grades: A+ >=85, A >=75, B >=60, C >=40, D <40.

## Workflow
1. Pick the role and the candidates to score (e.g. an approved batch, or `current_stage =
   'sourced'`).
2. For each candidate, read their stored verified fields and artifact. Assess the four STAR
   subscores from that evidence only.
3. Persist via the engine:
   ```python
   # run from satori-recruit-v2/engine
   from score import save_score, print_result
   print_result(save_score("<candidate-id>", {
       "skills": 70, "trajectory": 65, "availability": 50, "role_fit": 72,
   }))
   ```
4. The engine computes `confidence` from the candidate's provenance (share of core career
   fields that are `verified`) and sets `needs_review` when confidence is below threshold.
   Scores are appended (history preserved), never overwritten, and a `scored` event is written.
5. Present the results, separating clean grades from `needs_review` candidates. The
   needs_review set should be re-verified (open the profile again) before being trusted.

## Hard rules
- Never raise a subscore to offset missing data. Missing data lowers confidence, not the grade.
- Availability and comp are inferred — say so when you cite them.
- Re-scoring appends a new row; it does not edit the old one. The latest by `created_at` wins.

## What this skill does NOT do
- It does not source candidates (`/recruit source`).
- It does not move anyone to outreach — that is a separate, human-gated step.
