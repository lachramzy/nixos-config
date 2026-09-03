{ config, lib, pkgs, ... }:

{
############
# > BOOT < #
############

  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.initrd.luks.devices."cryptdata" = {
    device = "/dev/disk/by-uuid/a94af95f-5062-4c1a-aa2e-612645c19f38";
    preLVM = true;
  };

  fileSystems."/hdd" = {
    device = "/dev/disk/by-uuid/cb0134fc-6dd5-4efc-8114-b683b27b5e6f";
    fsType = "ext4";
    options = [ 
      "users" 
      "nofail"
    ];
  };

  boot.blacklistedKernelModules = [
    "ipv6"
    "firewire-core"
    "tb_net"
    "floppy"
    "cdrom"
  ];

  boot.kernelParams = [ "amd_pstate=active" ];
  powerManagement.cpuFreqGovernor = "performance";
  boot.tmp.useTmpfs = true;



##############
# > SYSTEM < #
##############

  networking.hostName = "nixos-btw";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
  networking.firewall = {
    enable = true;
  };
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
  };

  services.resolved.enable = true;
  systemd.coredump.enable = false;
  time.timeZone = "Australia/Melbourne";

  security = {
    apparmor.enable = true;
    protectKernelImage = true;
    sudo.extraConfig = ''
      Defaults lecture="never"
    '';
    sudo.execWheelOnly = true;
    forcePageTableIsolation = true;
  };

  i18n.defaultLocale = "en_AU.UTF-8";

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" "uinput" ];

  programs.fish = {
  enable = true;
  interactiveShellInit = ''
    set -g fish_greeting

    function nrs
      set -l old_pwd $PWD
        cd /etc/nixos/personal-flake

        echo "=== Rebuilding system ==="

        # Ask whether to update flake inputs
        read --prompt-str "Update flake inputs? (y/N) " confirm
        if test "$confirm" = y; or test "$confirm" = Y
          echo "=== Updating flake inputs ==="
          nix flake update
        end

        echo "=== Running nixos-rebuild ==="

        if sudo nixos-rebuild switch --flake .#nixos-btw --cores 16 --max-jobs 2 $argv
          echo "=== Build successful, committing changes ==="
          git add .
          if not git diff --cached --quiet
            git commit -m "auto: post-rebuild "(date '+%Y-%m-%d %H:%M:%S')
            git push
            echo "✅ Pushed to GitHub"
          else
            echo "No changes to commit"
          end
          
          # Go back and exit cleanly
          cd $old_pwd
          return 0
        else
          echo "❌ Rebuild failed, not committing"
          
          # Go back and pass the error code
          cd $old_pwd
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
      cores = 16;
      max-jobs = 2;
      http-connections = 128;
      max-substitution-jobs = 128;
    };
  };

  users.users.lachlan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "i2c-dev" "plugdev" ];
    packages = with pkgs; [
      tree
    ];
  shell = pkgs.fish;
  };

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess"
  '';

  hardware.bluetooth.enable = false;
  services.printing.enable = false;
  networking.wireless.enable = lib.mkForce false;
  documentation.enable = false;
  documentation.man.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;

  xdg.portal = {
    enable = true;
  };

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFSET = "aco";
    MOZ_ENABLE_WAYLAND = "1";
  };

  services.fstrim.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;



#############
# > SOUND < #
#############

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



################ 
# > PACKAGES < #
################

  nixpkgs.config.allowUnfree = true;
  fonts = {
    packages = with pkgs; [
      noto-fonts
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
    ffmpeg-full
    gamescope
    gammastep
    gimp
    git
    git-crypt
    gnome-keyring
    gnome-themes-extra
    hyprshot
    kdePackages.filelight
    kdePackages.qtwayland
    keepassxc
    kitty
    lact
    libreoffice
    librewolf
    libsecret
    lutris
    mpv
    mov-cli
    nixpkgs-fmt
    nix-output-monitor
    obsidian
    obs-studio
    openrgb
    osu-lazer-bin
    polychromatic
    prismlauncher
    protonup-qt
    protontricks
    proton-vpn-cli
    pulsemixer
    p7zip
    ripgrep
    spotify
    swayimg
    s-tui
    termdown
    tty-clock
    unrar
    unzip
    vim
    wget
    winetricks
    wineWow64Packages.stable
    wireguard-tools
    wl-clipboard
    yazi
    yt-dlp
    zip
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;



###############
# > DRIVERS < #
###############

  hardware.openrazer = {
    enable = true;
    users = [ "lachlan" ];
  };
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;



###############
# > AMD GPU < #
###############

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    package = pkgs.mesa.override {
      stdenv = pkgs.stdenvAdapters.impureUseNativeOptimizations pkgs.stdenv;
    };

    package32 = pkgs.pkgsi686Linux.mesa.override {
      stdenv = pkgs.pkgsi686Linux.stdenvAdapters.impureUseNativeOptimizations pkgs.pkgsi686Linux.stdenv;
    };

    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  services.lact = {
    enable = true;
  };

  hardware.amdgpu.overdrive.enable = true;



####################
# > NIX SETTINGS < #
####################

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";
}
