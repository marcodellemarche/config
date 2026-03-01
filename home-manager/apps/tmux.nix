{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 5000;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      prefix-highlight
      cpu
      sidebar
    ];

    extraConfig = ''
      # Status bar at top
      set -g status-position top
      set -g status-style 'bg=black fg=green'
      set -g status-left '[#{session_name}] '
      set -g status-right '#{prefix_highlight} #{cpu_bg_color}RAM: #{ram_percentage} CPU: #{cpu_percentage}#{cpu_fg_color} | %H:%M %d-%b-%Y'
      set -g status-right-length 60

      # Open new windows/panes in current path
      bind c new-window -c '#{pane_current_path}'
      bind '"' split-window -v -c '#{pane_current_path}'
      bind % split-window -h -c '#{pane_current_path}'

      # Vi copy mode bindings
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
    '';
  };
}
