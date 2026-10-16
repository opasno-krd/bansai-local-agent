#!/usr/bin/env python3
"""mem.py — lightweight lesson memory (Python 3, stdlib only).

Commands:
    mem.py write --cat <cat> --task <title> --broke <text> --fixed <text>
        Creates .dsh/mem/lessons/<date>_<slug>.md and appends
        {id, category, date, title, path} to .dsh/mem/index.json["lessons"].
    mem.py read <id>
        Prints the lesson file referenced by <id> in the index.
    mem.py search <substring>
        Case-insensitive substring search over lesson .md files
        and over the fields (id, category, date, title, path) of the index.

Storage lives relative to the directory this script is in:
    .dsh/mem/index.json
    .dsh/mem/lessons/<date>_<slug>.md
"""

import argparse
import json
import os
import re
import sys
from datetime import date, datetime

HERE = os.path.dirname(os.path.abspath(__file__))
BASE = os.path.join(HERE, ".dsh", "mem")
LESSONS_DIR = os.path.join(BASE, "lessons")
INDEX_PATH = os.path.join(BASE, "index.json")
INDEX_FIELDS = ("id", "category", "date", "title", "path")
MAX_SLUG = 60


def _slugify(text: str) -> str:
    """Lowercase, keep latin/cyrillic letters + digits, collapse to underscores."""
    s = text.lower()
    s = re.sub(r"[^a-zа-яё0-9]+", "_", s)
    s = re.sub(r"_+", "_", s).strip("_")
    return s[:MAX_SLUG] or "lesson"


def _rel(p: str) -> str:
    return os.path.relpath(p, HERE).replace("\\", "/")


def _load_index() -> dict:
    data = {}
    if os.path.isfile(INDEX_PATH):
        try:
            with open(INDEX_PATH, "r", encoding="utf-8") as f:
                data = json.load(f)
        except (json.JSONDecodeError, OSError) as exc:
            print(f"error: cannot read index {INDEX_PATH}: {exc}", file=sys.stderr)
            sys.exit(1)
    if not isinstance(data, dict):
        data = {}
    if not isinstance(data.get("lessons"), list):
        data["lessons"] = []
    return data


def _save_index(data: dict) -> None:
    os.makedirs(BASE, exist_ok=True)
    data["updated"] = datetime.now().isoformat(timespec="seconds")
    tmp = INDEX_PATH + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")
    os.replace(tmp, INDEX_PATH)


def cmd_write(args: argparse.Namespace) -> int:
    if not (args.cat and args.task and args.broke and args.fixed):
        print("error: --cat, --task, --broke and --fixed are all required", file=sys.stderr)
        return 2

    today = date.today().isoformat()
    slug = _slugify(args.task)
    fname = f"{today}_{slug}.md"
    path = os.path.join(LESSONS_DIR, fname)
    n = 1
    while os.path.exists(path):  # same-day duplicate: append a counter
        n += 1
        path = os.path.join(LESSONS_DIR, f"{today}_{slug}_{n}.md")

    rel = _rel(path)
    lesson_id = os.path.splitext(os.path.basename(path))[0]

    content = (
        f"# {args.task}\n\n"
        f"- **id**: {lesson_id}\n"
        f"- **category**: {args.cat}\n"
        f"- **date**: {today}\n"
        f"- **path**: {rel}\n\n"
        f"## What broke\n\n{args.broke.strip()}\n\n"
        f"## Fixed\n\n{args.fixed.strip()}\n"
    )
    os.makedirs(LESSONS_DIR, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

    data = _load_index()
    data["lessons"].append(
        {
            "id": lesson_id,
            "category": args.cat,
            "date": today,
            "title": args.task,
            "path": rel,
        }
    )
    _save_index(data)

    print(f"lesson written: {rel}")
    print(f"id={lesson_id}  category={args.cat}")
    return 0


def cmd_read(args: argparse.Namespace) -> int:
    data = _load_index()
    lesson = next((l for l in data["lessons"] if l.get("id") == args.id), None)
    if lesson is None:
        print(f"error: no lesson with id {args.id!r} in index", file=sys.stderr)
        return 1
    p = os.path.join(HERE, lesson["path"])
    if not os.path.isfile(p):
        print(f"error: lesson file missing: {lesson['path']}", file=sys.stderr)
        return 1
    with open(p, "r", encoding="utf-8") as f:
        sys.stdout.write(f.read())
    return 0


def cmd_search(args: argparse.Namespace) -> int:
    q = args.query.lower()
    hits = 0

    # 1) lesson .md files
    for root, _dirs, files in os.walk(LESSONS_DIR):
        for name in sorted(files):
            if not name.endswith(".md"):
                continue
            p = os.path.join(root, name)
            try:
                with open(p, "r", encoding="utf-8") as f:
                    lines = f.readlines()
            except OSError:
                continue
            for i, line in enumerate(lines, 1):
                if q in line.lower():
                    hits += 1
                    print(f"{_rel(p)}:{i}: {line.rstrip()}")

    # 2) index fields
    data = _load_index()
    for lesson in data["lessons"]:
        for field in INDEX_FIELDS:
            value = str(lesson.get(field, ""))
            if q in value.lower():
                hits += 1
                print(f"index[{field}]={value!r}  (id={lesson.get('id')!r})")

    if hits == 0:
        print(f"no matches for {args.query!r}")
        return 1
    print(f"\n{hits} match(es) for {args.query!r}")
    return 0


def main(argv=None) -> int:
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8")

    parser = argparse.ArgumentParser(
        prog="mem.py",
        description="lesson memory: write / read / search (stdlib only)",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    w = sub.add_parser("write", help="save a lesson")
    w.add_argument("--cat", required=True, help="category")
    w.add_argument("--task", required=True, help="title of the lesson")
    w.add_argument("--broke", required=True, help="what broke / the symptom")
    w.add_argument("--fixed", required=True, help="how it was fixed")
    w.set_defaults(func=cmd_write)

    r = sub.add_parser("read", help="print a lesson by id")
    r.add_argument("id", help="lesson id from the index")
    r.set_defaults(func=cmd_read)

    s = sub.add_parser("search", help="case-insensitive substring search")
    s.add_argument("query", help="substring (case-insensitive)")
    s.set_defaults(func=cmd_search)

    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
