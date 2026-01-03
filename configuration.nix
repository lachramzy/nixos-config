{ config, lib, pkgs, ... }:

# DAVINCI RESOLVE STUDIO CRACK
let
  ffmpeg-encoder-plugin = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "ffmpeg-encoder-plugin";
    version = "1.1.0";
 
    src = pkgs.fetchFromGitHub {
      owner = "EdvinNilsson";
      repo = "ffmpeg_encoder_plugin";
      tag = "v${finalAttrs.version}";
      hash = "sha256-orghLIzz9rUnUwka9C71Z2nj+qxHuggrKNlYjLKswQw=";
    };
 
    nativeBuildInputs = with pkgs; [
      cmake
      ffmpeg-full
    ];
 
    buildInputs = with pkgs; [ ffmpeg ];
 
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp ffmpeg_encoder_plugin.dvcp $out/
      runHook postInstall
    '';
  });
 
  davinci-resolve-studio-cracked =
    let
      davinci-patched = pkgs.davinci-resolve-studio.davinci.overrideAttrs (old: { 
        postInstall = ''
          ${old.postInstall or ""}
          ${lib.getExe pkgs.perl} -pi -e 's/\x74\x11\xe8\x21\x23\x00\x00/\xeb\x11\xe8\x21\x23\x00\x00/g' $out/bin/resolve
          ${lib.getExe pkgs.perl} -pi -e 's/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\xEB\x11\x48\x8B\x45\xC8\x8B/' $out/bin/resolve
          ${lib.getExe pkgs.perl} -pi -e 's/\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/\xEB\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/' $out/bin/resolve
          ${lib.getExe pkgs.perl} -pi -e 's/\x41\xb6\x01\x84\xc0\x0f\x84\xb0\x00\x00\x00\x48\x85\xdb\x74\x08\x45\x31\xf6\xe9\xa3\x00\x00\x00/\x41\xb6\x00\x84\xc0\x0f\x84\xb0\x00\x00\x00\x48\x85\xdb\x74\x08\x45\x31\xf6\xe9\xa3\x00\x00\x00/' $out/bin/resolve
          touch $out/.license/blackmagic.lic
          echo -e "LICENSE blackmagic davinciresolvestudio 999999 permanent uncounted\n  hostid=ANY issuer=CGP customer=CGP issued=28-dec-2023\n  akey=0000-0000-0000-0000 _ck=00 sig=\"00\"" > $out/.license/blackmagic.lic
          mkdir -p $out/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/
          cp ${ffmpeg-encoder-plugin}/ffmpeg_encoder_plugin.dvcp $out/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/
        '';
      });
    in
   
    pkgs.buildFHSEnv {
      inherit (davinci-patched) pname version;
 
      targetPkgs =
        pkgs:
        with pkgs;
        [
          alsa-lib
          aprutil
          bzip2
          dbus
          expat
          fontconfig
          freetype
          glib
          libGL
          libGLU
          libarchive
          libcap
          librsvg
          libtool
          libuuid
          libxcrypt
          libxkbcommon
          nspr
          ocl-icd
          opencl-headers
          python3
          python3.pkgs.numpy
          udev
          xdg-utils
          xorg.libICE
          xorg.libSM
          xorg.libX11
          xorg.libXcomposite
          xorg.libXcursor
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXi
          xorg.libXinerama
          xorg.libXrandr
          xorg.libXrender
          xorg.libXt
          xorg.libXtst
          xorg.libXxf86vm
          xorg.libxcb
          xorg.xcbutil
          xorg.xcbutilimage
          xorg.xcbutilkeysyms
          xorg.xcbutilrenderutil
          xorg.xcbutilwm
          xorg.xkeyboardconfig
          zlib
        ]
        ++ [ davinci-patched ];
 
      extraPreBwrapCmds = ''
        mkdir -p ~/.local/share/DaVinciResolve/Extras || exit 1
      '';
 
      extraBwrapArgs = [
        ''--bind "$HOME"/.local/share/DaVinciResolve/Extras ${davinci-patched}/Extras''
      ];
 
      runScript = "${lib.getExe pkgs.bash} ${pkgs.writeText "davinci-wrapper" ''
        export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
        export QT_PLUGIN_PATH="${davinci-patched}/libs/plugins:$QT_PLUGIN_PATH"
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci-patched}/libs
        ${davinci-patched}/bin/resolve
      ''}";
 
      extraInstallCommands = ''
        mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
        ln -s ${davinci-patched}/share/applications/*.desktop $out/share/applications/
        ln -s ${davinci-patched}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve-studio.png
      '';
 
      passthru = {
        inherit davinci-patched;
        updateScript = lib.getExe (
          pkgs.writeShellApplication {
            name = "update-davinci-resolve";
            runtimeInputs = [
              pkgs.curl
              pkgs.jq
              pkgs.common-updater-scripts
            ];
            text = ''
              set -o errexit
              drv=pkgs/by-name/da/davinci-resolve/package.nix
              currentVersion=${lib.escapeShellArg davinci-patched.version}
              downloadsJSON="$(curl --fail --silent https://www.blackmagicdesign.com/api/support/us/downloads.json)"
              latestLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
              update-source-version davinci-resolve "$latestLinuxVersion" --source-key=davinci.src
              # Since the standard and studio both use the same version we need to reset it before updating studio
              sed -i -e "s/""$latestLinuxVersion""/""$currentVersion""/" "$drv"
              latestStudioLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve Studio \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
              update-source-version davinci-resolve-studio "$latestStudioLinuxVersion" --source-key=davinci.src
            '';
          }
        );
      };
    };
in
{
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  time.timeZone = "Australia/Melbourne";

  i18n.defaultLocale = "en_AU.UTF-8";

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  users.users.lachlan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  # SOUND
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # GEOCLUE
  services.geoclue2 = {
    enable = true;
    enableWifi = true;
    enable3G = false;
  };

  services.geoclue2.appConfig.gammastep = {
    isAllowed = true;
    isSystem = false;
    users = [ "lachlan" ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };
 
  nixpkgs.config.allowUnfree = true;

  # FONTS & PACKAGES
  fonts = {
    packages = with pkgs; [
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

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    btop
    cava
    cbonsai
    cmatrix
    croc
    cowsay
    curl
    davinci-resolve-studio-cracked
    discord
    easyeffects
    ethtool
    eww
    fastfetch
    gammastep
    geoclue2
    gimp
    git
    git-crypt
    gnome-themes-extra
    htop
    hyprpaper
    kdePackages.dolphin
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kservice
    kdePackages.kconfig
    kdePackages.qtwayland
    kitty
    lact
    libnotify
    libreoffice
    librewolf
    neovim
    nixpkgs-fmt
    nix-output-monitor
    pipx
    pkgs.davinci-resolve-studio
    ripgrep
    rofi
    sl
    spotify
    starship
    swayimg
    s-tui
    tty-clock
    unzip
    wget
    zip
  ];

  environment.etc."xdg/menus/applications.menu".source = 
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

# AMD GPU CONFIG
  hardware.graphics = {
    enable = true;
  };

  hardware.graphics.extraPackages = with pkgs; [
    #rocmPackages.clr.icd
    mesa.opencl
  ];

  services.lact = {
    enable = true;
  };

  hardware.amdgpu.overdrive.enable = true;

  systemd.tmpfiles.rules = [
    #"L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

# LIBREWOLF SETTINGS
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    policies = {
      HardwareAcceleration = true;
      Extensions = {
        Install = [
          "https://addons.mozilla.org/firefox/downloads/latest/tokyo-night-moon-theme/latest.xpi"
        ];
      };
    };

    preferences = {
      "layers.acceleration.force-enabled" = true;
      "gfx.webrender.all" = true;
      "dom.ipc.processCount" = 4;
      "browser.cache.disk.enable" = true;
      "browser.cache.disk.capacity" = 512000;
      "browser.cache.memory.capacity" = 81920;
      "network.http.pipelining" = true;
      "network.http.pipelining.maxrequests" = 32;
      "network.http.max-connections" = 512;
      "network.http.max-persistent-connections-per-server" = 6;
      "image.mem.max_decoded_image_kb" = 256000;
      "browser.sessionhistory.max_total_viewers" = 3;
      "general.smoothScrolling" = true;
      "mousewheel.min_line_scroll_amount" = 60;
      "toolkit.scrollbox.smoothScroll" = true;
      "layout.frame_rate" = 60;
      "network.dns.disableIPv6" = true;
      "privacy.resistFingerprinting" = false;
      "ui.systemUsesDarkTheme" = 1;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "browser.theme.toolbar-theme" = 0;
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

# NIX SETTINGS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
