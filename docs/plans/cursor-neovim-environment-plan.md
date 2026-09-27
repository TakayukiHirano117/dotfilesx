# Cursor × NeoVim 開発環境整理プラン

> **ステータス**: Phase 0–3 実施済み（2026-08-29）— Cursor 再起動後にスモークテスト要  
> **作成日**: 2026-08-29  
> **目的**: GD / Ctrl-o の不安定さを解消し、会社 PC から持ち帰った Neovim 設定を正として環境を再構成する

---

## 1. 背景とゴール

### 課題

- Cursor + vscode-neovim で `gd`（定義ジャンプ）や `Ctrl-o`（戻る）がたまに動かなくなる
- 会社 PC から持ち帰った `init.vim`（VSCode 用ブロックが**有効**）と、現在の `~/.config/nvim/init.vim`（VSCode 用ブロックが**コメントアウト**）が乖離している
- `dotfilesx` の `nvim/init.vim` は現行マシンと同じ古い状態で、会社 PC 版は未取り込み
- Cursor の `settings.json` / `keybindings.json` にデッド設定・非推奨拡張の痕跡がある

### ゴール

| 領域 | 完了条件 |
|------|----------|
| Cursor 内 NeoVim | `gd` / `gD` / `Ctrl-o` / `Ctrl-i` が 5 回連続で安定 |
| ターミナル NeoVim | 会社 PC と同等の UX（kanagawa, treesitter, toggleterm, coc 等） |
| dotfilesx | 正本が 1 箇所に集約され、`install.sh` で再現可能 |
| Cursor 設定 | デッド設定削除、Go 開発向けの最低限の整理 |

### 非ゴール（今回やらない）

- Karabiner / LinearMouse の変更
- 新しい拡張の大量追加
- ターミナル Neovim のプラグイン構成の全面再設計

---

## 2. 現状スナップショット（調査時点）

### ファイルの所在とリンク状態

| パス | 状態 |
|------|------|
| `~/.config/nvim/init.vim` | 通常ファイル（dotfilesx と**未リンク**） |
| `dotfilesx/nvim/init.vim` | 現行マシンと同一（古い版） |
| `~/Library/Application Support/Cursor/User/settings.json` | 通常ファイル（dotfilesx と**未リンク**） |
| `dotfilesx/cursor/settings.json` | ほぼ同一内容 |

### Cursor 拡張（主要）

- `asvetliakov.vscode-neovim` ✅
- `golang.go`, `eamodio.gitlens`, `usernamehw.errorlens`, `esbenp.prettier-vscode` 等
- 非推奨: `coenraads.bracket-pair-colorizer-2`
- `vim.*` 設定が `settings.json` に残存（VSCodeVim 未インストール）

### 根本原因（一次ソースベース）

