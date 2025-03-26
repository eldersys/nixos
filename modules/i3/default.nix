{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.i3;

in {
  options.modules.i3 = { enable = mkEnableOption "i3";};

  config = mkIf cfg.enable {
    home.file.".config/i3/config".source = ./config;
  };
}
