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

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Marco Ferretti";
    userEmail = "mferretti93@gmail.com";
    # signing = {
    #   key = "5C841D3CFDFEC4E0";
    #   signByDefault = true;
    # };
    aliases = {
      cane = "commit --amend --no-edit";
      fap = "fetch -ap";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      rod = "rebase origin/develop";
      puf = "push --force";
      pr = "pull --rebase";
    };
    extraConfig = {
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      pull = {
        rebase=true;
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

  # programs.gnome-terminal.profile.marcodellemarche.customCommand = "zsh";

  # home.shell = pkgs.zsh;
}
