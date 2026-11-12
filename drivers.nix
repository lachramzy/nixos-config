{ pkgs, pkgsUnstable, ... }:

{
  # Hardware access and input drivers
  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" "uinput" ];

  hardware.openrazer = {
    enable = true;
    users = [ "lachlan" ];
    # The kernel module follows boot.kernelPackages (unstable linux-zen).
    packages.daemon = pkgsUnstable.python3Packages.openrazer-daemon;
  };

  hardware.opentabletdriver = {
    enable = true;
    package = pkgsUnstable.opentabletdriver;
  };
  hardware.uinput.enable = true;

  # HID device permissions used by input devices
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess"
  '';

  hardware.bluetooth.enable = false;

  # AMD GPU / Mesa configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # Preserve the existing host-native Mesa build optimisation while
    # switching both 64-bit and 32-bit Mesa to nixos-unstable.
    package = pkgsUnstable.mesa.override {
      stdenv = pkgsUnstable.stdenvAdapters.impureUseNativeOptimizations pkgsUnstable.stdenv;
    };

    package32 = pkgsUnstable.pkgsi686Linux.mesa.override {
      stdenv = pkgsUnstable.pkgsi686Linux.stdenvAdapters.impureUseNativeOptimizations pkgsUnstable.pkgsi686Linux.stdenv;
    };

    extraPackages = [
      pkgsUnstable.rocmPackages.clr.icd
    ];
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFSET = "aco";
    MESA_DISK_CACHE_DIR = "/scratch/cache/lachlan/mesa";
    AMD_SHADER_DISK_CACHE_PATH = "/scratch/cache/lachlan/amd";
    ENABLE_HDR_WSI = "1";
    DXVK_HDR = "1";
    ENABLE_GAMESCOPE_WSI = "1";
  };

  services.lact = {
    enable = true;
    package = pkgsUnstable.lact;
  };

  hardware.amdgpu.overdrive.enable = true;
}
