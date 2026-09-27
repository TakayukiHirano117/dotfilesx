# 管理対象は symlink する

**最終更新**: 2026-09-27

## 要点

- 実機ファイルを repo へ symlink すれば、普段の編集がそのまま repo に乗る。取り直し指示は不要
- `install.sh` の `backup_and_link` が正。既存ファイルは `*.bak.YYYYMMDDHHMMSS` に退避してからリンク
- `config.fish` も対象。シェル設定は新 PC 再現の中心だから
- リンクしないもの: `macos/defaults.sh`（defaults 書き込みスクリプト）、秘密情報（`fish_variables` / `gh` の `hosts.yml` / `.ssh`）

## 補足

- 2026-09-27 に未リンクだった管理ファイルを全部リンク済み
- 現行 `config.fish` には `AWS_PROFILE` と、存在チェック付きの Google Cloud SDK パスがある。認証情報そのものは無い

## 元の文脈

- 質問: symlink した方が取り直し不要では / `config.fish` もやるべきか
