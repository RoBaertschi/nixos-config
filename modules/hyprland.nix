{ lib, pkgs, ... }:

with lib; {
  options = {
    imports = [./main-user.nix];
    hyprland = {
      enable = mkEnableOption "enable hyprland module";
    };
    config = mkIf config.hyprland.enable {
      home-manager = {
        users = {
          "${main-user.userName}" = {
            home = {
              file = {
                ".config/hypr/hyprland.conf".source = ../hypr/hyprland.conf;
                ".config/hypr/hypridle.conf".source = ../hypr/hypridle.conf;
                ".config/hypr/hyprpaper.conf".source = ../hypr/hyprpaper.conf;
                ".config/fuzzel/fuzzel.ini".source = ../hypr/fuzzel.ini;
                ".config/hypr/ac.py".source = ../hypr/ac.py;
                ".config/waybar/".source = ../waybar;
                ".config/kanata/config.kbd".source = ../hypr/config.kbd;
                ".config/mako/config".source = ../mako/config;
              };
            };
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

              # Programs referenced in the hyprland.conf file
              godot_4-mono
              python313
              python313Packages.typer
              python313Packages.rich
              python313Packages.pydbus
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
              rose-pine-cursor

              playerctl

              inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
            ];
          };
        };
      };
    };
  };
}
