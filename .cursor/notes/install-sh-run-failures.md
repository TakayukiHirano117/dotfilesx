# install.sh 実行で出た2つの失敗（2026-09-27）

**最終更新**: 2026-09-27

## 要点

- 失敗は2つ。`codex` cask が入らない / `defaults write com.apple.universalaccess` が拒否される
- どちらもこの Mac の状態が原因。Brewfile の記述ミスと、Cursor 統合ターミナルの権限不足

## 1. `codex` cask: `--cask and --overwrite are mutually exclusive`

- `Brewfile` の `cask "codex", args: { overwrite: true }` が `brew install --cask codex --overwrite --adopt` になる
  - 変換: `/opt/homebrew/Library/Homebrew/bundle/cask.rb`（`true` → `--flag`）
  - 拒否: `/opt/homebrew/Library/Homebrew/cmd/install.rb` の `conflicts "--cask", "--overwrite"`（Homebrew 7.0.6）
- `--overwrite` は formula の link 用。cask では使えない
- `overwrite: true` を消しても、このままでは失敗する見込み
  - `/opt/homebrew/bin/codex` は npm の `@openai/codex` 0.130.0 への symlink（`/opt/homebrew/lib/node_modules/...`、2026-05-14）
  - cask の `binary` は既存 symlink が「同じ cask 由来」か「Cellar の formula 由来」でなければ `CaskError` を投げる（`cask/artifact/symlinked.rb` の `link_action`）。npm 由来はどちらでもない
  - `--force` でも同じ判定。上書きされない（manpage: binaries and symlinks are excluded, unless originally from the same cask）
- 新 PC では npm の codex が無いので、`overwrite: true` を消せば入る
- この Mac で入れるなら、先に npm 版を消す（`/opt/homebrew/bin/codex` と `/opt/homebrew/lib/node_modules/@openai/codex`）。今の `npm prefix -g` は `~/.local` なので `npm uninstall -g` は効かない
- `codex-app` cask は入っている（26.623.141536）。公式で deprecated、2027-07-12 に disable、代替は `chatgpt` cask

## 2. `Could not write domain com.apple.universalaccess; exiting`

- macOS 15.5 の System Policy が `defaults` の書き込みを拒否した。統合ログ（`/usr/bin/log show`）の一次証拠:
  - `kernel: (Sandbox) System Policy: defaults(78505) deny(1) user-preference-write com.apple.universalaccess`
  - `cfprefsd: rejecting write of key(s) mouseDriverCursorSize ... requires user-preference-write or file-write-data sandbox access`
  - 同じ実行中に `tccd: kTCCServiceSystemPolicyAllFiles ... Cursor ... Denied (Service Policy)`
- 実行したターミナルは Cursor 統合ターミナル（fish の親が `Cursor Helper: terminal pty-host`）。責任アプリは Cursor.app で、Cursor にフルディスクアクセスは無い
- `set -e` で `defaults.sh` の1行目で止まった。以降のキーリピート書き込み、fisher、vim-plug は未実行
- 値自体はこの Mac に既に入っている（サイズ 2、customized 1、KeyRepeat 2 / 15 / PressAndHold 0）ので実害なし
- 対処（第三者報告、二次ソース）: ターミナルアプリにフルディスクアクセスを付けて再起動すると通る
  - https://github.com/mathiasbynens/dotfiles/issues/1027
  - この Mac で iTerm2 に FDA があるかは未確認

## 元の文脈

- 質問: `./install.sh` 実行ログのエラーはどういうエラーか、全部調査して

---

## 2026-09-27 対処

- `Brewfile`: `args: { overwrite: true }` を削除。npm 版が居ると失敗する旨をコメントに残した
- この Mac: `npm uninstall -g --prefix /opt/homebrew @openai/codex` で npm 版を消し、`brew install --cask codex --adopt` で 0.157.1 を入れた。`brew bundle check` は満たされた
- `macos/defaults.sh`: universalaccess の書き込み失敗で止めず、キーリピートまで書いて WARN と対処法を出し exit 1
- `install.sh`: `defaults.sh` の失敗を brew bundle と同じく WARN 扱いにして fisher / vim-plug は続行。最後に exit 1
- フルディスクアクセスはスクリプトからは付けられない（TCC はユーザー操作のみ）。Cursor / iTerm2 に手で付けて再起動後 `./install.sh --only macos`
