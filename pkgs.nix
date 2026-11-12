{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # FONTS
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

  # STABLE PACKAGES
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    btop
    cmake
    cmatrix
    croc
    curl
    davinci-resolve-studio
    ddcutil
    ethtool
    exodus
    fastfetch
    furmark
    gammastep
    geekbench
    gimp
    git
    git-crypt
    gnome-keyring
    gnome-themes-extra
    gptfdisk
    kdePackages.filelight
    kdePackages.qtwayland
    keepassxc
    libreoffice
    libsecret
    memtest_vulkan
    nixpkgs-fmt
    nix-output-monitor
    obsidian
    obs-studio
    openrgb
    prismlauncher
    protonup-qt
    protontricks
    proton-vpn-cli
    psmisc
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

  # USER PACKAGES
  users.users.lachlan.packages = with pkgs; [
    tree
  ];
}
