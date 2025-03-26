{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.game-engines.godot;

in {
  options.modules.game-engines.godot = { enable = mkEnableOption "godot";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      godot_4
    ];
  };
}
