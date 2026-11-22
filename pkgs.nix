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
    alsa-plugins
    alsa-utils
    btop
    cmake
    croc
    curl
    ddcutil
    ethtool
    exodus
    fastfetch
    ffmpeg-full
    furmark
    gammastep
    geekbench
    git
    git-crypt
    gnome-keyring
    gnome-themes-extra
    gptfdisk
    kdePackages.qtwayland
    lact
    libsecret
    memtest_vulkan
    nixpkgs-fmt
    nix-output-monitor
    polychromatic
    protonup-qt
    protontricks
    proton-vpn-cli
    psmisc
    p7zip
    ripgrep
    stress-ng
    s-tui
    termdown
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
    yt-dlp
    zip
  ];

  # USER PACKAGES
  users.users.lachlan.packages = with pkgs; [
    tree
  ];

  # STEAM
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    remotePlay.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
}
