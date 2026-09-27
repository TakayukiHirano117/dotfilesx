# install.sh が入れるツール

**最終更新**: 2026-09-27

## 要点

- 本物の HOME で `./install.sh`（`--skip-brew` なし）なら、Homebrew + Brewfile のツールが入る
- 偽ホーム試験（`--home /tmp/...` や `--skip-brew`）ではツールは入らない
- 入るのは Brewfile に書いた CLI / cask / Cursor 拡張と、fisher / vim-plug
- 入らない: nvm / bun / Herd / 公式 Go / SSH / `gh auth` / `chsh`（案内だけ）

## 元の文脈

- 質問: 必要なツールのインストールまでやってくれるか
