{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.i3;

in {
  options.modules.nvidia = { enable = mkEnableOption "nvidia";};

  config = mkIf cfg.enable {
    hardware.nvidia = {
    	enable = true;
	driSupport = true;
    };

    service.xserver.VideoDrivers = ["nvidia"];

    hardware.nvidia = {
    	modesetting.enable = true;
	powerManagement.enable = false;
	powerManagement.finegrained = false;
	open = false;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
