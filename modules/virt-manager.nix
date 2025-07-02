{
  pkgs,
  config,
  lib,
  ...
}: let cfg = config.virt-manager; in {
  options = {
    imports = [./main-user.nix];
    virt-manager = {
      enable = lib.mkEnableOption "enable virt-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [config.main-user.userName];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    networking.firewall.trustedInterfaces = ["virbr0" "vnet0"];
    home-manager.users."${config.main-user.userName}".dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
