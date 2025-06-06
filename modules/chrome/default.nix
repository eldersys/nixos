{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.chrome;

in {
  options.modules.chrome = { enable = mkEnableOption "chrome";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
