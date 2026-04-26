{ config, pkgs, ... }:
{
  home.file.".p10k.zsh".source = ../config/p10k.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      home-reload = "nix run nixpkgs#home-manager -- switch --flake ~/nix/#$USER";
      slack    = "slack --no-sandbox";
      brave    = "brave --no-sandbox";
      code     = "code --no-sandbox";
      obsidian = "obsidian --no-sandbox";
      chrome   = "google-chrome-stable --no-sandbox";
      ls  = "eza";
      ll  = "eza -l";
      la  = "eza -la";
      lt  = "eza --tree";
      cat = "bat";
      xcopy = "xclip -selection clipboard";
      xpaste = "xclip -o -selection clipboard";
      daily = "~/vault/scripts/new-daily.sh";
      daily-celeste = "~/vault/scripts/new-daily.sh celeste";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" ];
    };
    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
