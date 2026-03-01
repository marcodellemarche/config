{ config, lib, pkgs, pkgs-go, users, ... }:
{
  imports = [
    ./apps/tmux.nix
    ./apps/zsh.nix
    ./apps/git.nix
    ./apps/dev.nix
    ./apps/ssh.nix
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
}
