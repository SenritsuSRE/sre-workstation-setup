
# `.zshrc` サンプル

```zsh
# ~/.zshrc

# 1. Path & Environment Variables
export PATH="$HOME/.local/bin:$PATH"

# Homebrew PATH (macOS / Linux)
if [[ -d /opt/homebrew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 2. Prompt (Starship)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# 3. Fuzzy Finder (fzf)
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
elif command -v fzf &> /dev/null; then
    source <(fzf --zsh)
fi

# 4. AWS Profile Selector (asp)
asp() {
    local profile
    profile=$(aws configure list-profiles | fzf --prompt="AWS Profile > ")
    if [[ -n "$profile" ]]; then
        export AWS_PROFILE="$profile"
        echo "Switched to AWS Profile: $AWS_PROFILE"
        aws sts get-caller-identity --query "Arn" --output text
    fi
}

# 5. Aliases & Safety
alias tf="terraform"
alias k="kubectl"
alias ll="ls -la"
```

