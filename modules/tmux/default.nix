{ pkgs, config, lib, ...}:
with lib;

let cfg = config.modules.tmux;

in {
  options.modules.tmux = { enable = mkEnableOption "tmux";};

  config = mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      shortcut = "a";
      newSession = true;
      clock24 = true;
      extraConfig = ''
        bind - split-window -h # Split panes horizontal
        bind | split-window -v # Split panes vertically
        set -g @resurrect-processes 'ssh psql mysql sqlite3'
        set -g @resurrect-strategy-nvim 'session'
        resurrect_dir=~/.local/share/tmux/resurrect
        set -g @resurrect-dir $resurrect_dir
        set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g' $(readlink -f $resurrect_dir/last)"
      '';
      plugins = [
      	pkgs.tmuxPlugins.vim-tmux-navigator
	pkgs.tmuxPlugins.resurrect
      ];
    };
  };
}
