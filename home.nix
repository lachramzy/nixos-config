{ config, pkgs, pkgsUnstable, ... }:

{
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  # GIT
  programs.git.enable = true;
  programs.git.settings.user.name = "lachlan";
  programs.git.settings.user.email = "lacjamram@gmail.com";

  # HYPRLAND RICE
  xdg.configFile."hypr/hyprland.lua".text = ''
    -- MONITOR
    hl.monitor({
        output = "DP-1",
        mode = "1920x1080@330",
        position = "0x0",
        scale = 1,
        bitdepth = 10,
        vrr = 2,
        cm = "srgb",
        sdr_eotf = "srgb",
        supports_wide_color = 1,
        supports_hdr = 0,
        sdrbrightness = 1.0,
        sdrsaturation = 1.0,
        sdr_min_luminance = 0.0,
        sdr_max_luminance = 600,
        min_luminance = 0.0,
        max_luminance = -1,
        max_avg_luminance = -1,
    })

    -- RENDER
    hl.config({
        render = {
            direct_scanout = 2,
            keep_unmodified_copy = 1,
            use_fp16 = 2,
            send_content_type = true
        },
        cursor = {
            no_hardware_cursors = false,
        },
    })

    -- ENVIRONMENT VARIABLES
    hl.env("XCURSOR_SIZE", "32")
    hl.env("HYPRCURSOR_SIZE", "32")
    hl.env("DXVK_HDR", "1")

    -- DESIGN
    hl.config({
        general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 0,
            col = {
                active_border = { colors = { "rgba(ffffffff)", "rgba(ffffffff)" }, angle = 45 },
                inactive_border = "rgba(ffffffff)",
            },
            resize_on_border = false,
            allow_tearing = false,
            layout = "dwindle",
        },
        decoration = {
            rounding = 0,
            rounding_power = 1,
            active_opacity = 1,
            inactive_opacity = 1,
            fullscreen_opacity = 1,
            shadow = {
                enabled = false,
                range = 0,
                render_power = 1,
                color = "rgba(00000000)",
            },
            blur = {
                enabled = false,
                size = 0,
                passes = 0,
                new_optimizations = true,
                xray = false,
                vibrancy = 0,
            },
        },
        animations = {
            enabled = false,
        },
        dwindle = {
            preserve_split = true,
        },
        master = {
            new_status = "master",
        },

  -- INPUTS
        input = {
            kb_layout = "us",
            repeat_delay = 150,
            repeat_rate = 100,
            follow_mouse = 1,
            sensitivity = -0.8564,
            accel_profile = "flat",
            emulate_discrete_scroll = 0,
            scroll_factor = 1.0,
        },

  -- MISC
        misc = {
            disable_hyprland_logo = true,
            force_default_wallpaper = 0,
            background_color = "rgb(000000)",
            disable_splash_rendering = true,
        },
        xwayland = {
            force_zero_scaling = true,
        },
    })

    -- GESTURE
    hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace",
    })

    -- KEYBINDS
    local mainMod = "SUPER"
    hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))
    hl.bind(mainMod .. " + Q", hl.dsp.window.close())
    hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("spotify --enable-smooth-scrolling"))
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
    hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
    hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("librewolf"))
    hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
    hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("discord"))
    hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("libreoffice"))
    hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("gimp"))
    hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("QT_QPA_PLATFORM=xcb davinci-resolve-studio"))
    hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("lact"))
    hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("ghostty --class floating_mixer -e pulsemixer"))
    hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("easyeffects"))
    hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian --enable-smooth-scrolling"))
    hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("keepassxc"))
    hl.bind(mainMod .. " + INSERT", hl.dsp.exec_cmd("hyprshot -m window"))
    hl.bind(mainMod .. " + CTRL + X", hl.dsp.exec_cmd("hyprctl kill"))
    hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("filelight"))
    hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("exodus"))
    hl.bind(mainMod .. " + CONTROL + ALT + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
    hl.bind(mainMod .. " + CONTROL + O", hl.dsp.exec_cmd("osu!"))
    hl.bind(mainMod .. " + CONTROL + P", hl.dsp.exec_cmd("prismlauncher"))
    hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
    for i = 1, 9 do
        hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + ALT + " .. i, hl.dsp.window.move({ workspace = i }))
    end
    hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
    hl.bind(mainMod .. " + ALT + 0", hl.dsp.window.move({ workspace = 10 }))
    hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind(mainMod .. " + Page_Up", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true })
    hl.bind(mainMod .. " + Page_Down", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
    hl.bind(mainMod .. " + SHIFT + Page_Up", hl.dsp.exec_cmd("ddcutil -b 10 setvcp 10 + 20"), { locked = true, repeating = true })
    hl.bind(mainMod .. " + SHIFT + Page_Down", hl.dsp.exec_cmd("ddcutil -b 10 setvcp 10 - 20"), { locked = true, repeating = true })
    hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

    -- EXEC-ONCE
    hl.on("hyprland.start", function()
        hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
        hl.exec_cmd("otd-daemon")
    end)
  '';
  programs.hyprlock = {
    enable = true;
    package = pkgsUnstable.hyprlock;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = [
        {
        monitor = "";
        color = "rgb(0, 0, 0)";
        }
      ];
    };
  };

  # THEMES
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

  # HOME PACKAGES
  home.packages = with pkgs; [
    gnome-themes-extra
    adwaita-qt
    adwaita-icon-theme
    dconf
    qt6Packages.qt6ct
    papirus-icon-theme
  ];

  # TERMINAL
  programs.ghostty = {
    enable = true;
    package = pkgsUnstable.ghostty;
    settings = {
      confirm-close-surface = false;
      background = "#000000";
      foreground = "#ffffff";
      cursor-color = "#ffffff";
      selection-background = "#444444";
      selection-foreground = "#ffffff";
      palette = [
        "0=#000000"
        "1=#cd0000"
        "2=#00cd00"
        "3=#00cd00"
        "4=#0000ee"
        "5=#cd00cd"
        "6=#00cdcd"
        "7=#e5e5e5"
        "8=#7f7f7f"
        "9=#ff0000"
        "10=#00ff00"
        "11=#ffff00"
        "12=#5c5cff"
        "13=#ff00ff"
        "14=#00ffff"
        "15=#ffffff"
      ];
      window-theme = "ghostty";
      window-titlebar-background = "#000000";
      window-titlebar-foreground = "#ffffff";
      gtk-custom-css = "${config.xdg.configHome}/ghostty/gtk.css";
    };
  };

  # HOME VERSION
  home.stateVersion = "26.05";
}
