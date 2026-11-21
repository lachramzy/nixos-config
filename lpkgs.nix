{ pkgsLocked, ... }:

{
  environment.systemPackages = with pkgsLocked; [
    keepassxc
    openrgb
    termdown
    tty-clock
    unimatrix
  ];
}
