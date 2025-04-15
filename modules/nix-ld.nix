{lib, config, pkgs, ...}:
with lib; 
let cfg = config.nix-ld; in {
  options = {
    nix-ld = {
      enable = mkEnableOption "enable nix-ld module";
    };
  };
  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        alsa-lib
        at-spi2-atk
        cairo
        cups.lib
        dbus.lib
        expat
        glib
        libdrm
        libgbm
        libxkbcommon
        nspr
        nss_latest
        pango
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxcb
        xorg.libXcursor
        libGL
        xorg.libXi
        glfw
        xorg.libX11.dev
        gtk3
        vulkan-loader
      ];
    };
  };
}
