{ config, lib, pkgs, pkgs-go, users, ... }:
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

  home.username = "marcodellemarche";
  home.homeDirectory = "/home/marcodellemarche";
  home.stateVersion = "23.05";

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.slack
    pkgs.brave
    pkgs.vscode
    pkgs.obsidian
  ];

  # These cursor things maybe are not needed
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  # Add ~/.opencode/bin to PATH
  home.sessionPath = [ "/home/marcodellemarche/.opencode/bin" ];

  xdg.desktopEntries.brave-browser = {
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
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
    exec = "code --no-sandbox %F";
    terminal = false;
    startupNotify = true;
    categories = [ "Development" ];
    mimeType = [ "text/html" "text/xml" ];
    icon = "vscode";
    settings.StartupWMClass = "Code";
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
}
