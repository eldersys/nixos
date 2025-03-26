{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.game-engines.unity;

in {
  options.modules.game-engines.unity = { enable = mkEnableOption "unity";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unityhub
    ];
  };
}
