# macOS Setup Guide / macOS 環境構築ガイド

本ドキュメントでは、macOS 上で「Linux First」「Safety First」なSRE開発環境を構築するための手順を定義します。
Homebrew を基盤とし、シェル、プロンプト、AWS CLI、AIツール群を網羅した一貫性のある環境を構築します。

---

## 1. 前提条件の確認

- **OS**: macOS（Apple Silicon / Intel 対応）
- **権限**: ソフトウェアのインストールが可能な管理者アカウント
- **開発ツール**: Xcode Command Line Tools がインストールされていること

---

## 2. Xcode Command Line Tools のインストール

ターミナルを開き、以下のコマンドを実行してコマンドラインツールをインストールします。

```bash
xcode-select --install
```

(ポップアップが表示されるため、インストールを完了させてください)

## 3. Homebrew のインストール

macOSのパッケージマネージャーである Homebrew をインストールします。

```bash
/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
```

インストール完了後、指示に従ってパスを通します（Apple Silicon / Intel Mac共通）。

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 4. 各種ツール・環境のセットアップ

以降の作業はすべて zsh（ターミナル） 上で行います。

### 4.1. 基本パッケージのインストール (Homebrew経由)

```bash
brew update
brew install git curl unzip zsh starship fzf node
```

### 4.2. zsh のデフォルトシェル確認

macOSのデフォルトシェルはすでに zsh ですが、念のため確認・設定します。

```bash
chsh -s $(which zsh)
```

### 4.3. Starship (プロンプト) の設定

`~/.zshrc` に以下を追記して Starship を有効化します。

```bash
eval "$(starship init zsh)"
```

### 4.4. fzf (ファジーファインダー) のキーバインド・補完設定

```bash
# fzf のキーバインドとパス補完を有効化
$(brew --prefix)/opt/fzf/install --all
```

### 4.5. AWS Profile Switcher (asp) の導入

複数アカウント・複数リージョンを安全に切り替えるため、fzf を活用したカスタム関数を ~/.zshrc に定義します。

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
brew install awscli
```

### 4.7. AWS CDK & Biome のインストール

```bash
npm install -g aws-cdk typescript @biomejs/biome
```

### 4.8. Claude Code のインストール

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

