{ config, lib, pkgs, users, ... }:

{
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
    pkgs.go
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
    pkgs.python311
    pkgs.vlc
    pkgs.nodejs
    pkgs.gnumake
    pkgs.coder
    pkgs.go-swag
    pkgs.python311Packages.matplotlib
  ];
  
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
      ll = "ls -l";
      home-reload = "nix run nixpkgs#home-manager -- switch --flake ~/nix/#$USER";
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
      theme = "robbyrussell";
    };
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
    icon = pkgs.fetchurl {
      url = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
      sha256 = "JTD4D98hRLYvlpU6gcaYjJwxpsx8necuBpB5SFgXy+c=";
    };
  };

  xdg.desktopEntries.slack = {
    name = "Slack";
    genericName = "Chat";
    exec = "slack --no-sandbox";
    terminal = false;
    categories = [ "Office" ];
    mimeType = [ ];
    icon = pkgs.fetchurl {
      url = "https://a.slack-edge.com/38f0e7c/marketing/img/nav/logo.svg";
      sha256 = "OmfD3MKhZV2fPqEFGBfEyISdgCOD5F3WzsG5EP+HSSI=";
    };
  };

  xdg.desktopEntries.code = {
    name = "Visual Studio Code";
    genericName = "Code Editor";
    exec = "code --no-sandbox";
    terminal = false;
    categories = [ "Development" ];
    mimeType = [ "text/html" "text/xml" ];
    icon = pkgs.fetchurl {
      url = "https://code.visualstudio.com/assets/branding/code-stable.png";
      sha256 = "esKeAM1m5UmswupqmagT+SyyOm0WUpO+aVmEVnDwxaQ=";
    };
  };
  
  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    genericName = "Text Editor";
    exec = "obsidian --no-sandbox";
    terminal = false;
    categories = [ "Utility" ];
    mimeType = [ "text/html" "text/xml" ];
    icon = pkgs.fetchurl {
      url = "https://obsidian.md/images/obsidian-logo-gradient.svg";
      sha256 = "EZsBuWyZ9zYJh0LDKfRAMTtnY70q6iLK/ggXlplDEoA=";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    # signing = {
    #   key = "5C841D3CFDFEC4E0";
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
    # includes = [
    #   # use different signing key
    #   {
    #     condition = "gitdir:~/work/";
    #     contents = {
    #       user = {
    #         name = "Jonathan Ringer";
    #         email = "jonathan.ringer@iohk.io";
    #         signingKey = "523B37EC8FB6E3A2";
    #       };
    #     };
    #   }
    #   # prevent background gc thread from constantly blocking reviews
    #   {
    #     condition = "gitdir:~/projects/nixpkgs";
    #     contents = {
    #       gc.auto = 0;
    #     };
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
