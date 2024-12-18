zmodload zsh/zprof
export ZSH="$HOME/.oh-my-zsh"

# Preferences
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
ENABLE_CORRECTION="true"
HYPHEN_INSENSITIVE="true"
ZSH_THEME="agnoster"    # or: arrow, duellj, headline, powerline
DEFAULT_USER="radix"

plugins=(
  git
  dotenv
)

# https://stackoverflow.com/questions/62931101/i-have-multiple-files-of-zcompdump-why-do-i-have-multiple-files-of-these
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# No more brew :(
# source /usr/local/brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# eval "$(/usr/local/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_USER_CONFIG_HOME="$HOME/.config"
export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1

source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/sbin:$PATH"
export PATH="/Users/radix/Library/Python/3.9/bin:$PATH"

# coc for vim requires node/nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
zstyle ':omz:plugins:nvm' lazy yes

# https://stackoverflow.com/a/45217291
function cd() {
  if [[ -d ./.venv ]] ; then
    deactivate
  fi

  builtin cd $1

  if [[ -d ./.venv ]] ; then
    . ./.venv/bin/activate
  fi
}

zprof
