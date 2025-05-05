# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # include NixOS-WSL modules
    # <nixos-wsl/modules>
    inputs.nixos-wsl.nixosModules.default
    ../../modules/main-user.nix
    ../../modules/programs.nix
    ../../modules/tmux.nix
    ../../modules/nix-ld.nix
  ];
  progs = {
    enable = true;
    graphical = true;
    programming.enable = true;
    kube.enable = true;
  };
  main-user.enable = true;
  environment.enableDebugInfo = true;
  # For home manager
  programs.dconf.enable = true;
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "${config.main-user.userName}" = import ../../users/robin.nix;
    };
    backupFileExtension = "bak";
  };
  tmux.enable = true;
  nix-ld.enable = true;
  nixpkgs.config.allowUnfree = true;

  documentation.dev.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_CH.UTF-8";

  wsl.enable = true;
  virtualisation.docker.enable = true;
  wsl.defaultUser = config.main-user.userName;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  systemd.user.services."link-wayland-socket" = {
    description = "Link wayland-0 to user runtem dir";
    after = ["user-runtime-dir@.service"];
    wantedBy = ["default.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ln -sfv /mnt/wslg/runtime-dir/wayland-0* $XDG_RUNTIME_DIR/
      '';
    };
  };
}
