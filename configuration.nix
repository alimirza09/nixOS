# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix inputs.home-manager.nixosModules.default ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      useOSProber = true;
      copyKernels = true;
      efiSupport = true;
      device = "nodev";
      theme = pkgs.catppuccin-grub;
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.gnome.gnome-keyring.enable = true;

  networking.hostName = "nixosBTW"; # Define your hostname.
  programs.direnv.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  # Set your time zone.
  time.timeZone = "Asia/Karachi";
  programs.fish.enable = true;

  programs.dconf.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    libinput = {
      enable = true;
      touchpad.tapping = true;
      touchpad.naturalScrolling = true;
      touchpad.middleEmulation = true;
    };
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pipewire = {
    audio.enable = true;
    enable = true;
    jack.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.ali = {
    isNormalUser = true;
    initialPassword = "test";
    description = "ali";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;

  };

  programs.firefox.enable = true;
  programs.waybar.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    killall
    brightnessctl
    libinput
    unzip
    copyq
    btop
    picom
    yazi
    rofi
    eza
    github-cli
    tealdeer
    git
    kitty
    starship
    rmtrash
    xclip
    home-manager
    trash-cli
    bat
    mako
    alsa-utils
    entr
    pamixer
    tree
    vlc
    sway-contrib.grimshot
    swaybg
    ristretto
    gimp
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    (catppuccin-sddm.override { flavor = "mocha"; })
    catppuccin-grub
    simplescreenrecorder
    waypaper
    swayfx
    ripgrep
  ];
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono font-awesome_5 ];

  services.openssh.enable = true;


  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ 22 80 443 ]; 

    extraCommands = ''
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
      iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 6 -j DROP
    '';

    # Default policy
    rejectPackets = false;
    allowPing = true;
  };

  networking.firewall.checkReversePath = "loose";
  networking.firewall.logRefusedConnections = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
