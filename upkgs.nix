{ pkgsUnstable, ... }:

{
  environment.systemPackages = with pkgsUnstable; [
    alsa-plugins
    alsa-utils
    ani-cli
    cava
    celluloid
    davinci-resolve-studio
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
    libreoffice
    librewolf
    llama-cpp-rocm
    lutris
    mov-cli
    mpv
    obsidian
    obs-studio
    openrgb
    osu-lazer-bin
    polychromatic
    prismlauncher
    protonup-qt
    pulsemixer
    qbittorrent
    spotify
    swayimg
    thunar
  ];

  programs.firefox = {
    enable = true;
    package = pkgsUnstable.librewolf;
  };
}
