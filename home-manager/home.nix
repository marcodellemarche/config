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
    pkgs.lmstudio
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    pkgs.slack
    pkgs.brave
    pkgs.obsidian
    pkgs.google-chrome
    pkgs.android-studio
    pkgs.hypnotix
    pkgs.jetbrains.rust-rover
  ];

  # These cursor things maybe are not needed
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  # Add ~/.opencode/bin and Android SDK tools to PATH
  home.sessionPath = [
    "/home/${username}/.opencode/bin"
    "/home/${username}/Android/Sdk/platform-tools"
    "/home/${username}/Android/Sdk/emulator"
  ];

  home.sessionVariables = {
    ANDROID_HOME = "/home/${username}/Android/Sdk";
  };

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
    google-chrome = {
      name = "Google Chrome";
      genericName = "Web Browser";
      exec = "google-chrome-stable --no-sandbox %U";
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
      icon = "google-chrome";
      settings.StartupWMClass = "Google-chrome";
    };
    obsidian = {
      name = "Obsidian";
      genericName = "Text Editor";
      exec = "obsidian --no-sandbox %U";
      terminal = false;
      categories = [ "Utility" ];
      mimeType = [ "text/html" "text/xml" "x-scheme-handler/obsidian" ];
      icon = "obsidian";
      settings.StartupWMClass = "Obsidian";
    };
    lm-studio = {
      name = "LM Studio";
      genericName = "Local LLM Interface";
      exec = "lm-studio --no-sandbox";
      terminal = false;
      categories = [ "Utility" ];
      mimeType = [ ];
      icon = "lm-studio";
    };
    android-studio = {
      name = "Android Studio";
      genericName = "IDE";
      exec = "android-studio";
      terminal = false;
      startupNotify = true;
      categories = [ "Development" "IDE" ];
      mimeType = [ ];
      icon = "android-studio";
    };
    rustrover = {
      name = "RustRover";
      genericName = "IDE";
      exec = "rust-rover";
      terminal = false;
      startupNotify = true;
      categories = [ "Development" "IDE" ];
      mimeType = [ ];
      icon = "rustrover";
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
      "x-scheme-handler/obsidian" = "obsidian.desktop";
    };
  };

  xdg.configFile."mimeapps.list".force = true;

  home.file.".claude/statusline-command.sh" = {
    source = ./config/statusline-command.sh;
    executable = true;
  };
}
