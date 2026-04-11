# text-to-slides-lab

Minimal text-to-slides workflow built around [Marp](https://marp.app/). The repository provides a small shell wrapper that turns a Markdown slide source into `HTML`, `PDF`, and `PPTX` outputs.

## What It Does

- Accepts a single Markdown file as input
- Clones or updates the `marp-community-themes` repository automatically
- Renders the input deck with the available community themes
- Writes generated slides to `dist/`

## Requirements

- `bash`
- `git`
- `realpath`
- `xargs`
- `marp` CLI on `PATH`

One common way to install the Marp CLI is:

```bash
npm install --global @marp-team/marp-cli
```

## Usage

Run the build script with a Markdown slide source:

```bash
./build_slides.sh path/to/deck.md
```

The script creates these files in `dist/` using the input filename as the basename:

- `dist/deck.html`
- `dist/deck.pdf`
- `dist/deck.pptx`

Example:

```bash
./build_slides.sh notes/product-review.md
```

## Notes

- The first run clones `https://github.com/rnd195/marp-community-themes.git` into `marp-community-themes/`.
- Later runs call `git pull` in that directory before rendering, so network access is currently expected.
- The script does not create slide content for you; your input file should already be valid Marp-compatible Markdown.

## Repository Layout

```text
.
|-- build_slides.sh
|-- README.md
|-- dist/
`-- marp-community-themes/
```
