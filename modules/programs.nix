{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    progs = {
      enable = lib.mkEnableOption "enable the program module";
      programming = {
        enable = lib.mkEnableOption "install programming programs";
      };
    };
  };
  config = lib.mkIf config.progs.enable {
    programs.steam.enable = true;
    environment.systemPackages = with pkgs;
      lib.mkMerge [
        [
          alejandra

          wget
          unzip
          jq

          fastfetch

          kitty
          alacritty
          firefox
          google-chrome
          pavucontrol

          kdePackages.dolphin
          pkgs.kdePackages.breeze
          pkgs.kdePackages.qtsvg
          pkgs.kdePackages.kdegraphics-thumbnailers
          pkgs.kdePackages.kio-extras
          pkgs.kdePackages.kservice
          neovim
        ]
        (lib.mkIf (config.progs.programming.enable) [
          # C/C++
          gcc
          gnumake

          # Languages
          rustup
          bun
          nodejs_23
          go

          # Utils
          git
          gh
          fzf
          ripgrep
        ])
      ];
    programs.neovim = lib.mkIf config.progs.programming.enable {
      enable = true;
      defaultEditor = true;
    };
  };
}
