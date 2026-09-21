# AWS Authentication & Profile Management Guide / AWS認証・プロファイル管理ガイド

本ドキュメントでは、SREワークステーションにおける AWS の認証情報管理および、複数アカウント・複数リージョン間での**「破壊的オペレーションの抑止（Safety First）」**を実現するためのプロファイル管理方針を定義します。

---

## 1. 認証設計の哲学

AWS運用において、最大の事故原因は「今どの権限で、どの環境（ステージ・リージョン）を叩いているか分からないこと」にあります。
本リポジトリでは以下の原則を徹底します。

1. **長期クレデンシャルの排除**: 原則としてルートアカウントや強権限の長期アクセスキーを直接 `~/.aws/credentials` にベタ書きしない。
2. **プロファイル名の明文化**: 本番 (`prod`)、ステージング (`stg`)、開発 (`dev`) を一目で識別できるようにする。
3. **動的な切り替えと可視化**: `fzf` と連携したセレクター (`asp`) を用い、作業時に必ずプロファイルを選択・確認させる。

---

## 2. ディレクトリ構造と設定ファイル

AWS CLI の設定は、以下のファイルで厳格に管理します。

- `~/.aws/config`: プロファイルごとのリージョンや出力フォーマットの定義
- `~/.aws/credentials`: アクセスキーやセッショントークンの保管（必要に応じて IAM Identity Center や AssumeRole を活用）

### 設定ファイルのパーミッション管理（重要）
他者や不正なプロセスからの読み取りを防ぐため、以下のパーミッションを厳守してください。

```bash
chmod 700 ~/.aws
chmod 600 ~/.aws/config
chmod 600 ~/.aws/credentials
```

## 3. 設定例 (`~/.aws/config`)

環境ごとに名前空間を明確にしたプロファイル定義のサンプルです。

```ini
[profile dev-workload]
region = ap-northeast-1
output = json

[profile stg-workload]
region = ap-northeast-1
output = json

[profile prod-workload]
region = ap-northeast-1
output = json
```

## 4. `asp` (AWS Profile Switcher) による安全な切り替え

ターミナル（zsh）上で、現在のシェルセッションに適用する AWS プロファイルを目視確認しながら安全に切り替えるため、以下のスクリプトを `~/.zshrc` に導入します（環境構築ガイドで導入済み）。

```bash
# AWS Profile Switcher (fzf integration)
asp() {
  local profile
  profile=$(aws configure list-profiles | fzf --prompt="Select AWS Profile [Safety First] > ")
  if [ -n "$profile" ]; then
    export AWS_PROFILE="$profile"
    echo "=========================================="
    echo " Switched to AWS Profile: $AWS_PROFILE"
    echo " Current Region         : ${AWS_REGION:-ap-northeast-1}"
    echo "=========================================="
  fi
}
```

### 使い方
ターミナルで `asp` コマンドを実行すると、`fzf` が起動して登録済みプロファイルの一覧が表示されます。矢印キーで選択して Enter を押すことで、誤認を防ぎながら確実にターゲット環境を切り替えることができます。

---

## 5. 現在の認証状態の確認

作業前および作業中には、必ず以下のコマンドを実行して意図したプロファイル・権限で接続されているかを確認してください。

```bash
aws sts get-caller-identity
```

**確認項目:**
- `Arn` が想定通りの IAM ユーザー / ロールになっているか
- 予期せぬ本番環境の権限になっていないか

---

## 6. セキュリティ上の注意事項

- **画面共有・スクショ時の注意**: `aws sts get-caller-identity` の出力やターミナルのプロンプト（Starship等でAWSプロファイルを表示している場合）には機密情報が含まれる可能性があります。共有時は十分に注意してください。
- **環境変数の汚染防止**: スクリプト等で `AWS_ACCESS_KEY_ID` や `AWS_SECRET_ACCESS_KEY` を直接エクスポートして放置しないこと。



