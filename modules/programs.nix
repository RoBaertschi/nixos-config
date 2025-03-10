{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    progs = {
      enable = lib.mkEnableOption "enable the program module";
      graphical = lib.mkOption { description = "disable the graphical applications"; default = false; };
      programming = {
        enable = lib.mkEnableOption "install programming programs";
      };
      kube = {
        enable = lib.mkEnableOption "install minikube and kubectl";
      };
    };
  };
  config = lib.mkIf config.progs.enable {
    programs.steam.enable = !config.progs.graphical;
    environment.systemPackages = with pkgs;
      lib.mkMerge [
        [
          # Nix config
          alejandra

          wget
          unzip
          jq
          file
          fastfetch

          neovim
        ]
        (lib.mkIf (!config.progs.graphical) [
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

          pkgs.equibop
        ]
        )
        (lib.mkIf (config.progs.programming.enable) [
          # C/C++
          gcc
          gnumake

          # Languages
          rustup
          bun
          nodejs_23
          go
          python3
          zig

          # Utils
          git
          lazygit
          gh
          fzf
          ripgrep
        ])
        (lib.mkIf (config.progs.kube.enable) [
          minikube
          kubectl
        ])
      ];
    programs.neovim = lib.mkIf config.progs.programming.enable {
      enable = true;
      defaultEditor = true;
    };
  };
}
