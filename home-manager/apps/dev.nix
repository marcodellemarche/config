{ pkgs, pkgs-go, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = [
    pkgs.vim
    pkgs.curl
    pkgs.xclip
    pkgs.jq
    pkgs.yq
    pkgs.pwgen
    pkgs.gnumake
    pkgs.gh

    pkgs.go-task
    pkgs.go-swag
    pkgs.bazel-buildtools
    # Bazel wrapper: exposes `bazel` in PATH backed by bazelisk
    (pkgs.writeShellScriptBin "bazel" "exec ${pkgs.bazelisk}/bin/bazelisk \"$@\"")
    pkgs-go.go_1_24
    (pkgs.python312.withPackages (ps: with ps; [
      pip
      matplotlib
    ]))
    pkgs.rustc
    pkgs.cargo
    pkgs.clippy
    pkgs.rustfmt
    pkgs.rust-analyzer
    pkgs.nodejs
    pkgs.kubectl
    pkgs.kind
    pkgs.ctlptl
    pkgs.tilt
    pkgs.kubernetes-helm
    pkgs.k9s
    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.postgresql_15
    pkgs.redis
    pkgs.dbeaver-bin
    pkgs.coder
    pkgs.gimp
    pkgs.vlc
    pkgs.neofetch
    pkgs.wireshark
    pkgs.claude-code
  ];

}
