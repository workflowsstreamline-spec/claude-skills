---
description: Re-sync the duplicated Satori context docs across all five repos
---

`satori-craft-company.md` and `satori-hr-os-product.md` are duplicated into five
projects. Editing one leaves the other four stale. This command fixes that.

The five locations:

- `C:\Users\adity\satori-site`
- `C:\Users\adity\satori-recruit-v2`
- `C:\Users\adity\satori_render`
- `C:\Users\adity\satori-eor`
- `C:\Users\adity\talent-desk`

Steps:

1. Find every copy of both filenames across those five folders (they may sit at
   the root or one level down).
2. For each of the two documents, show a table: location, last-modified time,
   size, and SHA-256. Use `Get-FileHash`.
3. If all copies of a document are identical, say so and do nothing for it.
4. If they differ, **diff them** and show what actually changed — not just that
   they differ. Identify which copy is newest.
5. **Stop and ask which copy is canonical.** Do not assume newest wins; a stale
   file can be touched by an unrelated edit.
6. Once the user picks, copy the canonical file over the other four, then
   re-hash all five and confirm they now match.

Never overwrite without showing the diff and getting an explicit answer at
step 5.
