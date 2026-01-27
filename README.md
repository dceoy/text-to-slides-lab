# text-to-slides-lab

Text-to-slides workflow using [Marp](https://marp.app/) to turn markdown notes into slide decks.

## Workflow

1. Convert a markdown note into a Marp deck.
2. Render the Marp deck into HTML/PDF/PPTX.

### Build slides

```bash
npm install
npm run slides:build
```

The default command converts `input/20260118_github_actions_and_copilot.md` into:

- `dist/20260118_github_actions_and_copilot.marp.md`
- `dist/20260118_github_actions_and_copilot.html`
- `dist/20260118_github_actions_and_copilot.pdf`
- `dist/20260118_github_actions_and_copilot.pptx`

You can pass a different input file and output directory:

```bash
./scripts/build_slides.sh input/your_notes.md dist
```

## How it works

- `scripts/text_to_marp.py` extracts the document title, splits the note into slides at `##` headings, and writes a Marp-compatible markdown file with front matter.
- `scripts/build_slides.sh` runs the converter and then uses the Marp CLI to render HTML/PDF/PPTX outputs.

See [Marp documentation](https://marp.app/) for themes and styling options.
