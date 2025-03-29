{ config, lib, inputs, osConfig, ... }:

{
  imports = [ ../../modules/default.nix ../../utilities/default.nix ];
  config.modules = {
    
    i3.enable = true;
    nvidia.enable = false;
    
    zsh.enable = true;
    tmux.enable = true;
    git.enable = true;
    archive.enable = true;
    utilities.enable = true;
    kitty.enable = true;

    gaming.enable = false;
    video.enable = true;

    firefox.enable = true;
    chrome.enable = false;

    obsidian.enable = true;
    libreoffice.enable = false;

    design-tools.enable = false;
    comp-graphics.enable = false;
    game-engines.unity.enable = false;
    game-engines.godot.enable = true;
  };
}
