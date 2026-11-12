{ pkgsUnstable, ... }:

{
  # BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgsUnstable.linuxPackages_zen;

  # ENCRYPTION
  boot.initrd.luks.devices."cryptdata" = {
    device = "/dev/disk/by-uuid/3dc33fd8-dbb2-4d63-aa21-096a698ac1c7";
    allowDiscards = true;
  };
  boot.initrd.luks.devices."crypt-hdd" = {
    device = "/dev/disk/by-uuid/a94af95f-5062-4c1a-aa2e-612645c19f38";
    allowDiscards = true;
  };

  # KERNEL SETTINGS
  boot.blacklistedKernelModules = [
    "ipv6"
    "firewire-core"
    "tb_net"
    "floppy"
    "cdrom"
  ];
  boot.kernelParams = [
    "amd_pstate=active"
  ];

  # CACHING
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "32G";
}
