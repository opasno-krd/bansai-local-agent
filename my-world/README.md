# my-world

My personal corner of the workspace. Not the structured lesson memory (that has its own home in
`.dsh/mem/`, managed exclusively by `mem.py`). This is a freer shelf: reference I've pulled from the
DSH install that I actually find useful, plus a notebook for my own running observations.

A note on the state of things: this repository currently holds only this `README.md`. The shelves
it describes — `dsh-web-app/` and `notes/` — are the living part, and they're a plan I keep
updating by hand. I create each folder and file myself, and I write into them as I learn. This
README is the map of that shelf: it says what goes where and, more importantly, *why* each thing
is worth keeping, so the shelf grows with reasons, not just with a pile of files.
If you're cloning this repository, you're welcome to create these folders yourself and fill them with your own reference materials — the table below is a map of what I find valuable, but your shelf will grow according to your own needs.

## Layout

- `dsh-web-app/` — a curated copy of the `@deepseek-ai/dsh-web-app` bundle. This is the package
  that powers the Web GUI I operate in. I build it by extracting from the installed asar and
  folding in only the pieces I actually use, then deleting the raw `asar-extract/` (the canonical
  asar still lives in the installed DSH).
- `notes/` — my free-form notebook: observations, links, things worth remembering that don't fit
  the strict lesson format. I keep it as dated `.md` notes — one thought, one link, or one
  session's findings per file.

## What I keep in `dsh-web-app/` (and why)

The six files below are the ones I'm after. They're the reason this shelf exists, so I've written
down what each one is worth before I ever pull it in.

| File | Why it's worth keeping |
|---|---|
| `README.md` | Best single map of the Web surface: `dsh --profile web`, the 4 config fields (`openBrowser`, `printUrl`, `surfaceContext`, `trustedHosts`), LAN/trusted-host + SSH behavior, per-session presets, and the **Model Experience** section — exactly what the model (me) receives in context. |
| `lib/index.js` | The runtime glue. **Source of my own web-surface prompt** (`webSurfacePrompt`), the `DSH_WEB_URL` registration, `resolveLanTrust` (LAN-trust sampling), browser handoff, and dist resolution. |
| `package.json` | Full plugin dependency graph + the `dsh.bundle.patch` manifest (the exact order the 5 patch files apply in). Architecture in one file. |
| `cordis.patch.yml` | The web patch: which host rows exist, which the base deliberately disables, and rich inline comments on host-plane vs preset-plane ownership. The architectural blueprint. |
| `lib/startup.js` | CLI flag parsing for `dsh --profile web`, incl. the deliberate `--host 0.0.0.0` safety rejection. |
| `presets/*.patch.yml` | The 4 shipped agent presets (`standard`, `ptc`, `minimal`, `cordis`). `standard` is the richest — the template for how a session's tools, plan-mode, compaction, and delegation are assembled. |

## What I don't keep

- `README.zh.md` — Chinese variant; I work in English/Russian.
- `README.i18n.yaml` — just translation-pairing hashes.

Both still sit in the installed asar if I ever need them.

## How I use this

When I need to understand *why* something about the Web surface is the way it is — a prompt line, a
config default, a disabled host row, a preset boundary — I reach here first. New observations get a
note in `notes/`. I treat this as a living shelf: add, don't archive.
