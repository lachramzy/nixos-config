{ pkgs, ... }:

{
  # Hardware access and input drivers
  hardware.i2c.enable = true;
  boot.kernelModules = [ "i2c-dev" "uinput" ];

  hardware.openrazer = {
    enable = true;
    users = [ "lachlan" ];
  };
  hardware.opentabletdriver.enable = true;
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
  };

  hardware.amdgpu.overdrive.enable = true;
}
