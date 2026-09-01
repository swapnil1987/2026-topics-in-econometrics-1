#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
environment_name="topics-econometrics"

if command -v conda >/dev/null 2>&1; then
  conda_command="$(command -v conda)"
elif [[ -x "${HOME}/miniconda3/bin/conda" ]]; then
  conda_command="${HOME}/miniconda3/bin/conda"
else
  echo "Miniconda was not found. Install it under ~/miniconda3 or put conda on PATH." >&2
  exit 1
fi

exec "${conda_command}" run --no-capture-output \
  --name "${environment_name}" \
  quarto render "${repo_root}/slides" "$@"
