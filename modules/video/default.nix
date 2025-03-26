{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.video;

in {
  options.modules.video = { enable = mkEnableOption "video";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpv
      ani-cli
    ];
  };
}
