---
description: Add a blog post to aditya-portfolio (markdown + posts.json index)
argument-hint: [post title]
---

Add a new blog post to `C:\Users\adity\aditya-portfolio`.

Title: **$ARGUMENTS**

**The gotcha this command exists for:** a post needs *two* changes. The markdown
file alone is invisible — it must also be registered in `posts/posts.json`.
Miss the second and the post silently never appears.

Steps:

1. Read `posts/posts.json` to learn the exact entry shape. Match it — do not
   invent fields.
2. Read the existing post `posts/automate-your-own-busywork-first.md` to match
   the front-matter format and the voice: first person, plain, concrete.
3. Derive a URL-safe slug from the title (lowercase, hyphens, no punctuation).
   Confirm no existing post already uses it.
4. Write `posts/<slug>.md`. If the user gave only a title, draft an outline with
   real section headings and a first paragraph — then stop and let them write
   the body rather than inventing opinions and claims in their name.
5. Add the entry to `posts/posts.json` in the correct position (newest first
   unless the file shows otherwise), with today's date in the format already
   used there.
6. Verify: serve the site and confirm the post appears on `blog.html` and opens
   correctly at `post.html?<slug>`.

```bash
python -m http.server 4602 --directory C:/Users/adity/aditya-portfolio
```

This is a public professional site. Do not publish claims about the user's
experience or results that they have not stated.
