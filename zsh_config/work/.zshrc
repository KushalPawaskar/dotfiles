# =================================================================================
# 1. CORE CONFIGURATION
# =================================================================================
# Set shell language variables
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


# =================================================================================
# 2. PATH MANAGER INITIALIZATION
#    Prepend directories to PATH so they are found first.
# =================================================================================

# Homebrew (Keep this at the top to ensure Homebrew executables are preferred)
export PATH=/opt/homebrew/bin:$PATH

# Temurin Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Teleport (Keep the latest version first)
export PATH=/opt/teleport/17.5.2:$PATH

# NVM (Node Version Manager)
# This block dynamically sets the Node PATH.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                         # . is the POSIX compliant way of source

# RVM (Ruby Version Manager)
export rvm_path="$HOME/.rvm"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_AVD_HOME="$HOME/.android/avd"
ANDROID_PATHS="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$ANDROID_PATHS:$PATH"

# Custom Environment File
. "$HOME/.local/bin/env"

# Google Cloud SDK
if [ -f "$HOME/installs/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/installs/google-cloud-sdk/path.zsh.inc"; fi


# =================================================================================
# 3. CUSTOM OH-MY-ZSH BASED SETUP
#    Do this after setting up PATH and before enabling specific shell completions
# =================================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gallois"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh


# =================================================================================
# 4. ALIASES
#    Add to $ZSH/custom/aliases.zsh
# =================================================================================


# =================================================================================
# 5. SHELL COMPLETIONS / KEYBINDINGS
# =================================================================================

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# nvm/rvm (disown to load in background asynchronously after prompt appears to shave off startup time penalty)
{
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    [[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion
} &!

# uv/uvx
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# ty
eval "$(ty generate-shell-completion zsh)"

# ruff
eval "$(ruff generate-shell-completion zsh)"

# gcloud
if [ -f "$HOME/installs/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/installs/google-cloud-sdk/completion.zsh.inc"; fi


# =================================================================================
# 6. MISCELLANEOUS
# =================================================================================

# iterm2 shell integration
test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh || true

# wezterm shell integration (semantic zones are handled below to avoid venv prompt conflicts)
WEZTERM_SHELL_SKIP_SEMANTIC_ZONES=1
. /Applications/WezTerm.app/Contents/Resources/wezterm.sh

# OSC 133 semantic zone markers for wezterm.
# Injected here rather than in the gallois theme to keep the theme file untouched.
# These override the theme's precmd/preexec to wrap them with zone markers, and
# append the 133;B (end-of-prompt) marker to PROMPT so it lands after any venv prefix.
__wezterm_sz_executing=""
__orig_gallois_precmd=$functions[precmd]
__orig_gallois_preexec=$functions[preexec]

function precmd() {
    local ret="$?"
    if [[ -n "$__wezterm_sz_executing" ]]; then
        printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi
    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    __wezterm_sz_executing=0
    eval "$__orig_gallois_precmd"
}

function preexec() {
    eval "$__orig_gallois_preexec"
    printf "\033]133;C;\007"
    __wezterm_sz_executing=1
}

PROMPT='$custom_prompt%{$(printf "\033]133;B\007")%}'


fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
