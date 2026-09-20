set -U fish_greeting

set -gx NVM_DIR $HOME/.nvm
set -U nvm_default_version lts

set -xU EDITOR nvim
set -xU VISUAL nvim
set -gx QT_QPA_PLATFORMTHEME qt6ct

if status is-interactive
    alias ls "lsd -la"
    alias tree "lsd --tree"
    alias v "nvim"
    alias cat "bat"
    alias pn "pnpm"
    alias qwen "ollama run qwen2.5-coder:7b-q5-8k"
    alias lg "lazygit"
    alias damxInstall "sudo LLVM=1"
    alias tclock "tty-clock -C 2 -s -S -c"
    alias dots "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
end

nvm use $nvm_default_version >/dev/null 2>/dev/null

starship init fish | source
zoxide init fish | source
fastfetch

set -gx ANTHROPIC_AUTH_TOKEN ollama
set -gx ANTHROPIC_BASE_URL http://localhost:11434
set -gx ANTHROPIC_API_KEY ""
