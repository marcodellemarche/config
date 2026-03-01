{ config, lib, pkgs, pkgs-go, users, ... }:

{
  imports = [
    ./apps/tmux.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home.username = "marcodellemarche";
  home.homeDirectory = "/home/marcodellemarche";
  home.stateVersion = "23.05";
  home.packages = [
    pkgs.neofetch
    pkgs.slack
    pkgs.brave
    pkgs.vscode
    pkgs.dbeaver-bin
    pkgs.vim
    pkgs.curl
    pkgs.bazelisk
    pkgs.bazel-buildtools
    pkgs.direnv
    pkgs-go.go_1_24
    pkgs.go-task
    pkgs.kind
    pkgs.ctlptl
    pkgs.tilt
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.k9s
    pkgs.obsidian
    pkgs.awscli2
    pkgs.zsh
    pkgs.fzf
    pkgs.gimp
    pkgs.postgresql_15
    pkgs.google-cloud-sdk
    pkgs.gh
    pkgs.jq
    pkgs.yq
    pkgs.pwgen
    pkgs.redis
    (pkgs.python311.withPackages (ps: with ps; [
      pip
      matplotlib
    ]))
    pkgs.vlc
    pkgs.nodejs
    pkgs.gnumake
    pkgs.coder
    pkgs.go-swag
    pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  
  # These cursor things maybe are not needed
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.package = pkgs.vanilla-dmz;
  home.pointerCursor.name = "Vanilla-DMZ";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      home-reload = "home-manager switch --flake ~/nix/#$USER";
      bazel-reload = "cd ~/.nix-profile/bin; sudo ln -s bazelisk bazel; sudo chown -h $USER:$USER bazel";
      slack = "slack --no-sandbox";
      brave = "brave --no-sandbox";
      code = "code --no-sandbox";
      obsidian = "obsidian --no-sandbox";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
      ];
    };

    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # enableKeyBindings = true;
    # enableCompletion = true;
  };

  xdg.desktopEntries.brave = {
    name = "Brave Web Browser";
    genericName = "Web Browser";
    exec = "brave --no-sandbox";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" ];
    icon = "brave-browser";
  };

  xdg.desktopEntries.slack = {
    name = "Slack";
    genericName = "Chat";
    exec = "slack --no-sandbox";
    terminal = false;
    categories = [ "Office" ];
    mimeType = [ ];
    icon = "slack";
  };

  xdg.desktopEntries.code = {
    name = "Visual Studio Code";
    genericName = "Code Editor";
    exec = "code --no-sandbox";
    terminal = false;
    categories = [ "Development" ];
    mimeType = [ "text/html" "text/xml" ];
    icon = "code";
  };
  
  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    genericName = "Text Editor";
    exec = "obsidian --no-sandbox";
    terminal = false;
    categories = [ "Utility" ];
    mimeType = [ "text/html" "text/xml" ];
    icon = "obsidian";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    # To enable commit signing, get your key ID with:
    #   gpg --list-secret-keys --keyid-format LONG
    # Then uncomment:
    # signing = {
    #   key = "YOUR_KEY_ID";
    #   signByDefault = true;
    # };

    settings = {
      user = {
        name = "Marco Ferretti";
        email = "mferretti93@gmail.com";
      };
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      pull = {
        rebase=true;
      };
      alias = {
        cane = "commit --amend --no-edit";
        fap = "fetch -ap";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        rod = "rebase origin/develop";
        puf = "push --force";
        pr = "pull --rebase";
      };
      mergetool.prompt = "false";
      core.editor = "vim";
    };
    # Per-directory overrides (e.g. different email for work repos):
    # includes = [
    #   {
    #     condition = "gitdir:~/work/";
    #     contents.user.email = "marco@work.com";
    #   }
    # ];
  };

  # users.users.marcodellemarche.shell = pkgs.zsh;
  # home.sessionVariables.SHELL = pkgs.zsh;

  # Add ~/.opencode/bin to PATH
  home.sessionPath = [ "/home/marcodellemarche/.opencode/bin" ];

  # programs.gnome-terminal.profile.marcodellemarche.customCommand = "zsh";

  # home.shell = pkgs.zsh;
}
