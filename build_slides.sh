#!/usr/bin/env bash

set -euox pipefail

INPUT_MD_PATH="${1}"
OUTPUT_DIR="${2:-dist}"
OUTPUT_BASENAME="$(basename "${INPUT_MD_PATH}" .md)"

[[ -d "${OUTPUT_DIR}" ]] || mkdir -p "${OUTPUT_DIR}"

marp-cli "${INPUT_MD_PATH}" --html -o "${OUTPUT_DIR}/${OUTPUT_BASENAME}.html"
marp-cli "${INPUT_MD_PATH}" --pdf -o "${OUTPUT_DIR}/${OUTPUT_BASENAME}.pdf"
marp-cli "${INPUT_MD_PATH}" --pptx -o "${OUTPUT_DIR}/${OUTPUT_BASENAME}.pptx"
