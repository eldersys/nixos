{ config, pkgs, ... }:

{
  home.stateVersion = "24.05"; # Please read the comment before changing.
  imports = [

    # Services
    ./i3
    ./build

    # CLI 
    # ---
    ./zsh
    ./tmux 
    ./git
    ./archive
    ./nvim

    # GUI
    # ---
    ./gaming
    ./libreoffice
    ./design-tools
    ./obsidian
    ./video
    ./game-engines
    ./comp-graphics
    ./firefox
    ./chrome
    ./kitty
  ];
}
