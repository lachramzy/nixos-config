{ pkgsUnstable, ... }:

{
  # Unstable package channel (nixos-unstable).
  # To install a package from unstable, add it to this file.
  # To change a package's channel, move its name between this file and pkgs.nix.

  environment.systemPackages = with pkgsUnstable; [
    alsa-plugins
    alsa-utils
    ani-cli
    cava
    celluloid
    discord
    easyeffects
    ffmpeg-full
    gamescope
    hyprlock
    hyprshot
    lact
    librewolf
    llama-cpp-rocm
    mov-cli
    mpv
    osu-lazer-bin
    polychromatic
    pulsemixer
  ];

  # The Firefox module is used as the integration point for LibreWolf.
  # Its package is selected from unstable to match the system package above.
  programs.firefox = {
    enable = true;
    package = pkgsUnstable.librewolf;
  };
}
