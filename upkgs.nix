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
    ghostty
    gimp
    hyprlock
    hyprshot
    kdePackages.filelight
    lact
    librewolf
    llama-cpp-rocm
    mov-cli
    mpv
    obs-studio
    openrgb
    osu-lazer-bin
    polychromatic
    protonup-qt
    pulsemixer
    qbittorrent
    swayimg
    thunar
  ];

  programs.firefox = {
    enable = true;
    package = pkgsUnstable.librewolf;
  };
}
