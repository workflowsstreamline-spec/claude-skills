---
name: inspo-bank
description: Use when the user shares Instagram reels, videos, or links of UI effects, website ideas, or video techniques and asks if they are doable, or asks "what inspiration have I saved" / "which project could use X". Logs each idea to ideas.md and matches it to an ongoing project.
---

# Inspo bank

The user collects reels of UI tricks and video techniques. Keep them here so they
can be pulled into a project later.

## When the user shares new links
1. Read each one. Instagram blocks video for logged-out viewers, but the caption
   is in `meta[property="og:title"]` / `og:description` (built-in browser +
   javascript_tool). Screenshot the page for the creator's other posts if the
   caption is thin. Say plainly what was judged from caption only.
2. Give a verdict per item: doable or not, effort, what it needs from the user.
3. Append it to `ideas.md` (same format as the existing rows) and name the best
   project fit from the user's ongoing projects (check MEMORY.md for the list).
4. Run the skills sync (see global CLAUDE.md).

## When the user asks what is saved or what fits a project
Read `ideas.md`, filter by project or type, and suggest. Do not build anything
until the user picks one.
