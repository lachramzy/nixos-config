{ config, lib, pkgs, ... }:

{
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

    boot.initrd.luks.devices."cryptdata" = {
      device = "/dev/disk/by-uuid/a94af95f-5062-4c1a-aa2e-612645c19f38";
      preLVM = true;
    };

    fileSystems."/mnt/hdd" = {
      device = "/dev/disk/by-uuid/cb0134fc-6dd5-4efc-8114-b683b27b5e6f";
      fsType = "ext4";
      options = [ 
        "users" 
        "nofail"
      ];
    };

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
  networking.firewall = {
    enable = true;
  };

  security = {
    apparmor.enable = true;

    protectKernelImage = true;

    sudo.extraConfig = ''
      Defaults lecture="never"
    '';
  };

  systemd.coredump.enable = false;

  time.timeZone = "Australia/Melbourne";

  i18n.defaultLocale = "en_AU.UTF-8";

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
      function nrs
      cd /etc/nixos/personal-flake

      echo "=== Updating flake inputs ==="
      nix flake update

      echo "=== Rebuilding system ==="
      if sudo nixos-rebuild switch --flake .#nixos-btw $argv
          echo "=== Build successful, committing changes ==="
          git add .
          if not git diff --cached --quiet
              git commit -m "auto: post-rebuild "(date '+%Y-%m-%d %H:%M:%S')
              git push
              echo "✅ Pushed to GitHub"
          else
              echo "No changes to commit"
          end
      else
          echo "❌ Rebuild failed, not committing"
          return 1
      end
  end
    '';
    loginShellInit = ''
      if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
          exec start-hyprland
      end
    '';
  };

  users.users.lachlan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "i2c-dev" ];
    packages = with pkgs; [
      tree
    ];
  shell = pkgs.fish;
  };

  # SOUND
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  # GEOCLUE
  services.geoclue2 = {
    enable = true;
    enableWifi = true;
    enable3G = false;
  };

  services.geoclue2.appConfig.gammastep = {
    isAllowed = true;
    isSystem = false;
    users = [ "lachlan" ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };
 
  nixpkgs.config.allowUnfree = true;

  # FONTS & PACKAGES
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.hack
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];

    enableDefaultPackages = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
	sansSerif = [ "Noto Sans CJK JP" ];
	serif = [ "Noto Serif CJK JP" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    alsa-utils
    ani-cli
    btop
    cava
    cbonsai
    celluloid
    cmatrix
    croc
    cowsay
    curl
    davinci-resolve-studio
    ddcutil
    discord
    easyeffects
    ethtool
    fastfetch
    gammastep
    geoclue2
    gimp
    git
    git-crypt
    gnome-themes-extra
    htop
    kdePackages.qtwayland
    keepassxc
    kitty
    lact
    libnotify
    libreoffice
    librewolf
    lutris
    mpv
    mov-cli
    nixpkgs-fmt
    nix-output-monitor
    obsidian
    openrgb
    osu-lazer-bin
    prismlauncher
    protonup-qt
    pulsemixer
    ripgrep
    sl
    spotify
    swayimg
    s-tui
    thunar
    tty-clock
    unzip
    vis
    wget
    wl-clipboard
    zip
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Opens ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Opens ports for Source Dedicated Server
    extraCompatPackages = with pkgs; [ 
      proton-ge-bin
    ];
  };

  environment.etc."xdg/menus/applications.menu".source = 
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

# AMD GPU CONFIG
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.graphics.extraPackages = with pkgs; [
    mesa.opencl
  ];

  services.lact = {
    enable = true;
  };

  hardware.amdgpu.overdrive.enable = true;

# LIBREWOLF SETTINGS
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    policies = {
      HardwareAcceleration = true;
    };

    preferences = {
      "layers.acceleration.force-enabled" = true;
      "gfx.webrender.all" = true;
      "dom.ipc.processCount" = 4;
      "browser.cache.disk.enable" = true;
      "browser.cache.disk.capacity" = 512000;
      "browser.cache.memory.capacity" = 81920;
      "network.http.pipelining" = true;
      "network.http.pipelining.maxrequests" = 32;
      "network.http.max-connections" = 512;
      "network.http.max-persistent-connections-per-server" = 6;
      "image.mem.max_decoded_image_kb" = 256000;
      "browser.sessionhistory.max_total_viewers" = 3;
      "general.smoothScrolling" = true;
      "mousewheel.min_line_scroll_amount" = 60;
      "toolkit.scrollbox.smoothScroll" = true;
      "layout.frame_rate" = 60;
      "network.dns.disableIPv6" = true;
      "privacy.resistFingerprinting" = false;
      "ui.systemUsesDarkTheme" = 1;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "browser.theme.toolbar-theme" = 0;
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

# NIX SETTINGS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
