# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #Enabel extra kernal fetura 
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam, Virt Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  #mount harddrives
  fileSystems."/mnt/500Gb" =
    { device = "/dev/disk/by-uuid/779ceceb-e50b-4651-962d-3c5765e1b4f2";
      fsType = "ext4";
    };

   fileSystems."/mnt/TB2" =
    { device = "/dev/disk/by-uuid/2537896a-0298-4a70-b219-50567560c249";
      fsType = "ext4";
    };

    fileSystems."/mnt/TB1" =
    { device = "/dev/disk/by-uuid/E010202C10200C5A";
      fsType = "ntfs";
    };

  networking.hostName = "nichtsos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.interfaces.enp3s0.wakeOnLan.enable = true;
  networking.interfaces.enp3s0.macAddress = "d6:22:c7:46:18:b4";  

  #enable Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth

  # Set your time zone.
	time.timeZone = "Europe/Stockholm";


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #Enable wayland & autologin
  services.displayManager = { 
    sddm.enable = true;
    sddm.wayland.enable = true;
    autoLogin.enable = true;
    autoLogin.user = "vincentl";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = false;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.users.vincentl.isNormalUser = true;
  home-manager.users.vincentl = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vincentl = {
    #isNormalUser = true;
    description = "Vincent Lundborg";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      xwaylandvideobridge
      spotify
      egl-wayland
      python3
      vscode-fhs
      thunderbird
      git
      vscode
      ldmtool
      wgnord
      heroic
      vlc
      sunshine
      whatsapp-for-linux
      nodejs_22
      calibre
      spotifyd
      spotify-qt
      webcord-vencord
      colmap
      prismlauncher
      bluemail
      itch
   ];
  };

  #install Steam
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    obsidian
    git
    neovim
    ethtool
    rustc
    jellyfin-ffmpeg
  ];
  # alow for experimantel nix features
  nix = {
    settings = {  
      experimental-features = ["nix-command" "flakes" ];
    };
  };
  
 hardware.opengl = {
	    enable = true;
	    driSupport32Bit = true;
	  };
	 services.xserver.videoDrivers = [ "nvidia" ];
	 hardware.nvidia = {
	      # Modesetting is required.
	      modesetting.enable = true;
	      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
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
	      # Currently alpha-quality/buggy, so false is currently the recommended setting.
	      open = false;
	      # Enable the Nvidia settings menu,
	      # accessible via `nvidia-settings`.
	      nvidiaSettings = true;
	      # Optionally, you may need to select the appropriate driver version for your specific GPU.
	      package = config.boot.kernelPackages.nvidiaPackages.stable;
	    };

  #sunshine settings (remote Desktop)
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };


  # List of Insecure Packages that are allowed 
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # requierd for rebuild
    "freeimage-unstable-2021-11-01" # for photogramitry
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
