{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.comp-graphics;

in {
  options.modules.comp-graphics = { enable = mkEnableOption "comp-graphics";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
      renderdoc
    ];
  };
}
