---
name: study-notes
description: Use when the user studies a paper, article, book chapter, or similar source interactively.
---

# Study Notes

- Be succinct; answer only the current question; expand only when asked.
- At start, ensure the user provides the source title and/or link.
- Look up/open the source when possible; ground answers in that source.
- First, print the source structure/TOC in a `tree`-like format.
- Treat `Note: ...` messages as notes: do not answer them, just remember them.
- Preserve note intent, fix typos, and satisfy embedded instructions like “add detail later.”

- At summary time, include all substantive Q&A takeaways and all notes.
- Before summarizing, reread the session for missed questions, notes, TOC/structure, dates, and
embedded instructions.
- If user wants Google Docs bullets, output one item per line, no dashes, no blank lines.
- Use sub-bullets to organize the structure
- If user asks for clipboard on macOS, use `pbcopy`; escalate if sandbox blocks it.
- For the notes provided by the user, only correct spelling, typos and minor mistakes. Don't make
  large edits
- When presenting the summarized notes, match the tone in the user's notes.
