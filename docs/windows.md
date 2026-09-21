# Windows Setup Guide / Windows 環境構築ガイド

本ドキュメントでは、Windows 11 上で「Linux First」「Safety First」なSRE開発環境を構築するための手順を定義します。
Windows Terminal と WSL2（Ubuntu 24.04 LTS）を基盤とし、シェル、プロンプト、AWS CLI、AIツール群を網羅した環境を構築します。

---

## 1. 前提条件の確認

- **OS**: Windows 11（推奨）
- **権限**: 管理者権限（Administrator）を持つユーザーアカウント
- **仮想化**: BIOS / UEFI で仮想化支援機能（Intel VT-x / AMD-V）が有効化されていること

---

## 2. WSL2 および Ubuntu 24.04 LTS のインストール

PowerShell を**管理者として実行**し、以下のコマンドを実行します。

```powershell
wsl --install -d Ubuntu-24.04
```

- インストール完了後、再起動が求められた場合はPCを再起動してください。

- 再起動後、Ubuntu の初期ユーザー名とパスワードの設定画面が立ち上がるため、任意のユーザー名・パスワードを設定します。

## 3. Windows Terminal の設定

Windows Terminal を起動し、デフォルトのシェルが WSL2 (Ubuntu 24.04 LTS) になっていることを確認します。
必要に応じて、配色の調整やフォント（Powerline対応フォントなど）の設定を行ってください。

## 4. Ubuntu 内部環境のセットアップ
以降の作業はすべて WSL2 (Ubuntu 24.04 LTS) のターミナル内で行います。

### 4.1. パッケージの更新

```powershell
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential unzip
```







