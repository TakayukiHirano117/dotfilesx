# キーリピートとフルインストール試験

**最終更新**: 2026-09-27

## 要点

- Delete 長押しの速さは入る。`KeyRepeat=2` / `InitialKeyRepeat=15`（この Mac の実値）。公式 UI はキーボードのキーリピート
- 偽ホーム試験では brew も macOS defaults も走らない
- この PC で `./install.sh` を素で走らせるのは新 PC 試験にならない。`brew bundle` はデフォルトで upgrade する（今 133 formula が outdated）
- GUI アプリの多くは入っているが Homebrew 管理外。`brew bundle` は cask に `--adopt` を付ける
- アプリ新規インストールの成功は、会社の新品 Mac か別マシンでしか確認できない

## 元の文脈

- 質問: 文字消し速度は入るか / アプリ込みで全部動くかこの PC で試してよいか
