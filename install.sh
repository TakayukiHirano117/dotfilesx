#!/usr/bin/env bash
# 新しい Mac で:
#   git clone <this-repo>
#   cd dotfilesx
#   ./install.sh
#
# 今の PC を壊さずに確認する:
#   ./install.sh --dry-run --skip-brew --home /tmp/dotfilesx-test
#   ./install.sh --skip-brew --home /tmp/dotfilesx-test

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_HOME="${HOME}"
DRY_RUN=0
SKIP_BREW=0
SKIP_EXTRAS=0
ONLY=""

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

  --dry-run     実行内容を表示するだけ（ファイルは変更しない）
  --skip-brew   Homebrew / Brewfile をスキップ（symlink 確認用）
  --skip-extras fisher / vim-plug / シェル変更案内をスキップ
  --only NAME   指定した設定だけリンクする（brew / extras は自動スキップ）
  --home DIR    リンク先のホームを DIR にする（動作確認用）
  -h, --help    このヘルプ

  --only に使える NAME:
    fish  fish-plugins  nvim  nvim-coc  karabiner  linearmouse
    gitconfig  git-ignore  gh
    cursor-settings  cursor-keybindings  cursor-tasks
    macos  iterm
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --skip-brew) SKIP_BREW=1 ;;
    --skip-extras) SKIP_EXTRAS=1 ;;
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

ensure_dir() {
  local dir="$1"
  if [ "$DRY_RUN" -eq 1 ]; then
    log "DRY-RUN: mkdir -p $dir"
    return 0
  fi
  mkdir -p "$dir"
}

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    echo "missing source: $src" >&2
    exit 1
  fi

  ensure_dir "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      log "skip (already linked): $dest"
      return 0
    fi
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local bak="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    run mv "$dest" "$bak"
    log "backup: $dest -> $bak"
  fi

  run ln -sfn "$src" "$dest"
  log "link: $dest -> $src"
}

SUDO_KEEPALIVE_PID=""

# docker-desktop / karabiner-elements は cask の中で /usr/bin/sudo を呼ぶ。
# brew 自体は root で動かせない（Homebrew/brew.sh の check-run-command-as-root）ので、
# 親プロセスで先に認証をキャッシュして内部の sudo を通す。
ensure_sudo() {
  if [ "$DRY_RUN" -eq 1 ]; then
    log "DRY-RUN: sudo -v"
    return 0
  fi

  if sudo -n true 2>/dev/null; then
    log "sudo already authenticated"
  elif [ -t 0 ]; then
    sudo -v
  else
    echo "対話ターミナルではないため sudo 認証ができません。" >&2
    echo "Terminal.app / iTerm から ./install.sh を実行してください。" >&2
    exit 1
  fi

  # bundle は数分かかるので sudo のタイムスタンプを延命する
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" 2>/dev/null || exit
  done 2>/dev/null &
  SUDO_KEEPALIVE_PID=$!
}

stop_sudo_keepalive() {
  [ -n "$SUDO_KEEPALIVE_PID" ] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
  return 0
}
trap stop_sudo_keepalive EXIT

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew already installed"
    return 0
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi

  if [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return 0
  fi

  # https://raw.githubusercontent.com/Homebrew/install/HEAD/README.md
  log "Installing Homebrew..."
  if [ "$DRY_RUN" -eq 1 ]; then
    log "DRY-RUN: /bin/bash Homebrew install.sh"
    return 0
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

BUNDLE_FAILED=0
MACOS_FAILED=0

install_brewfile() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "brew not found" >&2
    exit 1
  fi

  # brew bundle の vscode 拡張は PATH 上の code / codium / cursor を使う。
  # ~/.local/bin/cursor は Cursor Agent の CLI で IDE ではないため、
  # Cursor.app 同梱の CLI を先に見せる。
  # 参照: Homebrew bundle/extensions/vscode_extension.rb
  PATH="/Applications/Cursor.app/Contents/Resources/app/bin:${PATH}"
  export PATH

  # https://docs.brew.sh/Manpage#bundle-subcommand
  if ! run brew bundle --file="${REPO_DIR}/Brewfile"; then
    BUNDLE_FAILED=1
    log "WARN: brew bundle に失敗した項目があります。symlink 以降は続行します"
  fi
}

should_link() {
  local name="$1"
  if [ -z "$ONLY" ]; then
    return 0
  fi
  [ "$ONLY" = "$name" ]
}

known_only_name() {
  case "$1" in
    fish|fish-plugins|nvim|nvim-coc|karabiner|linearmouse|gitconfig|git-ignore|gh|cursor-settings|cursor-keybindings|cursor-tasks|macos|iterm)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

