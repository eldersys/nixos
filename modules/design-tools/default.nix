{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.design-tools;

in {
  options.modules.design-tools = { enable = mkEnableOption "design-tools";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inkscape
      krita
      gimp
    ];
  };
}
