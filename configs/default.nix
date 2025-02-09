{...}: {
  hyprland = {
    ".config/hypr/hyprland.conf".source = ./hypr/hyprland.conf;
    ".config/hypr/hypridle.conf".source = ./hypr/hypridle.conf;
    ".config/hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;
    ".config/hypr/wallpaper1.png".source = ./hypr/wallpaper1.png;
    ".config/fuzzel/fuzzel.ini".source = ./fuzzel.ini;
    ".config/hypr/ac.py".source = ./ac.py;
    ".config/waybar/".source = ./waybar;
    ".config/kanata/config.kbd".source = ./config.kbd;
    ".config/mako/config".source = ./mako/config;
  };
  alacritty = {
    ".config/alacritty.toml".source = ./alacritty.toml;
    ".config/alacritty".source = ./alacritty;
  };
}
