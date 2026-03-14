{ config, lib, pkgs, pkgs-go, username, ... }:
{
  imports = [
    ./apps/tmux.nix
    ./apps/zsh.nix
    ./apps/git.nix
    ./apps/dev.nix
    ./apps/ssh.nix
    ./apps/gpg.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.05";

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.vscode
    pkgs.koreader
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    pkgs.slack
    pkgs.brave
    pkgs.obsidian
  ];

  # These cursor things maybe are not needed
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  # Add ~/.opencode/bin to PATH
  home.sessionPath = [ "/home/${username}/.opencode/bin" ];

  xdg.desktopEntries = {
    code = {
      name = "Visual Studio Code";
      genericName = "Code Editor";
      exec = "code --no-sandbox %F";
      terminal = false;
      startupNotify = true;
      categories = [ "Development" ];
      mimeType = [ "text/html" "text/xml" ];
      icon = "vscode";
      settings.StartupWMClass = "Code";
    };
  } // lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
    brave-browser = {
      name = "Brave Web Browser";
      genericName = "Web Browser";
      exec = "brave --no-sandbox %U";
      terminal = false;
      startupNotify = true;
      categories = [ "Network" "WebBrowser" ];
      mimeType = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "application/pdf"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];
      icon = "brave-browser";
      settings.StartupWMClass = "brave-browser";
    };
    slack = {
      name = "Slack";
      genericName = "Chat";
      exec = "slack --no-sandbox";
      terminal = false;
      categories = [ "Office" ];
      mimeType = [ ];
      icon = "slack";
    };
    obsidian = {
      name = "Obsidian";
      genericName = "Text Editor";
      exec = "obsidian --no-sandbox";
      terminal = false;
      categories = [ "Utility" ];
      mimeType = [ "text/html" "text/xml" ];
      icon = "obsidian";
    };
  };

  xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };
}
