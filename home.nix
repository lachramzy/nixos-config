{ config, pkgs, ... }:

{
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  programs.git.enable = true;
  programs.git.settings.user.name = "lachlan";
  programs.git.settings.user.email = "lacjamram@gmail.com";
  
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  # HYPRLAND RICE
  home.file.".config/hypr/hyprland.conf" = {
    text = ''
  # MONITOR
  monitor=DP-1,3840x2160@165,0x0,2,cm,srgb,bitdepth,10,vrr,2

  # ENVIRONMENT VARIABLES
  env = XCURSOR_SIZE,32
  env = HYPRCURSOR_SIZE,32

  # LOOK AND FEEL
  general {
      gaps_in = 0
      gaps_out = 0

      border_size = 0

      col.active_border = rgba(ffffffff) rgba(ffffffff) 45deg
      col.inactive_border = rgba(ffffffff)

      resize_on_border = false
      allow_tearing = false

      layout = dwindle
  }

  decoration {
      rounding = 0
      rounding_power = 0

      active_opacity = 1
      inactive_opacity = 1
      fullscreen_opacity = 1

      shadow {
          enabled = false
          range = 0
          render_power = 0
          color = rgba(00000000)
      }

      blur {
          enabled = false
          size = 0
          passes = 0
          new_optimizations = true
          xray = false
          vibrancy = 0
      }
  }

  animations {
      enabled = false
  }

  dwindle {
      preserve_split = true
  }

  master {
      new_status = master
  }

  # INPUT
  input {
      kb_layout = us
      repeat_delay = 140
      repeat_rate = 100

      follow_mouse = 1
      sensitivity = -0.3
      accel_profile = flat
  }

  misc {
    disable_hyprland_logo = true
    force_default_wallpaper = 0
    background_color = rgb(000000)
    disable_splash_rendering = true;
  }

  gesture = 3, horizontal, workspace

  # KEYBINDS
  $mainMod = SUPER

  bind = $mainMod, RETURN, exec, kitty
  bind = $mainMod, Q, killactive,
  bind = $mainMod, M, exec, spotify
  bind = $mainMod, E, exec, thunar
  bind = $mainMod, V, togglefloating,
  bind = $mainMod, P, pseudo,
  bind = $mainMod, J, layoutmsg, togglesplit,
  bind = $mainMod, W, exec, librewolf
  bind = $mainMod, F, fullscreen, 0
  bind = $mainMod, D, exec, discord
  bind = $mainMod SHIFT, O, exec, libreoffice
  bind = $mainMod, G, exec, gimp
  bind = $mainMod SHIFT, D, exec, QT_QPA_PLATFORM=xcb davinci-resolve-studio
  bind = $mainMod SHIFT, L, exec, lact
  bind = $mainMod, L, exec, lutris
  bind = $mainMod, A, exec, kitty --class floating_mixer -e pulsemixer
  bind = $mainMod SHIFT, E, exec, easyeffects
  bind = $mainMod, O, exec, obsidian
  bind = $mainMod CTRL, O, exec, osu!
  bind = $mainMod, P, exec, prismlauncher
  bind = $mainMod, S, exec, steam

  bind = $mainMod, left, movefocus, l
  bind = $mainMod, right, movefocus, r
  bind = $mainMod, up, movefocus, u
  bind = $mainMod, down, movefocus, d

  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10

  bind = $mainMod ALT, 1, movetoworkspace, 1
  bind = $mainMod ALT, 2, movetoworkspace, 2
  bind = $mainMod ALT, 3, movetoworkspace, 3
  bind = $mainMod ALT, 4, movetoworkspace, 4
  bind = $mainMod ALT, 5, movetoworkspace, 5
  bind = $mainMod ALT, 6, movetoworkspace, 6
  bind = $mainMod ALT, 7, movetoworkspace, 7
  bind = $mainMod ALT, 8, movetoworkspace, 8
  bind = $mainMod ALT, 9, movetoworkspace, 9
  bind = $mainMod ALT, 0, movetoworkspace, 10

  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1

  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow

  bindel = $mainMod, Page_Up, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+
  bindel = $mainMod, Page_Down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
  bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  bindel = $mainMod SHIFT, Page_Up, exec, ddcutil -b 10 setvcp 10 + 20
  bindel = $mainMod SHIFT, Page_Down, exec, ddcutil -b 10 setvcp 10 - 20

  bindl = , XF86AudioNext, exec, playerctl next
  bindl = , XF86AudioPause, exec, playerctl play-pause
  bindl = , XF86AudioPlay, exec, playerctl play-pause
  bindl = , XF86AudioPrev, exec, playerctl previous
  xwayland {
      force_zero_scaling = true
  }
  '';
    force = true;
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
      cursor-size = 32;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 32;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 32;
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  home.packages = with pkgs; [
    gnome-themes-extra
    adwaita-qt
    adwaita-icon-theme
    dconf
    qt6Packages.qt6ct
    papirus-icon-theme
  ];

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      paste_actions = "no-op";
    };
  };

  home.stateVersion = "26.05";
}
