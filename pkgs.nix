{ pkgs, ... }:

{
  # Package policy
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.hack
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans CJK JP" ];
        serif = [ "Noto Serif CJK JP" ];
      };
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    alsa-plugins
    alsa-utils
    ani-cli
    btop
    cava
    celluloid
    cmake
    cmatrix
    croc
    curl
    davinci-resolve-studio
    ddcutil
    discord
    easyeffects
    ethtool
    exodus
    fastfetch
    ffmpeg-full
    furmark
    gamescope
    gammastep
    geekbench
    gimp
    git
    git-crypt
    gnome-keyring
    gnome-themes-extra
    gptfdisk
    hyprlock
    hyprshot
    kdePackages.filelight
    kdePackages.qtwayland
    keepassxc
    kitty
    lact
    libreoffice
    librewolf
    libsecret
    memtest_vulkan
    mpv
    mov-cli
    nixpkgs-fmt
    nix-output-monitor
    obsidian
    obs-studio
    openrgb
    osu-lazer-bin
    llama-cpp-rocm
    polychromatic
    prismlauncher
    protonup-qt
    protontricks
    proton-vpn-cli
    psmisc
    pulsemixer
    p7zip
    qbittorrent
    ripgrep
    spotify
    stress-ng
    swayimg
    s-tui
    termdown
    thunar
    tty-clock
    umu-launcher
    unrar
    unzip
    vim
    wget
    winetricks
    wineWow64Packages.stable
    wireguard-tools
    wl-clipboard
    yazi
    yt-dlp
    zip
  ];

  # Packages installed specifically for this user
  users.users.lachlan.packages = with pkgs; [
    tree
  ];

  # Browser package selection
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };
}
