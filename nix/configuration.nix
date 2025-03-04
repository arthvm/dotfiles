# Edit this configuration file to define what should be installed onconfig
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  outputs,
  pkgs,
  meta,
  lib,
  ...
}: {
  imports = [
    ./modules/languages.nix
    ./modules/gnome.nix
    ./modules/gaming.nix
    ./modules/messaging.nix
    ./modules/yubikey-gpg.nix
    ./modules/unfree.nix
    ./modules/video.nix
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.warn-dirty = false;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.unstable
      outputs.overlays.modifications
      inputs.templ.overlays.default
      inputs.alacritty-theme.overlays.default

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };

  services.systembus-notify.enable = true;

  # Use the latest linux kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # List packages installed in system profile. To search, run:
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = meta.hostname; # Hostname is defined by the flake.

  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    openmoji-color
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arthvm = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "input"
      "uinput"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$6$pMhEzs1x5z9dxJxt$FS1YD8b6Y49E52tSOaexcd59NYniIQNR.jdZAds2Q.yPcPiIke21Q1JcZgW5VJ3mfqHSxPylF9xi.DGlZS80P1";
    openssh.authorizedKeys.keys = [
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  hardware.keyboard.qmk.enable = true;

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    act
    alejandra
    awscli
    banana-cursor-dreams
    bubblewrap
    chromium
    clickgen
    distrobox
    dotool
    doppler
    eza
    firefox
    fzf
    git
    glib
    go-migrate
    goimports-reviser
    golines
    gptscript
    grim # screenshot functionality
    gtk3
    k6
    hyprpaper
    hyprpicker
    unstable.ghostty
    imagemagick
    jq
    kanata
    kubectl
    kubectx
    kustomize
    lua-language-server
    mako # notification system developed by swaywm maintainer
    mm-common
    neovim
    nil
    nwg-look
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vaapi
      ];
    })
    oh-my-posh
    openssl
    pika-backup
    python3
    pkg-config
    pop-gtk-theme
    postgresql
    protonvpn-cli
    protonvpn-gui
    qemu
    qmk
    rclone
    ripgrep
    sassc
    slurp
    spotify
    sqlc
    streamcontroller
    unstable.stripe-cli
    stow
    stylua
    templ
    tmux
    transmission_4-gtk
    typescript-language-server
    unzip
    wvkbd
    showmethekey
    wshowkeys
    wl-screenrec
    wl-clipboard
    wofi
    vlc
    zenity
    zellij
    zip
    avahi
    nssmdns
    railway
    thefuck
    pyenv
    pnpm_9
    prisma-engines
    prisma
  ];

  # Virtualisation
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
  };

  programs.virt-manager.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
    gamescopeSession = {
      enable = true;
    };
  };

  programs.gamemode.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # enable sway window manager
  programs.sway = {
    enable = false;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  programs.hyprland.enable = true;

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Bonjour
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  all       all     127.0.0.1/32 trust
    '';
  };

  # gnome
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-gtk # For both
      pkgs.xdg-desktop-portal-hyprland # For Hyprland
      pkgs.xdg-desktop-portal-gnome # For GNOME
    ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-id/usb-Apple_0003_05AC_024F_0001-event-kbd"
          "/dev/input/by-id/usb-Apple_0003_05AC_024F_0002-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           caps a s d f j k l ;
          )
          (defvar
           tap-time 150
           hold-time 200
          )
          (defalias
           caps (tap-hold 100 100 esc lctl)
           a (multi f24 (tap-hold $tap-time $hold-time a lmet))
           s (multi f24 (tap-hold $tap-time $hold-time s lalt))
           d (multi f24 (tap-hold $tap-time $hold-time d lsft))
           f (multi f24 (tap-hold $tap-time $hold-time f lctl))
           j (multi f24 (tap-hold $tap-time $hold-time j rctl))
           k (multi f24 (tap-hold $tap-time $hold-time k rsft))
           l (multi f24 (tap-hold $tap-time $hold-time l ralt))
           ; (multi f24 (tap-hold $tap-time $hold-time ; rmet))
          )


          (deflayer base
           @caps @a  @s  @d  @f  @j  @k  @l  @;
          )
        '';
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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
