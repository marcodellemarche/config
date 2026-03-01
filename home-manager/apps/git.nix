{ ... }:
{
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
