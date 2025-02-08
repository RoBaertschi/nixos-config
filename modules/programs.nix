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
          pavucontrol
          dolphin
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
