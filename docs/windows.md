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

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential unzip
```

### 4.2. zsh のインストールとデフォルトシェルへの変更

```bash
sudo apt install -y zsh
chsh -s $(which zsh)
```

(一度ログアウトするか、ターミナルを再起動して zsh が有効になっていることを確認してください)

### 4.3. Starship (プロンプト) のインストール


sudo apt install -y zsh
chsh -s $(which zsh)
(一度ログアウトするか、ターミナルを再起動して zsh が有効になっていることを確認してください)

4.3. Starship (プロンプト) のインストール

```bash
curl -sS [https://starship.rs/install.sh](https://starship.rs/install.sh) | sh
```

`~/.zshrc` に以下を追記します。

```bash
eval "$(starship init zsh)"
```

### 4.4. fzf (ファジーファインダー) のインストール

```bash
git clone --depth 1 [https://github.com/junegunn/fzf.git](https://github.com/junegunn/fzf.git) ~/.fzf
~/.fzf/install --all
```

### 4.5. AWS Profile Switcher (asp) の導入

複数アカウント・複数リージョンを安全に切り替えるため、fzf を活用したカスタムスクリプト（または設定）を導入します。<br>
`~/.zshrc` に以下のようなプロファイル切り替え関数を定義します。

```bash
# AWS Profile Switcher (asp)
asp() {
  local profile
  profile=$(aws configure list-profiles | fzf --prompt="Select AWS Profile > ")
  if [ -n "$profile" ]; then
    export AWS_PROFILE="$profile"
    echo "Switched to AWS Profile: $AWS_PROFILE"
  fi
}
```

### 4.6. AWS CLI のインストール

```bash
curl "[https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip](https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip)" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
```

### 4.7. Node.js (LTS) のインストール (nvm経由)

```bash
curl -o- [https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh](https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh) | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" else printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts
```

### 4.8. AWS CDK & Biome のインストール

```bash
npm install -g aws-cdk typescript @biomejs/biome
```

### 4.9. Claude Code のインストール

```bash
npm install -g @anthropic-ai/claude-code
```

## 5. 動作確認（検証チェックリスト）

セットアップ完了後、ターミナルで以下のコマンドを実行し、すべてのバージョンと動作が正常であることを確認します。

```bash
git --version
aws --version
node --version
npm --version
zsh --version
starship --version
fzf --version
cdk --version
biome --version
claude --version
```






