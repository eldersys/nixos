{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.archive;

in {
  options.modules.archive = { enable = mkEnableOption "archive";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zip
      unzip
      p7zip
      unrar
    ];
  };
}
