{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.utilities;

in {
  options.modules.utilities = { enable = mkEnableOption "utilities";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      btop
      neofetch
      pulsemixer
      sxiv
      zathura
      khal
      exiftool
      wget
      curl
      xwallpaper
      fzf
      ripgrep
      ranger
      xfce.thunar
    ];
  };
}
