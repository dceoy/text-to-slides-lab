#!/usr/bin/env bash

set -euox pipefail

if [[ "${#}" -ne 1 ]]; then
  echo "Usage: ${0} <input-markdown>" >&2
  exit 1
fi

SCRIPT_DIR_PATH="$(dirname "${0}")"
INPUT_MD_PATH="${1}"
THEMES_DIR_PATH="${SCRIPT_DIR_PATH}/marp-community-themes"
OUTPUT_DIR_PATH="${SCRIPT_DIR_PATH}/dist"
OUTPUT_BASENAME="$(basename "${INPUT_MD_PATH}" .md)"

if [[ -d "${THEMES_DIR_PATH}" ]]; then
  cd "${THEMES_DIR_PATH}" && git pull && cd -
else
  git clone https://github.com/rnd195/marp-community-themes.git "${THEMES_DIR_PATH}"
fi

[[ -d "${OUTPUT_DIR_PATH}" ]] || mkdir -p "${OUTPUT_DIR_PATH}"

for x in 'html' 'pdf' 'pptx'; do
  marp \
    --theme-set "${THEMES_DIR_PATH}"/themes/*.css \
    "--${x}" \
    --output "${OUTPUT_DIR_PATH}/${OUTPUT_BASENAME}.${x}" \
    "${INPUT_MD_PATH}"
done
