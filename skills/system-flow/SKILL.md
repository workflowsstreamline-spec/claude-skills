---
name: system-flow
description: Turn a complicated system, codebase, or workflow into a simple hand-drawn diagram that shows the tangled "before" and a clean numbered "after" flow. Use when the user says "draw how this works", "explain this system", "map this flow", "onboarding diagram", "system-flow", or wants a new teammate to understand a big build at a glance.
---

# system-flow

Makes one self-contained HTML page with an inline SVG in a hand-drawn whiteboard
style. Goal: someone new understands the system in under a minute.

## Steps

1. **Get the parts.** From the user's description (or by reading the code or
   docs they point at), list the components: inputs, services, queues, agents,
   stores, outputs. Aim for 4 to 8 boxes. If there are more, group them. Use one
   or two plain words per box, lowercase (`input`, `auth`, `queue`, `agent`,
   `store`, `notify`).
2. **Find the main path.** Decide the one route a typical request takes from
   start to finish. Number it 01, 02, 03 in order. Side paths (retries, errors,
   admin) go in a short note under the diagram, not in the main flow.
3. **Draw two panels** in one SVG, stacked:
   - **Before:** the boxes scattered, with thin grey lines between every pair
     that talks to each other. It should look tangled on purpose.
   - **After:** the same boxes in a snake layout (3 per row, row 2 runs right to
     left), joined by orange arrows, with the step number in orange above each
     box.
4. **Add a one-line caption per step** under the After panel: what happens at
   that box, in plain words, no jargon.
5. **Add a "Start here" line** for new teammates: which box to read first in the
   code, and the file or folder it lives in (only if known; never invent paths).
6. **Write and open it.** Save to the session scratchpad as `system-flow.html`,
   then publish with the Artifact tool (load `artifact-design` first).

## Style

- Boxes: white fill, 2px dark stroke, slightly rounded, tiny random rotation
  (-1 to 1 degree) so they look hand-placed.
- Font: a handwriting face via Google Fonts (`Caveat` or `Patrick Hand`) with a
  sans-serif fallback.
- Colors: near-black strokes, grey tangle lines, one orange (`#e8873a`) for the
  main flow. Nothing else.
- Must work in light and dark: set an explicit background on `body` and swap the
  stroke and text colors with `prefers-color-scheme`.
- Phone-width friendly: SVG uses a `viewBox` and `width: 100%`.

## Rules

- Never invent components the user did not mention or the code does not show.
  If unsure whether two parts talk, ask or leave the line out.
- Keep the diagram honest: the tangle must reflect real connections.
- One page, one system. For a second system, make a second page.
