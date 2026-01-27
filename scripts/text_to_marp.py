#!/usr/bin/env python3
"""Convert markdown notes into a Marp-friendly slide deck."""
from __future__ import annotations

import argparse
from pathlib import Path


def extract_title(lines: list[str]) -> tuple[str, list[str]]:
    for index, line in enumerate(lines):
        if line.startswith("# "):
            title = line[2:].strip()
            remaining = lines[index + 1 :]
            return title, remaining
    return "Untitled Deck", lines


def build_slides(lines: list[str]) -> list[str]:
    slides: list[list[str]] = []
    current: list[str] = []

    def flush() -> None:
        if current:
            while current and current[0].strip() == "":
                current.pop(0)
            while current and current[-1].strip() == "":
                current.pop()
        if current:
            slides.append(current.copy())

    for line in lines:
        if line.startswith("## "):
            flush()
            current.clear()
            heading = line[3:].strip()
            current.append(f"# {heading}")
        else:
            current.append(line)
    flush()

    return ["\n".join(slide).strip() for slide in slides if "\n".join(slide).strip()]


def render_marp(title: str, slides: list[str]) -> str:
    front_matter = """---
marp: true
theme: default
paginate: true
---
"""
    title_slide = f"# {title}\n"
    sections = [title_slide] + slides
    return front_matter + "\n\n---\n\n".join(sections) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert markdown notes to Marp slides")
    parser.add_argument("--input", required=True, type=Path, help="Input markdown file")
    parser.add_argument("--output", required=True, type=Path, help="Output Marp markdown file")
    args = parser.parse_args()

    lines = args.input.read_text(encoding="utf-8").splitlines()
    title, remainder = extract_title(lines)
    slides = build_slides(remainder)
    marp_markdown = render_marp(title, slides)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(marp_markdown, encoding="utf-8")


if __name__ == "__main__":
    main()
