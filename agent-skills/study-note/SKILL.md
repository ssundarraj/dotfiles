---
name: study-notes
description: Use when the user studies a paper, article, book chapter, or similar source interactively.
---

# Study Notes

- Be succinct; answer only the current question; expand only when asked.
- At start, ensure the user provides the source title and/or link.
- Create a Markdown notes file on disk for the session before substantive study begins.
- If the user does not specify a path, create it in the current working directory using a simple
  slug from the source title, such as `study-notes-<source-slug>.md`.
- Treat the notes file as the source of truth for the session's distilled notes, not a turn-by-turn transcript.
- Look up/open the source when possible; ground answers in that source.
- First, print the source structure/TOC in a `tree`-like format. Do not write this to the
  Markdown file.
- Treat `Note: ...` messages as notes.
- If the user writes a statement with no question or request, treat it as a note even without the
  `Note:` prefix.
- For notes, do not answer; append them to the notes file.
- Preserve the user's note wording as much as possible.
- For user-provided notes, only fix glaring typos and grammar issues; do not add punctuation to
  bullets or polish wording.
- Do not paraphrase, restructure, or add interpretation unless the user asks.
- When answering a question, answer in chat only; do not append every turn to the notes file.
- Keep track of the current subtopic during the conversation.
- When the user moves to a new subtopic or asks you to write/summarize notes, append only a very
  succinct summary of the completed subtopic to the notes file.
- When the user asks for a summary, answer in chat and append only a very succinct summary to the
  notes file.
