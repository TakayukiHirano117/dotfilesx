#!/usr/bin/env bash
# iTerm2 に Atom One Dark の Dynamic Profile を置く。
# 色は iterm/OneDark.itermcolors（atom/one-dark-syntax の colors.less）。
# https://github.com/atom/one-dark-syntax/blob/master/styles/colors.less
# Dynamic Profiles は実行中でも即読み込まれる。
# https://iterm2.com/documentation-dynamic-profiles.html
#
#   ./iterm/apply.sh
#   ./iterm/apply.sh --dry-run

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PRESET="${REPO_DIR}/iterm/OneDark.dynamic.json"
DEST="${HOME}/Library/Application Support/iTerm2/DynamicProfiles/OneDark.json"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./iterm/apply.sh [options]

  Dynamic Profile「One Dark」を置き、今のセッションとデフォルトに切り替える。

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

if [ ! -f "$PRESET" ]; then
  echo "missing preset: $PRESET" >&2
  exit 1
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "DRY-RUN: cp $PRESET -> $DEST"
  echo "DRY-RUN: switch current iTerm session to One Dark"
  exit 0
fi

mkdir -p "$(dirname "$DEST")"
cp "$PRESET" "$DEST"
echo "wrote $DEST"

# デフォルトプロファイルを One Dark にする。起動中だと終了時に戻ることがある。
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "2F973E00-AE6C-4E6B-9E64-D227C0A2D246"

# 今開いているセッションを切り替える。
# https://iterm2.com/documentation-scripting.html
osascript <<'APPLESCRIPT' || true
tell application "iTerm"
  repeat with w in windows
    repeat with t in tabs of w
      repeat with s in sessions of t
        try
          set profile name of s to "One Dark"
        end try
      end repeat
    end repeat
  end repeat
end tell
APPLESCRIPT

echo "switched sessions to One Dark"
