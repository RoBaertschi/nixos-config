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
              # Programs referenced in the hyprland.conf file
              python313
              python313Packages.pygobject3
              python313Packages.typer
              python313Packages.rich
              python313Packages.pydbus
      gobject-introspection
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
