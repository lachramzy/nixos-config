{ pkgsLocked, ... }:

{
  environment.systemPackages = with pkgsLocked; [
    cmatrix
    keepassxc
    openrgb
    termdown
    tty-clock
  ];
}
