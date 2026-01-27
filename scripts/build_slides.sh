#!/usr/bin/env bash
set -euo pipefail

INPUT_PATH=${1:-input/20260118_github_actions_and_copilot.md}
OUTPUT_DIR=${2:-dist}

BASENAME=$(basename "$INPUT_PATH" .md)
MARP_MD="$OUTPUT_DIR/${BASENAME}.marp.md"

mkdir -p "$OUTPUT_DIR"

python3 scripts/text_to_marp.py --input "$INPUT_PATH" --output "$MARP_MD"

npx --yes @marp-team/marp-cli@latest "$MARP_MD" --html -o "$OUTPUT_DIR/${BASENAME}.html"
npx --yes @marp-team/marp-cli@latest "$MARP_MD" --pdf -o "$OUTPUT_DIR/${BASENAME}.pdf"
npx --yes @marp-team/marp-cli@latest "$MARP_MD" --pptx -o "$OUTPUT_DIR/${BASENAME}.pptx"

printf "Generated slides in %s\n" "$OUTPUT_DIR"
