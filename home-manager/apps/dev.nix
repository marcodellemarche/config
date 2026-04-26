{ lib, pkgs, pkgs-go, pkgs-rust, ... }:
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
    pkgs.gcc
    pkgs.gnumake
    pkgs.gh
    pkgs.bat
    pkgs.fd
    pkgs.ripgrep
    pkgs.btop

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
    # Rust toolchain via fenix (not pkgs.rustc etc.) so that rust-src is bundled
    # into the sysroot. rust-analyzer runs `rustc --print sysroot` to locate the
    # stdlib source — it must live at $sysroot/lib/rustlib/src/rust/library.
    # Individual nixpkgs packages omit rust-src, breaking rust-analyzer in GUI
    # apps like VSCode that don't inherit shell session variables.
    (pkgs-rust.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pkgs-rust.rust-analyzer
    pkgs.jdk17
    pkgs.glib   # gsettings — necessario per android-studio FHS sandbox
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
    pkgs.sqlite
    pkgs.coder
    pkgs.gimp
    pkgs.vlc
    pkgs.fastfetch
    pkgs.wireshark
    pkgs.uv
    pkgs.claude-code
    pkgs.gemini-cli
    pkgs.yt-dlp
    (pkgs.tesseract.override { enableLanguages = [ "eng" "ita" ]; })
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    pkgs.dbeaver-bin
  ];

}
