# GitHub Integration & SSH Setup Guide / GitHub連携・SSH設定ガイド

本ドキュメントでは、SREワークステーションにおける GitHub との安全な連携、および SSH 鍵の厳格な生成・管理手順を定義します。

---

## 1. 認証設計の哲学

GitHub との通信において、パスワード認証および有効期限のない脆弱な長期アクセストークン（Personal Access Token）の直接利用は原則として禁止します。
本リポジトリでは以下の原則を徹底します。

1. **強固な暗号化方式の採用**: 推奨される最新の暗号方式（Ed25519）を用いた SSH キーペアを使用する。
2. **鍵のパスフレーズ保護**: 生成した秘密鍵には必ず強固なパスフレーズを設定し、不正アクセスを防止する。
3. **最小権限・個別管理**: 端末ごとに専用の SSH キーを生成し、GitHub アカウントに登録・管理する。

---

## 2. SSH キーの生成手順

WSL2 (Ubuntu) または macOS のターミナルを開き、以下のコマンドを実行して新しい SSH キーを生成します（メールアドレスはご自身の GitHub 登録メールアドレスに変更してください）。

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- **ファイルの保存先**: デフォルト (`~/.ssh/id_ed25519`) のままで問題ありません。
- **パスフレーズ**: 必ず任意の強固なパスフレーズを設定してください。

---

## 3. パーミッションの厳格化（重要）

SSH 関連ファイルやディレクトリの権限が緩い場合、SSH クライアントから接続が拒否されます。以下のパーミッションを確実に適用してください。

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

## 4. SSH エージェントへの登録と自動化

ターミナルセッションごとにパスフレーズの入力を省略しつつ安全に扱うため、ssh-agent を設定します。

### 4.1. バックグラウンドで ssh-agent を起動

```bash
eval "$(ssh-agent -s)"
```

### 4.2. キーの追加

```bash
ssh-add ~/.ssh/id_ed25519
```

## 5. GitHub への公開鍵の登録

以下のコマンドで公開鍵の内容をクリップボードにコピーします。

- **macOS の場合**:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

- **WSL2 (Ubuntu) の場合**:

```bash
cat ~/.ssh/id_ed25519.pub
```

(出力された ssh-ed25519 ... から始まる文字列をコピーしてください)

### 登録手順

1. GitHub にログインし、**Settings** > **SSH and GPG keys** に移動します。
2. **New SSH key** をクリックします。
3. **Title** に任意の識別名（例: `sre-workstation-ubuntu` や `sre-workstation-mac`）を入力します。
4. **Key** にコピーした公開鍵を貼り付け、**Add SSH key** をクリックします。

---

## 6. 接続テスト

正しく設定されているかを確認するため、以下のコマンドを実行します。

```bash
ssh -T git@github.com
```

### **成功時の出力例**:

> Hi `<username>`! You've successfully authenticated, but GitHub does not provide shell access.

---

## 7. Git の基本設定（グローバル）

コミット履歴の署名や識別を正しく行うため、Git のグローバル設定を構成します。

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
git config --global init.defaultBranch main
```























