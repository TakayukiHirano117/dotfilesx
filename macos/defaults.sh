#!/usr/bin/env bash
# この Mac で変えているシステム設定を、新しい Mac に defaults で書き戻す。
#
# 公式 UI:
#   ポインタ: システム設定 > アクセシビリティ > ディスプレイ > ポインタ
#     https://support.apple.com/ja-jp/guide/mac-help/unac089/mac
#   キーリピート: システム設定 > キーボード
#     https://support.apple.com/ja-jp/guide/mac-help/mchl0311bdb4/mac
#
# 書き込み手段は macOS の `defaults`（man defaults）。
# キー名（mouseDriverCursorSize など）は Apple の公開ドキュメントには無い。
# 2026-08-23、macOS 15.5 (24F74) のこのマシンで
# `defaults read com.apple.universalaccess` / `defaults read -g` して取った値。
#
#   ./macos/defaults.sh
#   ./macos/defaults.sh --dry-run

set -euo pipefail

DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./macos/defaults.sh [options]

  ポインタのサイズ・色と、キーリピートをこのリポジトリの値で書く。

  --dry-run     実行内容を表示するだけ
  -h, --help    このヘルプ
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
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

# 塗りつぶしは赤寄りのオレンジ、枠線は白、サイズは 2（このマシンの実値）。
run defaults write com.apple.universalaccess mouseDriverCursorSize -float 2
run defaults write com.apple.universalaccess cursorIsCustomized -bool true
run defaults write com.apple.universalaccess cursorFill '{ alpha = 1; blue = 0; green = 0.1491314173; red = 1; }'
run defaults write com.apple.universalaccess cursorOutline '{ alpha = 1; blue = 1; green = 1; red = 1; }'

# KeyRepeat=2 / InitialKeyRepeat=15 はこのマシンの実値。
# ApplePressAndHoldEnabled=0 もこのマシンの実値。長押しのアクセントメニューを出さず、連続入力する。
# 公式 UI は「キーのリピート速度」「リピート入力認識までの時間」。
# https://support.apple.com/ja-jp/guide/mac-help/mchl0311bdb4/mac
run defaults write -g KeyRepeat -int 2
run defaults write -g InitialKeyRepeat -int 15
run defaults write -g ApplePressAndHoldEnabled -bool false

log "macos defaults applied"
log "ポインタとキーリピートは、ログアウトまたは再起動のあと確実に効くことがある"
