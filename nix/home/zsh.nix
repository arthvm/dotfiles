{
  config,
  pkgs,
  ...
}: {
  enable = true;

  # Configuração do histórico
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

  # Aliases
  shellAliases = {
    # Utilitários gerais
    vim = "nvim";
    ls = "ls --color";
    please = "sudo";
    rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/nix#nixos";
  };

  # Configurações extras do Zsh
  initExtra = ''
    # Keybindings
    bindkey -e
    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward

    function clear-screen-and-scrollback() {
      builtin echoti civis >"$TTY"
      builtin print -rn -- $'\e[H\e[2J' >"$TTY"
      builtin zle .reset-prompt
      builtin zle -R
      builtin print -rn -- $'\e[3J' >"$TTY"
      builtin echoti cnorm >"$TTY"
    }
    zle -N clear-screen-and-scrollback
    bindkey '^x' clear-screen-and-scrollback

    # Configuração do tema Powerlevel10k
    [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}

    # Configuração do autocomplete
    zstyle ':completion:*:git-checkout:*' sort false
    zstyle ':completion:*:descriptions' format '[%d]'
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    zstyle ':completion:*' menu no

    # Pré-visualização com fzf-tab e eza
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:ls:*' fzf-preview 'cat $realpath'
    zstyle ':fzf-tab:*' switch-group '<' '>'

    # Shell integrations
    eval "$(fzf --zsh)"
    eval "$(zoxide init --cmd cd zsh)"
    eval "$(thefuck --alias)"

    # Pyenv config
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"

    # NVM (Node Version Manager)
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    # Go config
    export GOPATH=$(go env GOPATH)
    export GOBIN=$GOPATH/bin
    export PATH=$PATH:$GOBIN
  '';

  # Plugins do Oh-My-Zsh
  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "sudo"
      "golang"
      "kubectl"
      "kubectx"
      "rust"
      "command-not-found"
      "pass"
    ];
  };

  # Plugins Zsh adicionais
  plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
      file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "zsh-completions";
      src = pkgs.zsh-completions;
      file = "share/zsh-completions/zsh-completions.zsh";
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
      file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }
  ];
}
