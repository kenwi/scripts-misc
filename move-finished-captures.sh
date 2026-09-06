#!/usr/bin/env bash
# Detect finished recordings in a staging directory and move them to an
# archive directory. A file is treated as live if its size increases
# during the observation window.
#
#   move-finished-captures.sh [--detect-live|--detect-finished] [--interval SECONDS]
set -euo pipefail

# Edit these paths for your setup
SRC_DIR="/path/to/staging"
DST_DIR="/path/to/archive"
INTERVAL=30
DETECT_LIVE=0
DETECT_FINISHED=0

# Locale and numeric timestamp format (Norwegian: DD.MM.YYYY HH.MM.SS).
OUTPUT_LOCALE="nb_NO.UTF-8"
OUTPUT_TIMESTAMP_FORMAT="%d.%m.%Y %H.%M.%S"

timestamp() {
  # Prefer locale-aware date; fall back if the locale is not installed.
  LC_ALL="$OUTPUT_LOCALE" date "+$OUTPUT_TIMESTAMP_FORMAT" 2>/dev/null \
    || date '+%Y-%m-%d %H:%M:%S'
}

log() {
  printf '[%s] %s\n' "$(timestamp)" "$*"
}

usage() {
  cat <<'EOF'
Usage: move-finished-captures.sh [OPTIONS]

Sample file sizes in SRC_DIR, wait, then sample again.
Files whose size did not increase are considered finished and moved to
DST_DIR. Files that grew are treated as live recordings.

Options:
  --detect-live          Only print live (growing) files; do not move anything
  --detect-finished      Only print finished (not growing) files; do not move anything
  --interval SECONDS     Observation window between size samples (default: 30)
  -h, --help             Show this help

Status log timestamps use OUTPUT_LOCALE / OUTPUT_TIMESTAMP_FORMAT from the
script configuration. Detect modes still print bare paths for piping.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --detect-live)
      DETECT_LIVE=1
      shift
      ;;
    --detect-finished)
      DETECT_FINISHED=1
      shift
      ;;
    --interval)
      if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ || "$2" -eq 0 ]]; then
        echo "Error: --interval requires a positive integer (seconds)" >&2
        exit 1
      fi
      INTERVAL="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$DETECT_LIVE" -eq 1 && "$DETECT_FINISHED" -eq 1 ]]; then
  echo "Error: --detect-live and --detect-finished cannot be used together" >&2
  exit 1
fi

DETECT_ONLY=0
if [[ "$DETECT_LIVE" -eq 1 || "$DETECT_FINISHED" -eq 1 ]]; then
  DETECT_ONLY=1
fi

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Error: source directory does not exist: $SRC_DIR" >&2
  exit 1
fi

if [[ "$DETECT_ONLY" -eq 0 && ! -d "$DST_DIR" ]]; then
  echo "Error: destination directory does not exist: $DST_DIR" >&2
  exit 1
fi

declare -A SIZES_BEFORE=()
declare -a FILES=()

shopt -s nullglob
for path in "$SRC_DIR"/*; do
  [[ -f "$path" ]] || continue
  [[ ! -L "$path" ]] || continue
  name="$(basename -- "$path")"
  # Skip hidden files
  [[ "$name" != .* ]] || continue
  size="$(stat -c '%s' -- "$path")"
  SIZES_BEFORE["$name"]="$size"
  FILES+=("$name")
done

if [[ ${#FILES[@]} -eq 0 ]]; then
  if [[ "$DETECT_ONLY" -eq 0 ]]; then
    log "No files found in $SRC_DIR"
  fi
  exit 0
fi

if [[ "$DETECT_ONLY" -eq 0 ]]; then
  log "Observing ${#FILES[@]} file(s) in $SRC_DIR for ${INTERVAL}s..."
fi

sleep "$INTERVAL"

live=0
finished=0
moved=0
skipped=0

for name in "${FILES[@]}"; do
  path="$SRC_DIR/$name"
  if [[ ! -f "$path" ]]; then
    if [[ "$DETECT_ONLY" -eq 0 ]]; then
      log "Skipped (disappeared): $name"
    fi
    ((skipped++)) || true
    continue
  fi

  size_after="$(stat -c '%s' -- "$path")"
  size_before="${SIZES_BEFORE[$name]}"

  if (( size_after > size_before )); then
    ((live++)) || true
    if [[ "$DETECT_LIVE" -eq 1 ]]; then
      printf '%s\n' "$path"
    elif [[ "$DETECT_ONLY" -eq 0 ]]; then
      log "Live: $name (${size_before} -> ${size_after})"
    fi
    continue
  fi

  ((finished++)) || true

  if [[ "$DETECT_FINISHED" -eq 1 ]]; then
    printf '%s\n' "$path"
    continue
  fi

  if [[ "$DETECT_LIVE" -eq 1 ]]; then
    continue
  fi

  dest="$DST_DIR/$name"
  if [[ -e "$dest" ]]; then
    log "Skipped (destination exists): $name" >&2
    ((skipped++)) || true
    continue
  fi

  log "Moving: $name (${size_after} bytes)"
  mv -- "$path" "$dest"
  ((moved++)) || true
done

if [[ "$DETECT_ONLY" -eq 0 ]]; then
  log "Done. live=$live finished=$finished moved=$moved skipped=$skipped"
fi
