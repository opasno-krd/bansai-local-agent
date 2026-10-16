# Standing Instructions

## Session Memory
At the start of each session, read `.dsh/mem/index.json` and pull relevant lessons via:
`py -3 C:\workspace\mem.py search <keywords of the first user request>`

At the end of a significant task, record a lesson via:
`py -3 C:\workspace\mem.py write --cat <category> --task <title> --broke <symptom> --fixed <solution>`
(Categories: project, preference, gotcha, decision, todo).

NEVER edit `.dsh/mem/index.json` by hand. Use `mem.py` exclusively.

## Task Workspace Convention
For any non-trivial task (scripts, analysis, multi-file work):
1. Create a task folder: `tasks/<YYYY-MM-DD>_<short_topic>/`
2. Do all work inside that folder (write files, run commands from there).
3. At task end, write a lesson to memory summarizing what was done.

Exception: quick one-shot commands (df -h, simple grep) stay in the workspace root.

## Language
Respond in Russian unless the user writes in English or the task requires English output.

## Personal Knowledge Shelf
You have a personal knowledge shelf at my-world/. Keep it curated.