{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.build;

in {
  options.modules.build = { enable = mkEnableOption "build";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
    scons
    ];
  };
}
