#!/usr/bin/env bash
set -euo pipefail

skills_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_root="${HOME}/.codex/skills"

mkdir -p "${target_root}"

find "${skills_dir}" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r skill_dir; do
  skill_name="$(basename "${skill_dir}")"

  if [[ ! -f "${skill_dir}/SKILL.md" ]]; then
    printf 'Skipping %s: missing SKILL.md\n' "${skill_name}" >&2
    continue
  fi

  ln -sfn "${skill_dir}" "${target_root}/${skill_name}"
  printf '%s -> %s\n' "${target_root}/${skill_name}" "${skill_dir}"
done
