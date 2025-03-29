{ config, pkgs, lib, inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;  
  
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  time.hardwareClockInLocalTime = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "intl";

  # Enable CUPS to print documents.

  services.printing = {
    enable = true;
    drivers = [pkgs.gutenprint];
    browsing = true;
    browsedConf =''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All
      BrowseProtocols all'';
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Enable sound.
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  
  # Resolved Service
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };

  # VPN
  services.openvpn.servers.vpn = {
    config = '' config /home/iohannes/.config/vpn/JP-Free.ovpn '';
    authUserPass.password = "qwhQ9CmEyelNGJghORcfYXOL6apFkfSf";
    authUserPass.username = "QHIu6Vw3UxuQOOkD";
    autoStart = false;
    updateResolvConf = true;
  };

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["iohannes"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;


  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull;
  #nixpkgs.config.pulseaudio = true;


  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot  
  hardware.xone.enable = true;
  services.blueman.enable = true;

 # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.iohannes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      keepassxc
      rofi
      zola
      vscode
    ];
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
    };
  environment.localBinInPath = true;

  environment.etc.openvpn.source = pkgs.update-resolv-conf;
    
  users.extraUsers.iohannes.extraGroups = ["audio" "adbusers" "kvm"];

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" 
  ];

  nix.extraOptions = ''
        trusted-users = root iohannes
    '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    android-studio
    devenv
    wget
    curl
    xorg.xorgserver
    xorg.xinit
    polybar
    picom
    xwallpaper
    gcc
    killall
    xorg.xmodmap
    xorg.xev
    fzf
    go
    ripgrep
    gnumake
    bruno
    dotnet-sdk
    bluetuith
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

 programs.zsh.enable = true;
 users.defaultUserShell = pkgs.zsh;

  programs.adb.enable = true;
  programs.steam = lib.mkIf (config.networking.hostName == "aegis") {
    enable = true;
    gamescopeSession = {
      enable = true;
    };
  }; 

  programs.gamemode = lib.mkIf (config.networking.hostName == "aegis") {
    enable = true;
  };
 
  # Nixvim config
 #programs.nixvim.plugins = {

 #   # Buffer bar
 #   bufferline = {
 #     enable = true;
 #   };

 #   # Status bar
 #   lualine = {
 #     enable = true;
 #   };

 #   # Includes all parsers for treesitter
 #   treesitter = {
 #     enable = true;
 #   };

 #   tmux-navigator.enable = true;

 #   # Icons 
 #   # web-devicons.enable = true;
 #   
 #   # Linting
 #   lint = {
 #     enable = true;
 #     lintersByFt = {
 #       text = ["vale"];
 #       json = ["jsonlint"];
 #       markdown = ["vale"];
 #       rst = ["vale"];
 #       dockerfile = ["hadolint"];
 #     };
 #   };

 #   # Good old Telescope
 #   telescope = {
 #     enable = true;
 #     extensions = {
 #       fzf-native = {
 #         enable = true;
 #       };
 #     };
 #     keymaps = {
 #       "<Space>ff" = {
 #         action = "find_files";
 #         options = {
 #           desc = "Fuzzy find a file";
 #         };
 #       };
 #       "<Space>fb" = {
 #         action = "buffers";
 #         options = {
 #           desc = "Find buffers";
 #         };
 #       };
 #       "<Space>fw" = {
 #         action = "grep_string";
 #         options = {
 #           desc = "Find word under cursor";
 #         };
 #       };
 #       "<Space>gc" = {
 #         action = "git_commits";
 #         options = {
 #           desc = "Search git commit";
 #         };
 #       };
 #     };

 #     settings = {
 #       defaults = {
 #         file_ignore_patterns = [
 #           "^.git/"
 #           "^.mypy_cache/"
 #           "^__pycache__/"
 #           "^output/"
 #           "^data/"
 #           "%.ipynb"
 #         ];
 #         layout_config = {
 #         prompt_position = "top";
 #       };

 #       mappings = {
 #         i = {
 #           "<A-j>" = {
 #             __raw = "require('telescope.actions').move_selection_next";
 #           };
 #           "<A-k>" = {
 #             __raw = "require('telescope.actions').move_selection_previous";
 #           };
 #         };
 #       };
 #       selection_caret = "> ";
 #       set_env = {
 #         COLORTERM = "truecolor";
 #       };
 #       sorting_strategy = "ascending";
 #     };
 #   };
 # };

 #   # Highlight word under cursor
 #   illuminate = {
 #     enable = true;
 #     underCursor = false;
 #     filetypesDenylist = [
 #       "Outline"
 #       "TelescopePrompt"
 #       "alpha"
 #       "harpoon"
 #       "reason"
 #     ];
 #   };

 #   # Dashboard
 #   alpha = {
 #     enable = true;
 #     theme = "dashboard";
 #     # iconsEnabled = true; # Deprecated
 #   };

 #   # Nix expressions in Neovim
 #   nix = {
 #     enable = true;
 #   };

 #    # Language server
 #   lsp = {
 #     enable = true;
 #     servers = {
 #       # Average webdev LSPs
 #       #tsserver.enable = true; # TS/JS
 #       cssls.enable = true; # CSS
 #       html.enable = true; # HTML
 #       dartls.enable = true;
 #       pyright.enable = true; # Python
 #       marksman.enable = true; # Markdown
 #       nixd.enable = true; # Nix
 #       dockerls.enable = true; # Docker
 #       bashls.enable = true; # Bash
 #       clangd.enable = true; # C/C++
 #       csharp_ls.enable = true; # C#
 #       yamlls.enable = true; # YAML
 #       #gdscript.enable = true; # GDScript 
 #       #gdshader_lsp.enable = true; # Godot Shader language
 #       gopls = { # Golang
 #         enable = true;
 #         autostart = true;
 #       };

 #       lua_ls = { # Lua
 #         enable = true;
 #         settings.telemetry.enable = false;
 #       };

 #     };
 #   };

 #   luasnip = {
 #     enable = true;
 #     fromSnipmate = [
 #       {
 #         paths = "$\{HOME}/.vim-snippets/snippets/dart.snippets";
 #         include = [ "dart" ];
 #       }
 #       {
 #         paths = "$\{HOME}/.vim-snippets/snippets/dart-flutter.snippets";
 #         include = [ "dart" ];
 #       }
 #     ];
 #   };
 #   cmp = {
 #     enable = true;
 #     autoEnableSources = true;
 #     settings = {
 #       formatting = { fields = [ "kind" "abbr" "menu" ]; };
 #       sources = [
 #           {name = "nvim_lsp";}
 #           {name = "path";}
 #           {name = "buffer";}
 #           {name = "luasnip";}
 #         ];

 #       window = {
 #         completion = { border = "solid"; };
 #         documentation = { border = "solid"; };
 #       };

 #       mapping = {
 #         "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
 #         "<A-j>" = "cmp.mapping.select_next_item()";
 #         "<A-k>" = "cmp.mapping.select_prev_item()";
 #         "<A-e>" = "cmp.mapping.abort()";
 #         "<A-b>" = "cmp.mapping.scroll_docs(-4)";
 #         "<A-f>" = "cmp.mapping.scroll_docs(4)";
 #         "<C-Space>" = "cmp.mapping.complete()";
 #         "<CR>" = "cmp.mapping.confirm({ select = true })";
 #         "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
 #         "<C-l>" = ''
 #           cmp.mapping(function()
 #             if luasnip.expand_or_locally_jumpable() then
 #               luasnip.expand_or_jump()
 #             end
 #           end, { 'i', 's' })
 #         '';
 #         "<C-h>" = ''
 #           cmp.mapping(function()
 #             if luasnip.locally_jumpable(-1) then
 #               luasnip.jump(-1)
 #             end
 #           end, { 'i', 's' })
 #         '';
 #       };
 #       
 #       cmdline.luasnip.snippet.expand = "
 #         function(args)
 #           require('luasnip').lsp_expand(args.body)
 #         end
 #       ";

 #     };
 #   };
 # };

 # programs.nixvim.colorschemes.catppuccin = {
 #   enable = true;
 #   settings.flavour = "frappe";
 # };



  # Options
#programs.nixvim.options = {
#    number = true;         # Show line numbers
#    relativenumber = true; # Show relative line numbers
#    shiftwidth = 2;        # Tab width should be 2
#  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    material-icons
    material-design-icons
    (nerdfonts.override {fonts = ["JetBrainsMono" "Hack"];})
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable Xorg system-wide without a Display Manager
  services.xserver.displayManager.startx.enable = true;

  services.xserver.windowManager = {
      i3.enable = true;
  };

  services.picom.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

