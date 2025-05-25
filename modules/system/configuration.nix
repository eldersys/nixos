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

  programs.gnome-disks.enable = true;
  services.udisks2.enable = true;

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
      stremio
      steam-run
      cobra-cli
      flameshot
      gnome.seahorse
    ];
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
    };
  environment.localBinInPath = true;

  environment.etc.openvpn.source = pkgs.update-resolv-conf;

  environment.variables = {
  	NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
	EDITOR = "nvim";
  };
    
  users.extraUsers.iohannes.extraGroups = ["audio" "adbusers" "kvm"];

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" 
    "qbittorrent-4.6.4"
  ];

  nix.extraOptions = ''
        trusted-users = root iohannes
    '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSUserEnv (base // {
      name = "fhs";
      targetPkgs = pkgs: 
        # pkgs.buildFHSUserEnv provides only a minimal FHS environment,
        # lacking many basic packages needed by most software.
        # Therefore, we need to add them manually.
        #
        # pkgs.appimageTools provides basic packages required by most software.
        (base.targetPkgs pkgs) ++ (with pkgs; [
          pkg-config
          ncurses
          # Feel free to add more packages here if needed.
        ]
      );
      profile = "export FHS=1";
      runScript = "bash";
      extraOutputsToInstall = ["dev"];
    }))
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

  hardware.opengl = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.gnome.gnome-keyring.enable = true;

  
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

