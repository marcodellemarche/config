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
  home.packages = with pkgs; [
    neofetch
    slack
    brave
    vscode
    dbeaver-bin
    vim
    curl
    bazel_7
    direnv
    go
    go-task
    kind
    ctlptl
    tilt
    kubectl
    kubernetes-helm
    k9s
    obsidian
    awscli2
    zsh
    fzf
    gimp
    postgresql_15
    google-cloud-sdk
    gh
    jq
    yq
    pwgen
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      # update = "sudo nixos-rebuild switch";
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
      # a = "add";
      # c = "commit";
      # ca = "commit --amend";
      cane = "commit --amend --no-edit";
      # cl = "clone";
      # cm = "commit -m";
      # co = "checkout";
      # cp = "cherry-pick";
      # cpx = "cherry-pick -x";
      # d = "diff";
      # f = "fetch";
      # fo = "fetch origin";
      # fu = "fetch upstream";
      # lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      # lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      # pl = "pull";
      # pr = "pull -r";
      # ps = "push";
      # psf = "push -f";
      # rb = "rebase";
      # rbi = "rebase -i";
      # r = "remote";
      # ra = "remote add";
      # rr = "remote rm";
      # rv = "remote -v";
      # rs = "remote show";
      # st = "status";
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
