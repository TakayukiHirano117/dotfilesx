#!/usr/bin/env bash
# install.sh が張った symlink を外し、直近の .bak.YYYYMMDDHHMMSS を戻す。
# Homebrew で入れたアプリ・CLI は消さない。
#
#   ./rollback.sh
#   ./rollback.sh --dry-run
#   ./rollback.sh --home /tmp/dotfilesx-test

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_HOME="${HOME}"
DRY_RUN=0
ONLY=""

usage() {
  cat <<'EOF'
Usage: ./rollback.sh [options]

  install.sh が作った symlink だけを外す。
  退避ファイル (*.bak.YYYYMMDDHHMMSS) があれば最新を元の場所へ戻す。

  --dry-run     実行内容を表示するだけ
  --only NAME   指定した設定だけ戻す
  --home DIR    対象ホームを DIR にする（動作確認用）
  -h, --help    このヘルプ

  --only に使える NAME は install.sh と同じ。
  Homebrew / fisher / vim-plug / chsh は元に戻さない。
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --only)
      shift
      ONLY="$1"
      ;;
    --home)
      shift
      TARGET_HOME="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

log() {
  printf '%s\n' "$*"
}

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    log "DRY-RUN: $*"
    return 0
  fi
  "$@"
}

is_repo_link() {
  local dest="$1"
  if [ ! -L "$dest" ]; then
    return 1
  fi
  local current
  current="$(readlink "$dest")"
  case "$current" in
    "${REPO_DIR}"/*) return 0 ;;
    *) return 1 ;;
  esac
}

latest_bak() {
  local dest="$1"
  local latest=""
  local f
  # install.sh の日付は YYYYMMDDHHMMSS。辞書順の最後が最新。
  for f in "$dest".bak.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]; do
    if [ -e "$f" ]; then
      latest="$f"
    fi
  done
  printf '%s' "$latest"
}

restore_one() {
  local dest="$1"

  if [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
    log "skip (missing): $dest"
    return 0
  fi

  if [ -L "$dest" ]; then
    if ! is_repo_link "$dest"; then
      log "skip (not this repo): $dest -> $(readlink "$dest")"
      return 0
    fi
    run rm "$dest"
    log "unlink: $dest"
  else
    log "skip (not a symlink): $dest"
    return 0
  fi

  local bak
  bak="$(latest_bak "$dest")"
  if [ -n "$bak" ]; then
    run mv "$bak" "$dest"
    log "restore: $bak -> $dest"
  else
    log "no backup for $dest"
  fi
}

should_restore() {
  local name="$1"
  if [ -z "$ONLY" ]; then
    return 0
  fi
  [ "$ONLY" = "$name" ]
}

known_only_name() {
  case "$1" in
    fish|fish-plugins|nvim|nvim-coc|karabiner|linearmouse|gitconfig|git-ignore|gh|cursor-settings|cursor-keybindings|cursor-tasks)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if [ -n "$ONLY" ]; then
  if ! known_only_name "$ONLY"; then
    echo "unknown --only name: $ONLY" >&2
    usage >&2
    exit 1
  fi
fi

log "repo: ${REPO_DIR}"
log "home: ${TARGET_HOME}"
log "dry-run: ${DRY_RUN}  only: ${ONLY:-all}"

if should_restore fish; then
  restore_one "${TARGET_HOME}/.config/fish/config.fish"
fi
if should_restore fish-plugins; then
  restore_one "${TARGET_HOME}/.config/fish/fish_plugins"
fi
if should_restore nvim; then
  restore_one "${TARGET_HOME}/.config/nvim/init.vim"
fi
if should_restore nvim-coc; then
  restore_one "${TARGET_HOME}/.config/nvim/coc-settings.json"
fi
if should_restore karabiner; then
  restore_one "${TARGET_HOME}/.config/karabiner/karabiner.json"
fi
if should_restore linearmouse; then
  restore_one "${TARGET_HOME}/.config/linearmouse/linearmouse.json"
fi
if should_restore gitconfig; then
  restore_one "${TARGET_HOME}/.gitconfig"
fi
if should_restore git-ignore; then
  restore_one "${TARGET_HOME}/.config/git/ignore"
fi
if should_restore gh; then
  restore_one "${TARGET_HOME}/.config/gh/config.yml"
fi
if should_restore cursor-settings; then
  restore_one "${TARGET_HOME}/Library/Application Support/Cursor/User/settings.json"
fi
if should_restore cursor-keybindings; then
  restore_one "${TARGET_HOME}/Library/Application Support/Cursor/User/keybindings.json"
fi
if should_restore cursor-tasks; then
  restore_one "${TARGET_HOME}/Library/Application Support/Cursor/User/tasks.json"
fi

log "done"
