# Neovim 設定バックアップ

Cursor × NeoVim 整理（2026-08-29）前の設定。

## ファイル

| ファイル | 内容 |
|----------|------|
| `init.vim.before-migration-2026-08-29.vim` | 変更前の `~/.config/nvim/init.vim`（VSCode ブロックがコメントアウトされていた版） |
| `init.vim.home-bak-20260829172240.vim` | `install.sh` が symlink 化時に作った同一内容のバックアップ |
| `coc-settings.json.before-migration-2026-08-29.json` | 変更前の coc-settings |

## 復元方法

```sh
# init.vim を戻す（symlink を外してコピー）
cp dotfilesx/nvim/backups/init.vim.before-migration-2026-08-29.vim ~/.config/nvim/init.vim

# または symlink のまま dotfilesx を戻す場合
cp dotfilesx/nvim/backups/init.vim.before-migration-2026-08-29.vim dotfilesx/nvim/init.vim
```

Cursor 再起動後、`Neovim: Restart Extension` を実行。
