#!/usr/bin/env bash

set -euox pipefail
cd "$(git rev-parse --show-toplevel)"

# Markdown
npx -y prettier --write './**/*.md'

# GitHub Actions
zizmor --fix=safe .github/workflows
git ls-files -z -- '.github/workflows/*.yml' | xargs -0 -t actionlint
git ls-files -z -- '.github/workflows/*.yml' | xargs -0 -t yamllint -d '{"extends": "relaxed", "rules": {"line-length": "disable"}}'
checkov --framework=all --output=github_failed_only --directory=.
