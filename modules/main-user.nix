{
  lib,
  config,
  pkgs,
  ...
}:
with lib.types; {
  options = {
    main-user = {
      enable = lib.mkEnableOption "enable user module";
      userName = lib.mkOption {
        type = types.str;
        default = "robin";

        description = ''
          username
        '';
      };
      description = lib.mkOption {
        type = types.str;
        default = "Robin Bärtschi";
        description = ''
          User Description
        '';
      };
    };
  };

  config = lib.mkIf config.main-user.enable {
    environment.systemPackages = with pkgs; [
      oh-my-zsh
    ];
    programs.zsh.enable = true;
    users.users.${config.main-user.userName} = {
      isNormalUser = true;
      description = config.main-user.description;
      extraGroups = ["networkmanager" "wheel" "audio" "video" "robin"];
      packages = with pkgs; [];
      shell = pkgs.zsh;
    };
  };
}
