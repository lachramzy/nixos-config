{ config, pkgs, ... }: {

  boot.kernalPackages = pkgs.linuxPackages_zen;

  # boot.initrd.luks.devices."hdd" = {
  # device = "UUID";
  # preLVM = true;
  # };

  # fileSystems."/data" = {
  # device = "/dev/mapper/crypthdd";
  # fsType = "ext4";
  # options = [ "defaults" "nofail" ];
  # };

}
