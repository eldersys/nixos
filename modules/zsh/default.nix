{pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.zsh;

in {
  options.modules.zsh = {enable = mkEnableOption "zsh";};

  config = mkIf cfg.enable {
    home.packages = [pkgs.zsh];

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        edit = "sudo -e";
        update = "sudo nixos-rebuild switch --flake /home/iohannes/.config/nixos/ --fast";
        clean-old = "sudo nix-collect-garbage --delete-old";
      };

      initExtra = ''
      	  neofetch --crop-mode fit --kitty ~/Pictures/Wallpapers/Portrait/
	  export CHROME_EXECUTABLE=/etc/profiles/per-user/iohannes/bin/google-chrome-stable
	'';

      history = {
        save = 10000;   
        size = 10000;   
        path = "$HOME/.zsh_history";
        #history.ignoreAllDups = true;
        #history.ignorePatterns = ["rm *" "pkill *" "cp *"];
      };
      
      oh-my-zsh = {
	enable = true;
	plugins = ["git"];
	theme = "gozilla";
      };
    };
  };
}
