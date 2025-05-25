{ config, lib, inputs, osConfig, ... }:

{
  imports = [ ../../modules/default.nix ../../utilities/default.nix ];
  config.modules = {
    
    i3.enable = true;
    
    zsh.enable = true;
    tmux.enable = true;
    git.enable = true;
    archive.enable = true;
    utilities.enable = true;
    kitty.enable = true;
    nvim.enable = true;

    gaming.enable = true;
    video.enable = true;

    firefox.enable = true;
    chrome.enable = true;

    obsidian.enable = true;
    libreoffice.enable = false;

    design-tools.enable = true;
    comp-graphics.enable = true;
    game-engines.unity.enable = true;
    game-engines.godot.enable = false;
  };
}
