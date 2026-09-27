# 会社 PC での clone 手順

**最終更新**: 2026-09-27

## 要点

- `dotfilesx` は public。HTTPS clone に SSH 鍵は不要
- 初日の本体は `git clone` → `./install.sh`（[README](../../README.md)）
- clone 前に使える `git` が必要。Homebrew 公式インストーラは git が無いと止まる
- `ssh-keygen` は個人 GitHub への clone 必須ではなく、転職先で鍵を新規作成する想定（README）
- あとで自分でやる: `chsh`、gitconfig の会社メール、`gh auth`、nvm / bun / Herd / Go

## 元の文脈

- 質問: ssh-keygen → 個人 GitHub に鍵登録 → clone → `./install.sh` だけか
