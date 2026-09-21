# Infrastructure as Code (IaC) Operation & Security Guide / IaC運用・安全ガイド

本ドキュメントでは、SREワークステーションにおける IaC（Terraform, AWS CDK 等）の安全な設計、検証、およびデプロイメントの原則を定義します。

---

## 1. IaC 運用の基本哲学

インフラストラクチャをコードとして管理するにあたり、本リポジトリでは以下の原則を徹底します。

1. **Safety First (変更の可視化とレビュー)**: 適用前に必ず `plan`（変更差分）を出力し、意図しないリソースの削除や置換が含まれていないかを人間が厳格にレビューする。
2. **Least Privilege (最小権限の原則)**: デプロイを実行するIAMロールやユーザーには、そのワークロードに必要な最小限の権限のみを付与する。
3. **State Management (状態管理の厳格化)**: Stateファイルの破損や機密情報の露出を防ぐため、リモートバックエンド（Amazon S3 + DynamoDB等）での安全なロックと暗号化を前提とする。

---

## 2. 開発・検証のワークフロー

ローカル環境（WSL2 / macOS）からインフラを変更する際の標準的なフローです。

1. **プロファイルの切り替え**: `asp` コマンドを使用し、対象の環境（dev / stg / prod）の AWS プロファイルに確実に切り替える。
2. **静的検証 (Lint / Format)**: コードの品質を統一するため、フォーマッターやリンターを実行する。
   - Terraform の場合: `terraform fmt`, `tflint`
   - CDK の場合: `npm run lint`, Biome によるチェック
3. **変更差分の確認 (Plan)**:

   ```bash
   terraform plan -out=tfplan
   ```

変更内容（特に `-/+` や `-` のリソース）を細部まで目視確認する。
4. **適用の実行 (Apply)**:

   ```bash
   terraform apply tfplan
   ```

## 3. セキュリティ上の注意事項

- **シークレットのハードコード禁止**: APIキー、パスワード、秘密鍵などを IaC のコード内に直接記述しない。パラメータストア（AWS Systems Manager Parameter Store）や Secrets Manager、環境変数経由で動的に注入する設計にする。
- **機密情報の State ファイル対策**: Stateファイル（`terraform.tfstate` 等）には機密情報が含まれる場合があるため、ローカルへの平文保存や Git への誤コミットを絶対に避ける（`.gitignore` への確実な追加）。
- **破壊的変更の制御**: 本番環境におけるデータベースや永続ストレージに対して、`DeletionPolicy` や `lifecycle { prevent_destroy = true }` を適切に設定し、誤操作によるデータ損失を防ぐ。

---

## 4. トラブルシューティング

- **State のロック競合**: 複数メンバーまたはプロセスによる同時実行でロックが解除されない場合は、原因を調査した上で `force-unlock` を慎重に実行する。
- **認証エラー**: `aws sts get-caller-identity` を実行し、想定通りの権限でCLIおよびIaCツールが動作しているか再確認する。




