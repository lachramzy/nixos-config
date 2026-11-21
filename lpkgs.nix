{ pkgsLocked, ... }:

{
  environment.systemPackages = with pkgsLocked; [
    keepassxc
    openrgb
    unimatrix
  ];
}
