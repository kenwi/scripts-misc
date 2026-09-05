#!/usr/bin/env bash
# Delete files in TARGET_DIR whose names do not match any KEEP_PATTERNS entry.
# Patterns support shell wildcards (*, ?, [...]).
# Use --pretend for a dry run (nothing is deleted).

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration - edit these
# ---------------------------------------------------------------------------

TARGET_DIR="/path/to/directory"

KEEP_PATTERNS=(
  "README.md"
  "*.txt"
  "config.*"
  ".gitignore"
)

# ---------------------------------------------------------------------------

pretend=0

usage() {
  cat <<'EOF'
Usage: cleanup-keep-list.sh [--pretend]

Deletes files in TARGET_DIR that do not match any name/pattern in KEEP_PATTERNS.
Only regular files directly in TARGET_DIR are considered (not subdirectories).

  --pretend, -n, --dry-run   Show what would be deleted, without deleting
  -h, --help                 Show this help
EOF
}

for arg in "$@"; do
  case "$arg" in
    --pretend|-n|--dry-run)
      pretend=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: TARGET_DIR is not a directory: $TARGET_DIR" >&2
  exit 1
fi

if [[ ${#KEEP_PATTERNS[@]} -eq 0 ]]; then
  echo "Error: KEEP_PATTERNS is empty; refusing to run (would delete everything)." >&2
  exit 1
fi

matches_keep_list() {
  local name="$1"
  local pattern
  for pattern in "${KEEP_PATTERNS[@]}"; do
    # Unquoted pattern enables shell wildcard matching.
    # shellcheck disable=SC2254
    case "$name" in
      $pattern) return 0 ;;
    esac
  done
  return 1
}

deleted=0
kept=0

shopt -s nullglob dotglob

for path in "$TARGET_DIR"/*; do
  [[ -e "$path" || -L "$path" ]] || continue
  [[ -f "$path" || -L "$path" ]] || continue
  # Skip directories even if somehow matched; only delete files/symlinks-to-files intent:
  # We only process non-directory entries.
  [[ ! -d "$path" ]] || continue

  name="$(basename -- "$path")"

  if matches_keep_list "$name"; then
    ((kept++)) || true
    continue
  fi

  if [[ "$pretend" -eq 1 ]]; then
    echo "Would delete: $path"
  else
    echo "Deleting: $path"
    rm -f -- "$path"
  fi
  ((deleted++)) || true
done

if [[ "$pretend" -eq 1 ]]; then
  echo "Pretend mode: would delete $deleted file(s), keep $kept file(s)."
else
  echo "Deleted $deleted file(s), kept $kept file(s)."
fi
