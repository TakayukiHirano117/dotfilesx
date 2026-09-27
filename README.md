# dotfilesx

新しい Mac で開発環境を再現するための dotfiles。設定はシンボリックリンク、ツールは Homebrew Bundle。

## 初日

```sh
git clone <this-repo>
cd dotfilesx
./install.sh
```

`./install.sh` が [Homebrew の公式インストーラ](https://raw.githubusercontent.com/Homebrew/install/HEAD/README.md) を入れたあと、[`brew bundle`](https://docs.brew.sh/Manpage#bundle-subcommand) で `Brewfile` を実行する。`Brewfile` に書いてあるものはここから入る。

- CLI: `fish` / `git` / `gh` / `neovim` / `tmux` / `fzf` / `ripgrep` など
- GUI: Cursor / Docker Desktop / iTerm2 / Karabiner-Elements / LinearMouse / Rectangle / Clipy / Chrome / DBeaver / Claude / Codex（CLI + デスクトップ） / Aqua Voice など（cask。`brew bundle` は既存アプリに [`--adopt`](https://docs.brew.sh/Manpage#install-formula-options) を付ける）
- Cursor 拡張（`Brewfile` の `vscode "..."`）
- 設定ファイルの symlink
- macOS のポインタとキーリピート（`macos/defaults.sh`）
- fisher と vim-plug

fish も `Brewfile` の `brew "fish"` なので、別途自分で入れる必要はない。

既存ファイルがある場合は `*.bak.YYYYMMDDHHMMSS` に退避してからリンクする。

### 後で直すこと: gitconfig

`git/gitconfig` には、今の個人用の名前とメールアドレスが入っている。転職先の PC では会社用に書き換えること。このままだと個人メールで commit される。

### 今の PC を壊さずに確認する

```sh
./install.sh --dry-run --skip-brew --home /tmp/dotfilesx-test
./install.sh --skip-brew --home /tmp/dotfilesx-test
```

`--home` を付けた場合、Brewfile と macos defaults は実行しない。

1ファイルだけ試す:

```sh
./install.sh --only git-ignore
./rollback.sh --only git-ignore
./install.sh --only macos --dry-run
```

`--only` を付けると brew / extras は走らない。`--only macos` はポインタとキーリピートだけ書く。

### 切り戻し

`install.sh` をミスったときは、同じホームに対して:

```sh
./rollback.sh --dry-run
./rollback.sh
```

偽ホームで試したなら:

```sh
./rollback.sh --home /tmp/dotfilesx-test
```

このリポジトリへ向いている symlink だけを外し、`install.sh` が作った最新の `*.bak.YYYYMMDDHHMMSS` を元に戻す。Homebrew で入れたアプリは消さない。

## 管理しているもの

| リポジトリ | リンク先 |
|---|---|
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `fish/fish_plugins` | `~/.config/fish/fish_plugins` |
| `nvim/init.vim` | `~/.config/nvim/init.vim` |
| `nvim/coc-settings.json` | `~/.config/nvim/coc-settings.json` |
| `karabiner/karabiner.json` | `~/.config/karabiner/karabiner.json` |
| `linearmouse/linearmouse.json` | `~/.config/linearmouse/linearmouse.json` |
| `git/gitconfig` | `~/.gitconfig` |
| `git/ignore` | `~/.config/git/ignore` |
| `gh/config.yml` | `~/.config/gh/config.yml` |
| `cursor/settings.json` | `~/Library/Application Support/Cursor/User/settings.json` |
| `cursor/keybindings.json` | `~/Library/Application Support/Cursor/User/keybindings.json` |
| `cursor/tasks.json` | `~/Library/Application Support/Cursor/User/tasks.json` |
| `macos/defaults.sh` | シンボリックリンクではない。`defaults` でシステム設定を書く |

`cursor/tasks.json` はユーザー全体用。中身は空。プロジェクト用タスクは各リポジトリの `.vscode/tasks.json` に置く。

`macos/defaults.sh` が書くのは、このマシンで確認した次の値。

- ポインタのサイズと色（システム設定 > アクセシビリティ > ディスプレイ > ポインタ。[公式](https://support.apple.com/ja-jp/guide/mac-help/unac089/mac)）
- キーリピート（システム設定 > キーボード。[公式](https://support.apple.com/ja-jp/guide/mac-help/mchl0311bdb4/mac)。Delete 長押しで文字が消える速さ）

キー名（`mouseDriverCursorSize` など）は Apple の公開ドキュメントには無い。2026-08-23 の macOS 15.5 で `defaults read` して取った。効き方はログアウトまたは再起動後が確実なことがある。`rollback.sh` では戻さない。

## 入れないもの

- `.ssh`（転職先で鍵を作り直す）
- AWS credentials、API key、`gh` の `hosts.yml`、`fish_variables`
- LINE / Prime Video など個人アプリ
- TablePlus
- zsh 設定

## スクリプトだけでは終わらないもの

ログインシェルの変更は `sudo` が必要なので、`install.sh` の最後にコマンドを出す。表示された `chsh` を一度実行する。

Homebrew 外の実体は初日スクリプトでは入れない。

- [nvm](https://github.com/nvm-sh/nvm)（今の Node はこれ）
- [bun](https://bun.sh)
- Laravel Herd Lite（今の `php` / `composer`）
- 公式の Go インストーラ（今の `go` は `/usr/local/go`）
- SSH 鍵（転職先で新規作成）
- `gh auth login`

## 参照

- Homebrew インストール: https://raw.githubusercontent.com/Homebrew/install/HEAD/README.md
- `brew bundle`: https://docs.brew.sh/Manpage#bundle-subcommand
- fisher: https://github.com/jorgebucaran/fisher
- vim-plug (Neovim): https://github.com/junegunn/vim-plug#neovim
- User tasks: https://code.visualstudio.com/docs/debugtest/tasks
- ポインタ: https://support.apple.com/ja-jp/guide/mac-help/unac089/mac
- キーリピート: https://support.apple.com/ja-jp/guide/mac-help/mchl0311bdb4/mac
