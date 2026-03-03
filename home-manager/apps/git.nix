{ pkgs, ... }:
{
  home.packages = [ pkgs.delta ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    # Get your key ID with: gpg --list-secret-keys --keyid-format LONG
    signing = {
      key = "8D0459F290140A92";
      signByDefault = true;
    };

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
        rebase = true;
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
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        side-by-side = true;
      };
    };
    # Per-directory overrides (e.g. different email for work repos):
    # includes = [
    #   {
    #     condition = "gitdir:~/work/";
    #     contents.user.email = "marco@work.com";
    #   }
    # ];
  };
}
