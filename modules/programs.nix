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
          fd

          neovim
        ]
        (lib.mkIf (!config.progs.graphical) [
          kitty
          alacritty
          firefox
          google-chrome
          pavucontrol

          prismlauncher
          appimage-run

          kdePackages.dolphin
          kdePackages.breeze
          kdePackages.qtsvg
          kdePackages.kdegraphics-thumbnailers
          kdePackages.kio-extras
          kdePackages.kservice

          equibop
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
          argocd
          kubectl
          kubernetes-helm
        ])
      ];
    programs.neovim = lib.mkIf config.progs.programming.enable {
      enable = true;
      defaultEditor = true;
    };
  };
}
