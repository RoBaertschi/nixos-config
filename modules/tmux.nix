{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.tmux;
in {
  options = {
    imports = [./main-user.nix];
    tmux = {
      enable = mkEnableOption "enable tmux module";
    };
  };
  config = mkIf cfg.enable {
    home-manager = {
      users = {
        "${config.main-user.userName}" = {
          programs.tmux = {
            enable = true;
            baseIndex = 1;
            clock24 = true;
            mouse = true;
            prefix = "C-Space";
            keyMode = "vi";
            extraConfig = ''
              bind -n M-H previous-window
              bind -n M-L next-window
              bind-key -T copy-mode-vi v send-keys -X begin-selection
              bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
              bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
              bind '"' split-window -v -c "#{pane_current_path}"
              bind % split-window -h -c "#{pane_current_path}"
            '';
            plugins = with pkgs; [
              tmuxPlugins.sensible
              tmuxPlugins.vim-tmux-navigator
              tmuxPlugins.yank
              tmuxPlugins.tokyo-night-tmux
            ];
          };
        };
      };
    };
  };
}
