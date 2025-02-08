# ml2 ts=2 sts=2
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/main-user.nix
    ../../modules/programs.nix
    ../../modules/hyprland.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    windows = {
      "windows" = {
        title = "Our Windows.";
        efiDeviceHandle = "HD0b"; # :EFI\\Microsoft\\Boot\\Bootmgfw.efi
      };
    };
    extraEntries = {
      "deezpc.conf" = ''
        title DEEZPC Arch
        efi /efi/edk2-uefi-shell/shell.efi
        options -nointerrupt -nomap -noversion BLK10:EFI\DEEZOS\grubx64.efi
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.flatpak.enable = true;

  networking.hostName = "deez-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_CH.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sg";

  # Modules
  progs = {
    enable = true;
    programming.enable = true;
  };
  main-user.enable = true;
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "${config.main-user.userName}" = import ../../users/robin.nix;
    };
    backupFileExtension = "bak";
  };
  hyprland.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  xdg.menus.enable = true;
  # xdg.configFile."menus/applications.menu".text = builtins.readFile ../../applications.menu;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
