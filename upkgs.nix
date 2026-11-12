{ pkgsUnstable, ... }:

{
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

  programs.firefox = {
    enable = true;
    package = pkgsUnstable.librewolf;
  };
}
