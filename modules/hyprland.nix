{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; {
  options = {
    imports = [./main-user.nix];
    hyprland = {
      enable = mkEnableOption "enable hyprland module";
    };
  };
  config = mkIf config.hyprland.enable {
    environment.systemPackages = with pkgs; [
      (python3.withPackages (pp: [pp.pygobject3 pp.rich pp.pydbus pp.typer]))
      python3Packages.pygobject3
      gobject-introspection
      playerctl
    ];
    home-manager = {
      users = {
        "${config.main-user.userName}" = {
          # wayland.windowManager.hyprland.enable = true;
          home = {
            file = (import ../configs {}).hyprland;
            packages = with pkgs; [
              hyprland

              hyprpaper

              hypridle
              swaylock
              # The font is required for swaylock
              nerd-fonts.jetbrains-mono

              # Bar
              waybar

              # Keyboard
              kanata

              # drun and emoji selector
              fuzzel
              bemoji

              # Audio Controll
              wireplumber

              # Polkitagent
              hyprpolkitagent

              # Clipboard
              wl-clipboard
              cliphist

              # Notifications
              mako

              # nm-applet
              networkmanagerapplet

              # Cursor theme
              bibata-cursors

              playerctl
            ];
          };
        };
      };
    };
  };
}
