{ config, lib, pkgs, ... }:

{
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
  services.resolved.enable = true;

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

      echo "=== Rebuilding system ==="

      # Ask whether to update flake inputs
      read --prompt-str "Update flake inputs? (y/N) " confirm
      if test "$confirm" = y -o "$confirm" = Y
        echo "=== Updating flake inputs ==="
        nix flake update
      end

      echo "=== Running nixos-rebuild ==="

      if sudo nixos-rebuild switch --flake .#nixos-btw --cores 12 --max-jobs 4 $argv
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
  # loginShellInit remains the same
    loginShellInit = ''
      if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
          exec start-hyprland
      end
    '';
  };

  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      cores = 8;
      max-jobs = 4;
    };
  };

  users.users.lachlan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "i2c-dev" ];
    packages = with pkgs; [
      tree
    ];
  shell = pkgs.fish;
  };

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess"
  '';

  # SOUND
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    extraConfig = {
      pipewire = {
        "context.properties" = {
          "default.clock.rate"          = 96000;
          "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
          "default.clock.quantum"       = 1024;
          "default.clock.min-quantum"   = 32;
          "default.clock.max-quantum"   = 2048;
        };
      };
    };
  };

  xdg.portal = {
    enable = true;
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
    alsa-plugins
    alsa-utils
    ani-cli
    btop
    cava
    celluloid
    cmatrix
    croc
    curl
    davinci-resolve-studio
    ddcutil
    discord
    easyeffects
    ethtool
    fastfetch
    gammastep
    gimp
    git
    git-crypt
    gnome-themes-extra
    hyprshot
    kdePackages.qtwayland
    keepassxc
    kitty
    lact
    libreoffice
    librewolf
    mpv
    mov-cli
    nixpkgs-fmt
    nix-output-monitor
    obsidian
    openrgb
    protonup-qt
    pulsemixer
    p7zip
    ripgrep
    spotify
    swayimg
    s-tui
    thunar
    tty-clock
    unrar
    unzip
    vis
    wget
    winetricks
    wineWow64Packages.stable
    wl-clipboard
    yt-dlp
    zip
  ];

# AMD GPU CONFIG
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
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
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

# NIX SETTINGS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}