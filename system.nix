{ config, lib, pkgs, ... }:

{
  # Storage mounts for the encrypted data volumes configured in boot.nix
  fileSystems."/scratch" = {
    device = "/dev/mapper/cryptdata";
    fsType = "xfs";
    options = [ "defaults" "noatime" "nofail" ];
  };

  fileSystems."/hdd" = {
    device = "/dev/mapper/crypt-hdd";
    fsType = "ext4";
    options = [ "defaults" "noatime" "nofail" ];
  };

  systemd.services.nix-daemon.environment.TMPDIR = "/scratch/nix-tmp";
  systemd.tmpfiles.rules = [
    "d /scratch/nix-tmp 1777 root root -"
    "d /scratch/cache 1777 root root -"
  ];

  # CPU power management
  powerManagement.cpuFreqGovernor = "performance";

  # Networking
  networking.hostName = "nixos-btw";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
  networking.firewall = {
    enable = true;
  };
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;
  networking.wireless.enable = lib.mkForce false;

  # Network and kernel tuning
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

  security.pam.loginLimits = [
    { domain = "*"; item = "core"; type = "hard"; value = "0"; }
    { domain = "*"; item = "core"; type = "soft"; value = "0"; }
  ];

  systemd.settings.Manager = {
    DefaultLimitCORE = "0";
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
  services.fstrim.enable = true;

  # Security
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

  # Interactive shell configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting

      function nrs
        set -l old_pwd $PWD
          cd /etc/nixos
          echo "=== Rebuilding system ==="
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
            cd $old_pwd
            return 0
          else
            echo "❌ Rebuild failed, not committing"
            cd $old_pwd
            return 1
          end
        end

      function ngc
          echo "=== Deleting old generations and garbage collecting ==="
          sudo nix-collect-garbage -d
          echo "=== Optimizing Nix store ==="
          sudo nix-store --optimize
          echo "✅ Nix cleanup complete!"
        end
    '';
  };

  # Nix daemon and build settings
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
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # User account
  users.users.lachlan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "i2c-dev" "plugdev" ];
    shell = pkgs.fish;
  };

  services.printing.enable = false;
  documentation.enable = false;
  documentation.man.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;

  # User cache directory
  environment.sessionVariables.XDG_CACHE_HOME = "/scratch/cache/lachlan";

  # System services
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "daily";
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
      pipewire = {
        "context.properties" = {
          "default.clock.rate" = 96000;
          "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
  };

  # NixOS release compatibility
  system.stateVersion = "26.05";
}
