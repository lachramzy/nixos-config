{ config, lib, pkgs, pkgsUnstable, ... }:

{
  # MOUNT POINTS
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

  # CPU POWER
  powerManagement.cpuFreqGovernor = "performance";

  # NETWORKING
  networking.hostName = "nixos-btw";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
  networking.firewall = {
    enable = true;
  };
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;
  networking.wireless.enable = lib.mkForce false;
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
  };

  # SYSTEMD
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

  # FS
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };
  services.fstrim.enable = true;

  # SECURITY
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

  # SHELL
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting

  # NRS
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
      
  # NGC    
    function ngc
      set -l profile /nix/var/nix/profiles/system
      echo "=== NixOS system generations ==="
      set -l generation_lines (sudo nix-env --profile "$profile" --list-generations)
      if test (count $generation_lines) -eq 0
          echo "❌ Could not retrieve system generations."
          return 1
      end
      printf '%s\n' $generation_lines
      set -l all_gens
      set -l current_gen ""
      for line in $generation_lines
          set -l gen (string match --regex --groups-only '^[[:space:]]*([0-9]+)' -- "$line")
          if test -n "$gen"
              set -a all_gens "$gen"
              if string match --quiet '* (current)' -- "$line"
                  set current_gen "$gen"
              end
          end
      end
      if test -z "$current_gen"
          echo "❌ Could not identify the current generation. Aborting."
          return 1
      end
      set -l booted_system (readlink -f /run/booted-system 2>/dev/null)
      set -l booted_gens
      if test -z "$booted_system"
          echo "❌ Cannot identify the currently booted system. Aborting."
          return 1
      end
      for gen in $all_gens
          set -l generation_link "$profile-$gen-link"
          if test -e "$generation_link"
              set -l generation_path (readlink -f "$generation_link")
              if test "$generation_path" = "$booted_system"
                  set -a booted_gens "$gen"
              end
          end
      end
      if test (count $booted_gens) -eq 0
          echo "❌ Cannot match the booted system to a generation. Aborting."
          return 1
      end
      set -l keep_gens "$current_gen"
      for gen in $booted_gens
          if not contains -- "$gen" $keep_gens
              set -a keep_gens "$gen"
          end
      end
      echo ""
      echo "Current generation $current_gen will always be preserved."
      echo "Currently booted generation(s) also protected: "(string join ", " $booted_gens)
      echo ""
      echo "Enter additional generation numbers to KEEP."
      echo "Separate multiple numbers with commas (e.g. 12,15,18)."
      echo "Press Enter without a selection to cancel."
      read --prompt-str "Generations to preserve: " keep_input
      set keep_input (string trim -- "$keep_input")
      if test -z "$keep_input"
          echo "Cancelled. Nothing was changed."
          return 0
      end
      for item in (string split ',' -- "$keep_input")
          set item (string trim -- "$item")
          if not string match --quiet --regex '^[0-9]+$' -- "$item"
              echo "❌ Invalid generation number: $item"
              echo "Nothing was changed."
              return 1
          end
          if not contains -- "$item" $all_gens
              echo "❌ Generation $item does not exist."
              echo "Nothing was changed."
              return 1
          end
          if not contains -- "$item" $keep_gens
              set -a keep_gens "$item"
          end
      end
      set -l rollback_gens
      for gen in $keep_gens
          if test "$gen" != "$current_gen"
              set -a rollback_gens "$gen"
          end
      end
     if test (count $rollback_gens) -eq 0
          echo "❌ You must preserve at least one rollback generation."
          echo "Nothing was changed."
          return 1
      end
      set -l delete_gens
      for gen in $all_gens
          if not contains -- "$gen" $keep_gens
              set -a delete_gens "$gen"
          end
      end
      echo ""
      echo "========== CLEANUP PLAN =========="
      echo "Generations to KEEP:"
      string join ", " $keep_gens
      if test (count $delete_gens) -gt 0
          echo ""
          echo "Generations to DELETE:"
          string join ", " $delete_gens
      else
          echo ""
          echo "No system generations need deleting."
      end
      echo ""
      echo "Unreachable Nix store paths will also be garbage collected."
      echo "Other valid garbage collection roots will remain."
      echo ""
      read --prompt-str "Type DELETE to confirm: " confirm
      if test "$confirm" != "DELETE"
          echo "Cancelled. Nothing was changed."
          return 0
      end
      if test (count $delete_gens) -gt 0
          echo ""
          echo "=== Removing unwanted system generations ==="
          sudo nix-env --profile "$profile" --delete-generations $delete_gens
          if test $status -ne 0
              echo "❌ Generation deletion failed. Garbage collection cancelled."
              return 1
          end
      end
      echo ""
      echo "=== Garbage collecting unused Nix store paths ==="
      sudo nix-store --gc
      if test $status -ne 0
          echo "❌ Garbage collection failed."
          return 1
      end
      echo ""
      echo "=== Optimising Nix store ==="
      sudo nix-store --optimise
      if test $status -ne 0
          echo "⚠️ Store optimisation failed, but garbage collection completed."
          return 1
      end
      echo ""
      echo "✅ Selective Nix cleanup complete!"
      echo "Preserved generations: "(string join ", " $keep_gens)
    end
    '';
  };

  # NIX
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

  # USER
  users.users.lachlan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "i2c-dev" "plugdev" ];
    shell = pkgs.fish;
  };

  # DISABLED SERVICES
  services.printing.enable = false;
  documentation.enable = false;
  documentation.man.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;

  # CACHE
  environment.sessionVariables.XDG_CACHE_HOME = "/scratch/cache/lachlan";

  # ENABLED SERVICES
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "daily";
  };

  # AUDIO
  services.pipewire = {
    enable = true;
    package = pkgsUnstable.pipewire;
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

  # NIX VERSION
  system.stateVersion = "26.05";
}