link_dotfiles() {
  if should_link fish; then
    backup_and_link "${REPO_DIR}/fish/config.fish" "${TARGET_HOME}/.config/fish/config.fish"
  fi
  if should_link fish-plugins; then
    backup_and_link "${REPO_DIR}/fish/fish_plugins" "${TARGET_HOME}/.config/fish/fish_plugins"
  fi
  if should_link nvim; then
    backup_and_link "${REPO_DIR}/nvim/init.vim" "${TARGET_HOME}/.config/nvim/init.vim"
  fi
  if should_link nvim-coc; then
    backup_and_link "${REPO_DIR}/nvim/coc-settings.json" "${TARGET_HOME}/.config/nvim/coc-settings.json"
  fi
  if should_link karabiner; then
    # 公式は karabiner.json 単体ではなく ~/.config/karabiner ディレクトリを symlink する。
    # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/
    backup_and_link "${REPO_DIR}/karabiner" "${TARGET_HOME}/.config/karabiner"
    if [ "$DRY_RUN" -eq 0 ] && [ "$TARGET_HOME" = "$HOME" ]; then
      launchctl kickstart -k "gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server" 2>/dev/null || true
    fi
  fi
  if should_link linearmouse; then
    backup_and_link "${REPO_DIR}/linearmouse/linearmouse.json" "${TARGET_HOME}/.config/linearmouse/linearmouse.json"
  fi
  if should_link gitconfig; then
    backup_and_link "${REPO_DIR}/git/gitconfig" "${TARGET_HOME}/.gitconfig"
  fi
  if should_link git-ignore; then
    backup_and_link "${REPO_DIR}/git/ignore" "${TARGET_HOME}/.config/git/ignore"
  fi
  if should_link gh; then
    backup_and_link "${REPO_DIR}/gh/config.yml" "${TARGET_HOME}/.config/gh/config.yml"
  fi
  if should_link cursor-settings; then
    backup_and_link "${REPO_DIR}/cursor/settings.json" "${TARGET_HOME}/Library/Application Support/Cursor/User/settings.json"
  fi
  if should_link cursor-keybindings; then
    backup_and_link "${REPO_DIR}/cursor/keybindings.json" "${TARGET_HOME}/Library/Application Support/Cursor/User/keybindings.json"
  fi
  if should_link cursor-tasks; then
    backup_and_link "${REPO_DIR}/cursor/tasks.json" "${TARGET_HOME}/Library/Application Support/Cursor/User/tasks.json"
  fi
}

install_fisher() {
  if ! command -v fish >/dev/null 2>&1; then
    log "fish not found, skip fisher"
    return 0
  fi

  # https://github.com/jorgebucaran/fisher
  if [ "$DRY_RUN" -eq 1 ]; then
    log "DRY-RUN: install fisher and fisher update"
    return 0
  fi

  fish -c 'if not functions -q fisher; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher; end; fisher update'
}

apply_macos_defaults() {
  if [ "$TARGET_HOME" != "$HOME" ]; then
    log "TARGET_HOME が実際の HOME と違うので macos defaults は実行しません"
    return 0
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    "${REPO_DIR}/macos/defaults.sh" --dry-run
    return 0
  fi
  if ! "${REPO_DIR}/macos/defaults.sh"; then
    MACOS_FAILED=1
    log "WARN: macos defaults に失敗した項目があります。fisher / vim-plug は続行します"
  fi
}

apply_iterm() {
  if [ "$TARGET_HOME" != "$HOME" ]; then
    log "TARGET_HOME が実際の HOME と違うので iTerm 配色は実行しません"
    return 0
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    "${REPO_DIR}/iterm/apply.sh" --dry-run
    return 0
  fi
  "${REPO_DIR}/iterm/apply.sh"
}

install_vimplug() {
  local plug="${TARGET_HOME}/.local/share/nvim/site/autoload/plug.vim"

  if [ -f "$plug" ]; then
    log "vim-plug already present"
  else
    # https://github.com/junegunn/vim-plug#neovim
    ensure_dir "$(dirname "$plug")"
    if [ "$DRY_RUN" -eq 1 ]; then
      log "DRY-RUN: curl vim-plug -> $plug"
    else
      curl -fLo "$plug" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
  fi

  if command -v nvim >/dev/null 2>&1 && [ "$DRY_RUN" -eq 0 ]; then
    nvim --headless +PlugInstall +qa || log "PlugInstall finished with warnings"
  elif [ "$DRY_RUN" -eq 1 ]; then
    log "DRY-RUN: nvim --headless +PlugInstall +qa"
  fi
}

print_shell_hint() {
  local fish_path=""
  if command -v fish >/dev/null 2>&1; then
    fish_path="$(command -v fish)"
  elif [ -x /opt/homebrew/bin/fish ]; then
    fish_path="/opt/homebrew/bin/fish"
  fi

  if [ -z "$fish_path" ]; then
    return 0
  fi

  cat <<EOF

Next (login shell):
  grep -q '${fish_path}' /etc/shells || echo '${fish_path}' | sudo tee -a /etc/shells
  chsh -s '${fish_path}'

gitconfig の email は転職先用に書き換えてください:
  ${REPO_DIR}/git/gitconfig
EOF
}

if [ -n "$ONLY" ]; then
  if ! known_only_name "$ONLY"; then
    echo "unknown --only name: $ONLY" >&2
    usage >&2
    exit 1
  fi
  SKIP_BREW=1
  SKIP_EXTRAS=1
fi

log "repo: ${REPO_DIR}"
log "home: ${TARGET_HOME}"
log "dry-run: ${DRY_RUN}  skip-brew: ${SKIP_BREW}  skip-extras: ${SKIP_EXTRAS}  only: ${ONLY:-all}"

if [ "$SKIP_BREW" -eq 0 ]; then
  if [ "$TARGET_HOME" != "$HOME" ]; then
    log "TARGET_HOME が実際の HOME と違うので brew は実行しません"
  else
    ensure_sudo
    install_homebrew
    install_brewfile
  fi
fi

link_dotfiles

if [ -z "$ONLY" ] || [ "$ONLY" = "macos" ]; then
  apply_macos_defaults
fi

if [ -z "$ONLY" ] || [ "$ONLY" = "iterm" ]; then
  apply_iterm
fi

if [ "$SKIP_EXTRAS" -eq 0 ]; then
  if [ "$TARGET_HOME" != "$HOME" ]; then
    log "TARGET_HOME が実際の HOME と違うので fisher / vim-plug は実行しません"
  else
    install_fisher
    install_vimplug
    print_shell_hint
  fi
fi

if [ "$BUNDLE_FAILED" -eq 1 ] || [ "$MACOS_FAILED" -eq 1 ]; then
  log "done (brew bundle または macos defaults に失敗あり。上のログを確認してください)"
  exit 1
fi

log "done"
