{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.nvim;

in {
  options.modules.nvim = { enable = mkEnableOption "nvim";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
    	neovim
    ];

    home.file.".config/nvim/init.lua" = {
    	source = ./config/init.lua;
	recursive = true;
    };
  };
}
