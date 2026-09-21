# Troubleshooting Guide / トラブルシューティングガイド

本ドキュメントでは、SREワークステーション（WSL2 / macOS）の構築および日常運用において発生しやすい問題と、その診断・解決手順をまとめます。

---

## 1. 接続・認証系トラブル

### 1.1. AWS 認証エラー (`ExpiredToken` / `AccessDenied`)
- **症状**: AWS CLI や IaC 実行時に認証エラーや権限不足が発生する。
- **原因**: セッションの有効期限切れ、または誤ったプロファイルが選択されている。
- **解決手順**:
  1. 現在のアイデンティティを確認する:
     ```bash
     aws sts get-caller-identity
     ```
  2. プロファイルを再選択・再ログインする:
     ```bash
     asp
     ```
  3. 検証: 再度 `aws sts get-caller-identity` を実行し、想定通りのロールになっていることを確認する。

### 1.2. GitHub SSH 接続エラー (`Permission denied (publickey)`)
- **症状**: `git push` や `ssh -T git@github.com` が公開鍵認証で失敗する。
- **原因**: SSHエージェントに鍵が登録されていない、またはファイルのパーミッションが不正。
- **解決手順**:
  1. パーミッションの確認と修正:
     ```bash
     chmod 700 ~/.ssh
     chmod 600 ~/.ssh/id_ed25519
     ```
  2. SSHエージェントへの鍵の追加:
     ```bash
     eval "$(ssh-agent -s)"
     ssh-add ~/.ssh/id_ed25519
     ```
  3. 検証: `ssh -T git@github.com` を実行し、認証成功メッセージを確認する。

---

## 2. 環境・ツール系トラブル

### 2.1. コマンドが見つからない (`command not found`)
- **症状**: `fzf`, `starship`, `node` などのコマンドが実行できない。
- **原因**: シェルの初期化ファイル (`~/.zshrc`) が正しく読み込まれていない、またはパスが通っていない。
- **解決手順**:
  1. シェルの設定を再読み込みする:
     ```bash
     source ~/.zshrc
     ```
  2. Homebrew（macOS）または Linux のパスが通っているか確認する:
     ```bash
     echo $PATH
     ```


