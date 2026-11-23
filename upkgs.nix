{ pkgsUnstable, ... }:

{
  environment.systemPackages = with pkgsUnstable; [
    ani-cli
    cava
    celluloid
    discord
    easyeffects
    gamescope
    ghostty
    gimp
    hyprlock
    hyprshot
    kdePackages.filelight
    libreoffice
    librewolf
    llama-cpp-rocm
    lutris
    mpv
    obsidian
    obs-studio
    osu-lazer-bin
    prismlauncher
    protonup-qt
    pulsemixer
    qbittorrent
    spotify
    swayimg
    thunar
    umu-launcher
  ];

  programs.firefox = {
    enable = true;
    package = pkgsUnstable.librewolf;
  };
}
