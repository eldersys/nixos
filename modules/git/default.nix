{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.git;

in {
    options.modules.git = { enable = mkEnableOption "git"; };
    config = mkIf cfg.enable {

        programs.git = {
            enable = true;
            userName = "Iohannes Mboumba";
            userEmail = "iohannes.mboumba@protonmail.com";
            extraConfig = {
                init = { defaultBranch = "master"; };
            };

	    lfs = {
	    	enable = true;
	    };
        };

	programs.lazygit = { 
	    enable = true;
	};
    };
}