[vscode-neovim README - Neovim configuration](https://github.com/asvetliakov/vscode-neovim#neovim-configuration):

- 多くの Vim プラグインは VSCode 内で問題を起こす → **空の init から始めることを推奨**
- LSP / 補完 / fuzzy-finder 系は VSCode 内では不要か有害

[vscode-neovim README - Jumplist](https://github.com/asvetliakov/vscode-neovim#jumplist):

- `Ctrl-o` は Neovim のジャンプリストではなく `workbench.action.navigateBack` を使用
- `gd` は拡張が `editor.action.revealDefinition` にマップ済み

**現状の問題**: VSCode 用 `finish` が無効 → `coc.nvim` 等が Cursor 内でも起動 → `gd` / ジャンプリストと競合しやすい。

---

## 3. init.vim 差分調査（会社 PC 版 vs 現行）

比較対象:

- **A**: 会社 PC から持ち帰った版（ユーザー提供・2026-08-29）
- **B**: `~/.config/nvim/init.vim` / `dotfilesx/nvim/init.vim`（現行）

### 3.1 VSCode/Cursor 用ブロック（最重要）

| 項目 | 会社 PC (A) | 現行 (B) | 修正方針 |
|------|-------------|----------|----------|
| `if exists('g:vscode')` | **有効** + `finish` | **全行コメントアウト** | **A を採用** |
| API | `lua require('vscode').action()` | `VSCodeNotify()`（コメント内） | **A を採用**（[現行 API](https://github.com/asvetliakov/vscode-neovim#-api)） |
| Commentary | `<Plug>VSCodeCommentary` | `<Plug>(VSCodeCommentary)` | A を採用（括弧なしで動作していた実績） |
| `set signcolumn=yes` | VSCode ブロック内にある | なし | A から採用 |
| `gd` 等の LSP マップ | 自前マップあり | コメント内に同様の定義 | **議論**: 拡張デフォルトに任せるなら削除可（後述） |

会社 PC 版の VSCode ブロックは **Cursor 安定化の本丸**。現行はこのブロックが死んでいるため、ターミナル用プラグイン一式が Cursor 内で起動している。

### 3.2 ターミナル Neovim 基本設定

| 項目 | 会社 PC (A) | 現行 (B) |
|------|-------------|----------|
| `set signcolumn=yes` | あり（共通部） | なし |
| `syntax on` | あり | コメントアウト |
| `ignorecase` / `smartcase` | あり | なし（VSCode ブロック内のみコメント） |
| `set undofile` | あり | なし |
| `filetype plugin indent on` | あり | なし |
| `set shell` | なし（fish 利用なら不要の可能性） | `/bin/zsh` |
| `vim_markdown_auto_insert_bullets` | なし | あり |

### 3.3 プラグイン一覧の差分

#### 会社 PC (A) にあって現行 (B) にない（**取り込み推奨**）

| プラグイン | 用途 |
|-----------|------|
| `nvim-treesitter` | 構文ハイライト・indent |
| `treesj` | ブロックの split/join |
| `rainbow-delimiters.nvim` | 括弧色分け |
| `nvim-notify` | 通知 UI |
| `vim-tmux-navigator` | tmux 連携 |
| `toggleterm.nvim` | 下部ターミナル（VSCode 風マルチターミナル） |
| `gitsigns.nvim` | Git 表示（gitgutter と併存している点は要確認） |
| `vim-bookmarks` | ブックマーク |
| `vim_current_word` | カーソル単語ハイライト |
| `vim-better-whitespace` | 末尾空白の可視化・削除 |
| `winresizer` | ウィンドウリサイズ |
| `kanagawa.nvim` | カラースキーム |

#### 現行 (B) にあって会社 PC (A) にない（**整理対象**）

| プラグイン | 判断 |
|-----------|------|
| `vim-airline` + themes | A では bufferline に統一 → **削除候補** |
| `kshenoy/vim-signature` | マーク表示。A は vim-bookmarks → **削除候補** |
| `romkatv/powerlevel10k` | シェル用。Neovim プラグインとして不適切 → **削除** |
| `tomasiser/vim-code-dark` | A は kanagawa → **削除候補** |
| `ntk148v/vim-horizon` | 未使用コメントあり → **削除候補** |

#### 両方にある（維持）

alpha-nvim, indent-blankline, visual-multi, highlightedyank, aerial, smoothie, nerdfont, telescope, glyph-palette, vim-move, commentary, coc.nvim, vim-rails, gitgutter, noice, nui, plenary, nvim-tree, bufferline

**注意**: A では `gitgutter` と `gitsigns` が両方ある。どちらかに統一するか、役割分担を決める必要がある（Phase 2 で判断）。

### 3.4 キーマップ・UX の差分（ターミナル Neovim）

| 機能 | 会社 PC (A) | 現行 (B) |
|------|-------------|----------|
| NvimTree | `Space` でツリーへ、`leader+e` toggle | `leader+e/f/o` |
| バッファ切替 | `S-h` / `S-l`, `leader 1-4` | なし |
| ターミナル | `Ctrl-t` toggle, `leader tn/tc/tl` | なし |
| ウィンドウ移動 | `Alt+h/j/k/l` | なし |
| Coc LSP | 末尾に明示的マップ（`gd`, `K`, `[g` 等） | coc マップなし（gitgutter が `g[` `g]`） |
| Git hunk | gitgutter: `g[` `g]` | 同じ（VSCode ブロックの `g[` `g]` とキー競合は Cursor 内では `finish` で回避） |

### 3.5 カラースキーム

| | 会社 PC (A) | 現行 (B) |
|---|-------------|----------|
| テーマ | kanagawa-dragon（詳細 overrides） | codedark（シンプル） |
| カーソル | 白カーソル + Insert 用ハイライト | 基本設定のみ |

**方針**: ターミナル Neovim は **A の kanagawa 設定を正**とする。

### 3.6 会社 PC 版で直すときに触るファイル

| 優先度 | ファイル / 設定 | やること |
|--------|-----------------|----------|
| P0 | `nvim/init.vim` | 会社 PC 版をベースに dotfilesx へ取り込み、VSCode ブロックを有効化 |
| P0 | `~/.config/nvim/init.vim` | `install.sh` 経由で symlink 化 |
| P1 | `nvim/coc-settings.json` | 会社 PC と差分があれば同期（要確認） |
| P2 | `cursor/settings.json` | デッド設定削除・Go formatOnSave 等 |
| P2 | `cursor/keybindings.json` | 競合キーの整理 |
| P3 | `Brewfile` | 拡張リストの整理 |

---

## 4. VSCode ブロックの設計判断（実施前に決める）

### 選択肢: `gd` 等の LSP マップ

| 案 | 内容 | メリット | デメリット |
|----|------|----------|------------|
| **案 1** | 会社 PC 版どおり自前マップを維持 | 会社 PC と同じ挙動 | 拡張デフォルトと二重定義 |
| **案 2** | LSP マップ（`gd`, `gr`, `gi`, `K`）は削除し拡張デフォルトに任せる | 公式推奨に近い、メンテ少 | 会社 PC との差分 |
| **案 3** | ハイブリッド: ナビ以外（`leader` 系）のみ自前、LSP はデフォルト | バランス良い | — |

**推奨**: **案 3**。会社 PC の `leader` マップ・分割・Git 差分移動は維持。`gd` / `Ctrl-o` は拡張の jumplist 連携を優先し、自前 `gd` は入れない（`gD` peek も拡張デフォルトで利用可能）。

### 選択肢: init のファイル構成

| 案 | 内容 |
|----|------|
| **案 A** | 1 ファイル `init.vim` + `g:vscode` + `finish`（会社 PC 方式） |
| **案 B** | `init.vim`（ターミナル用）+ `init.vscode.vim`（Cursor 専用）+ `neovimInitVimPaths` |

**推奨**: **案 A**（会社 PC の実績がある）。問題が続く場合のみ案 B へ。

---

## 5. Cursor settings / keybindings 整理項目

### settings.json

| 項目 | 現状 | 方針 |
|------|------|------|
| `vim.insertModeKeyBindings` | 残存 | **削除**（VSCodeVim 未使用） |
| `vim.hlsearch` | 残存 | **削除** |
| `blockman.n04ColorComboPreset` | 拡張未インストール | **削除** |
| `bracket-pair-colorizer-2` 関連 | 残存 | 拡張削除後 **削除**、`editor.bracketPairColorization.enabled: true` |
| `[go] formatOnSave` | なし | **追加検討** |
| `editor.gotoLocation.multipleReferences` 等 | 未定義 | `"goto"` **追加検討** |
| `vscode-neovim.neovimInitVimPaths.darwin` | コメントアウト | 案 A なら不要、案 B なら設定 |
| `extensions.experimental.affinity` | neovim: 1 | **維持** |
| `workbench.editor.enablePreview` | false | **維持**（ジャンプリストに重要） |

### keybindings.json

| キー | 現状 | 競合リスク | 方針 |
|------|------|------------|------|
| `Ctrl-h` / `Ctrl-l` | タブ前後 | VSCode ブロックの分割移動と役割が近い | 維持 or Neovim `Ctrl-w h/l` に寄せる（要判断） |
| `Ctrl-n` | エクスプローラ | 補完 `Ctrl-n` | `when` 条件の見直し検討 |
| `Space` (normal) | エクスプローラ | 会社 PC ターミナルは NvimTree focus | Cursor 用は現状維持で OK |
| `Cmd+i` | Agent | — | 維持 |

---

## 6. 拡張機能整理

| 拡張 | 方針 | Phase |
|------|------|-------|
| `bracket-pair-colorizer-2` | 無効化 → 削除 | Phase 5 |
| `rebornix.ruby` | ruby-lsp と重複確認後削除 | Phase 5 |
| `indent-rainbow` | Brewfile にあるが未導入 → 入れない | — |
| その他主要拡張 | 維持 | — |

---

## 7. 実施フェーズ（実行順）

各 Phase は **独立してコミット可能**な粒度。Phase 完了ごとにスモークテスト。

```
Phase 0 → 1 → 2 → 3 → 4 → 5 → 6
```

### Phase 0: バックアップと記録（変更なし）

- [ ] `~/.config/nvim/init.vim` をバックアップ
- [ ] Cursor `settings.json` / `keybindings.json` をバックアップ
- [ ] `cursor --list-extensions` を保存
- [ ] 現状の不具合手順をメモ（例: どの言語で `Ctrl-o` が死ぬか）

### Phase 1: 切り分け（一時設定のみ）

- [ ] `vscode-neovim.neovimClean: true` を一時 ON
- [ ] `gd` / `gD` / `Ctrl-o` をテスト
- [ ] 結果をこのドキュメントの「Phase 1 結果」に追記
- [ ] `neovimClean` を OFF に戻す

**Phase 1 結果**: Phase 2 を優先実施（neovimClean 切り分けはスキップ）

### Phase 2: init.vim 取り込み（本丸）

- [ ] 会社 PC 版を `dotfilesx/nvim/init.vim` のベースにする
- [ ] VSCode ブロックを有効化（案 3 の LSP 方針を適用）
- [ ] `gitgutter` vs `gitsigns` の方針を決定して反映
- [ ] `powerlevel10k` 等の不要プラグインを除去
- [ ] `go` を treesitter `ensure_installed` に追加（Go 学習中）
- [ ] `install.sh --skip-brew --home /tmp/dotfilesx-test` で dry-run
- [ ] `./install.sh --only nvim`（または相当）で本番リンク
- [ ] `nvim --headless +PlugInstall +qa` でプラグインインストール
- [ ] **ターミナル Neovim** で起動・telescope・toggleterm を確認
- [ ] **Cursor** で `gd` / `gD` / `Ctrl-o` を 5 回テスト
- [ ] 問題時: `Neovim: Restart Extension`

### Phase 3: Cursor settings.json 整理

- [ ] デッド設定削除（`vim.*`, `blockman.*`）
- [ ] Go / gotoLocation 設定の追加
- [ ] bracket pair colorization 内蔵機能へ移行
- [ ] dotfilesx `cursor/settings.json` と同期 + symlink 化検討

### Phase 4: keybindings.json 整理

- [ ] `Ctrl-h/l` の方針を決定して反映
- [ ] 1 変更ずつテスト
- [ ] dotfilesx と同期

### Phase 5: 拡張機能整理

- [ ] `bracket-pair-colorizer-2` 無効化・削除
- [ ] `rebornix.ruby` 確認・削除
- [ ] `Brewfile` の `vscode "..."` リスト更新

### Phase 6: ドキュメント・再現性

- [ ] `dotfilesx/README.md` に Neovim / Cursor 分離の説明を追記
- [ ] symlink 運用（`install.sh`）の手順を明記
- [ ] このプランファイルのステータスを「完了」に更新

---

## 8. スモークテストチェックリスト

各 Phase 後に 5 分で実施。対象: `go-zissen-nyumon/first_webapp/server.go`

### Cursor 内

- [ ] `gd` → 定義へジャンプ
- [ ] `gD` → Peek 定義が開く → `Esc` で閉じる
- [ ] `Ctrl-o` → 元の位置に戻る（5 回連続）
- [ ] `Ctrl-i` → 進む
- [ ] `Space` → エクスプローラ ⇔ エディタ
- [ ] `,p`（leader-p）→ Quick Open
- [ ] Go の format on save（Phase 3 後）

### ターミナル Neovim

- [ ] 起動エラーなし
- [ ] kanagawa テーマ表示
- [ ] `leader-e` → NvimTree
- [ ] `Ctrl-t` → toggleterm
- [ ] `gd` → coc 定義ジャンプ
- [ ] Telescope `leader-p`

---

## 9. ロールバック

| 状況 | 手順 |
|------|------|
| init.vim が壊れた | Phase 0 バックアップを `~/.config/nvim/init.vim` に復元 |
| Cursor 設定が壊れた | バックアップの settings/keybindings を復元 |
| プラグイン問題 | `nvim --headless +PlugClean! +qa` は慎重に。まず Plug リストを戻す |
| NeoVim 拡張がおかしい | コマンド `Neovim: Restart Extension` |

---

## 10. 実施前の確認事項（ユーザー判断）

以下が決まってから Phase 2 に入る:

1. **LSP マップ方針**: 案 1 / 2 / 3 のどれか（推奨: 案 3）
2. **init ファイル構成**: 案 A / 案 B（推奨: 案 A）
3. **gitgutter vs gitsigns**: 両方維持 / gitsigns に統一 / gitgutter に統一
4. **Ctrl-h/l**: タブ移動を維持するか、分割移動に寄せるか
5. **symlink 化**: 今回 `install.sh` で Cursor / nvim をリンクするか、手動コピーか

---

## 11. 参考リンク（一次ソース）

- [vscode-neovim - Neovim configuration](https://github.com/asvetliakov/vscode-neovim#neovim-configuration)
- [vscode-neovim - Troubleshooting](https://github.com/asvetliakov/vscode-neovim#troubleshooting)
- [vscode-neovim - Jumplist](https://github.com/asvetliakov/vscode-neovim#jumplist)
- [vscode-neovim - Code navigation bindings](https://github.com/asvetliakov/vscode-neovim#code-navigation-bindings)（`gd`, `gD` 等）
- [VS Code - editor.action.peekDefinition](https://code.visualstudio.com/api/references/commands)
- [dotfilesx install.sh](../../install.sh)

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-08-29 | Phase 0–3 実施: init.vim 取り込み、symlink、settings 整理、bracket-pair-colorizer 削除 |
