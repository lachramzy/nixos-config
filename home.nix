{ config, pkgs, ... }:

{
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  programs.git.enable = true;
  programs.git.settings.user.name = "lachlan";
  programs.git.settings.user.email = "lacjamram@gmail.com";

  programs.bash.enable = true;
  programs.bash.shellAliases = {
    btw = ''echo "i use nixos, by the way"'';
  };
  
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.bash.profileExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec Hyprland
    fi
  '';

  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-files/config/hypr";
    recursive = true;
  };

  # HYPRLAND RICE
  home.file.".config/hypr/hyprland.conf" = {
    text = ''
  # MONITOR
  monitor=HDMI-A-1,3840x2160@60,0x0,2

  # PROGRAMS
  $terminal = kitty
  $fileManager = dolphin
  $menu = rofi -show drun

  # AUTO-START
  exec-once = hyprpaper
  exec-once = eww daemon && eww open clock-window
  exec-once = gammastep

  # LAYER RULES
  layerrule = blur, ^(eww-clock-window)$
  layerrule = ignorezero, ^(eww-clock-window)$
  layerrule = animation none, rofi

  # ENVIRONMENT VARIABLES
  env = XCURSOR_SIZE,32
  env = HYPRCURSOR_SIZE,32

  # LOOK AND FEEL
  general {
      gaps_in = 20
      gaps_out = 38

      border_size = 3

      col.active_border = rgba(7aa2f7ff) rgba(7aa2f7ff) 45deg
      col.inactive_border = rgba(60606040)

      resize_on_border = false
      allow_tearing = false

      layout = dwindle
  }

  decoration {
      rounding = 0
      rounding_power = 0

      active_opacity = 1
      inactive_opacity = 0.9
      fullscreen_opacity = 1.0

      shadow {
          enabled = true
          range = 25
          render_power = 3
          color = rgba(000000c2)
      }

      blur {
          enabled = true
          size = 10
          passes = 2
          new_optimizations = true
          xray = false
          vibrancy = 0.1696
      }
  }

  animations {
      enabled = true

      bezier = smooth, 0.2, 1, 0.38, 1
      bezier = smoothMove, 0.3, 0.9, 0.4, 1
      bezier = snapSmooth, 0.18, 0.95, 0.35, 1
      bezier = easeOut, 0.14, 1, 0.28, 1
      bezier = linear, 0, 0, 1, 1

      animation = global, 1, 3, smooth
      animation = border, 1, 2, smooth

      animation = windows, 1, 3, smooth
      animation = windowsIn, 1, 3, smooth
      animation = windowsOut, 1, 2, easeOut
      animation = windowsMove, 1, 3, smoothMove

      animation = fade, 1, 3, linear
      animation = fadeIn, 1, 3, linear
      animation = fadeOut, 1, 2, linear

      animation = layers, 1, 3, smooth, slide
      animation = layersIn, 1, 3, smooth, slide
      animation = layersOut, 1, 2, easeOut, slide

      animation = fadeLayers, 1, 3, linear
      animation = fadeLayersIn, 1, 2, linear
      animation = fadeLayersOut, 1, 2, linear

      animation = workspaces, 1, 3, snapSmooth, slide
      animation = zoomFactor, 1, 3, smooth
  }

  dwindle {
      pseudotile = true
      preserve_split = true
  }

  master {
      new_status = master
  }

  misc {
      force_default_wallpaper = -1
      disable_hyprland_logo = false
  }

  # INPUT
  input {
      kb_layout = us
      repeat_delay = 150
      repeat_rate = 50

      follow_mouse = 1
      sensitivity = -0.6
      accel_profile = flat
  }

  gesture = 3, horizontal, workspace

  # KEYBINDS
  $mainMod = SUPER

  bind = $mainMod, RETURN, exec, $terminal
  bind = $mainMod, Q, killactive,
  bind = $mainMod, M, exit,
  bind = $mainMod, E, exec, $fileManager
  bind = $mainMod, V, togglefloating,
  bind = $mainMod, R, exec, $menu
  bind = $mainMod, P, pseudo,
  bind = $mainMod, J, togglesplit,
  bind = $mainMod, W, exec, librewolf
  bind = $mainMod, F, fullscreen
  bind = $mainMod, D, exec, discord
  bind = $mainMod, S, exec, spotify
  bind = $mainMod, O, exec, libreoffice
  bind = $mainMod, G, exec, gimp
  bind = $mainMod SHIFT, D, exec, QT_QPA_PLATFORM=xcb davinci-resolve-studio

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

  bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
  bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
  bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

  bindl = , XF86AudioNext, exec, playerctl next
  bindl = , XF86AudioPause, exec, playerctl play-pause
  bindl = , XF86AudioPlay, exec, playerctl play-pause
  bindl = , XF86AudioPrev, exec, playerctl previous

  # WINDOWS AND WORKSPACES
  windowrule = suppressevent maximize, class:.*
  windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
  '';
    force = true;
  };

  # WALLPAPER
  home.file = {
    ".config/hypr/hyprpaper.conf" = {
        text = ''
          preload = /home/lachlan/wallpapers/mountain2.jpg
          wallpaper = HDMI-A-1,/home/lachlan/wallpapers/mountain2.jpg
        '';
      };
    };

  # THEME RICE
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
    # platformTheme.name = "Adwaita";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  # DOLPHIN RICE
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style = Fusion
    custom_palette = true
    icon_theme = Papirus-Dark

    [Fonts]
    general = "JetBrainsMono Nerd Font,12,-1,5,50,0,0,0,0,0"

    [ColorPalette]
    active = #c8d3f5,#2f334d,#3b4261,#3b4261,#1e2030,#2f334d,#c8d3f5,#ffffff,#c8d3f5,#222436,#222436,#1e2030,#394b70,#c8d3f5,#82aaff,#c099ff,#222436,#2f334d,#c8d3f5
    inactive = #828bb8,#1e2030,#2f334d,#2f334d,#1e2030,#1e2030,#828bb8,#ffffff,#828bb8,#1e2030,#1e2030,#1e2030,#394b70,#828bb8,#636da6,#636da6,#1e2030,#1e2030,#828bb8
    disabled = #636da6,#1e2030,#2f334d,#2f334d,#1e2030,#1e2030,#636da6,#ffffff,#636da6,#1e2030,#1e2030,#1e2030,#2f334d,#636da6,#636da6,#636da6,#1e2030,#1e2030,#636da6
  '';

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

  # CLOCK WIDGET
  xdg.configFile."eww/eww.yuck".text = builtins.concatStringsSep "\n" [
    "(defpoll time :interval \"1s\""
    "  `date +%H:%M`)"
    ""
    "(defwindow clock-window"
    "  :monitor 0"
    "  :geometry (geometry :x \"50%\" :y \"50%\" :width \"400px\" :height \"200px\" :anchor \"center center\")"
    "  :stacking \"bottom\""
    "  :exclusive false"
    "  :focusable false"
    "  (box :orientation \"h\" :class \"clock-box\" :halign \"center\" :valign \"center\" :space-evenly false"
    "    (label :text \"\${time}\" :class \"clock-label\")))"
  ];
  xdg.configFile."eww/eww.yuck".force = true;

  xdg.configFile."eww/eww.scss".text = ''
    * { background: transparent; }
    window#clock-window {
      background: transparent;
    }
    .clock-box {
      background: transparent;
      border-radius: 0;
      padding: 0;
    }
    .clock-label {
      font-family: "JetBrainsMono Nerd Font";
      font-weight: bold;
      font-size: 128px;
      color: #c8d3f5;
      letter-spacing: 0px;
      text-shadow: 0px 0px 10px rgba(0, 0, 0, 0.75);
    }
  '';
  xdg.configFile."eww/eww.scss".force = true;

  # ROFI RICE
  home.file.".config/rofi/config.rasi" = {
    text = ''
    configuration {
      display-drun: "Applications:";
      display-window: "Windows:";
      drun-display-format: "{icon} {name}";
      font: "JetBrainsMono Nerd Font Medium 12";
      modi: "drun";
      show-icons: true;
      icon-theme: "Adwaita";
    }

    @theme "/dev/null"

    *{
            background-color: transparent;
            text-color: #c8d3f5;
    }
    window {
            fullscreen: true;
            background-color: #1e2030dd;
            padding: 4em;
            children: [ wrap, listview-split];
            spacing: 1em;
    }

    listview-split {
      orientation: horizontal;
      spacing: 0.4em;
      children: [listview];
    }

    wrap {
            expand: false;
            orientation: vertical;
            children: [ inputbar, message ];
            background-image: linear-gradient(#828bb814, #828bb814);
            border-color: #82aaff;
            border: 3px;
            border-radius: 0;
    }

    icon-ib {
            expand: false;
            filename: "system-search";
            vertical-align: 0.5;
            horizontal-align: 0.5;
            size: 1em;
    }

    inputbar {
            spacing: 0.4em;
            padding: 0.4em;
            children: [ icon-ib, entry ];
    }

    entry {
            placeholder: "Search";
            placeholder-color: #636da6;
    }

    message {
            background-color: #ff757f33;
            border-color: #ff966c;
            border: 3px 0px 0px 0px;
            padding: 0.4em;
            spacing: 0.4em;
    }

    listview {
            flow: horizontal;
            fixed-columns: true;
            columns: 7;
            lines: 5;
            spacing: 1.0em;
    }

    element {
            orientation: vertical;
            padding: 0.1em;
            background-image: linear-gradient(#828bb814, #828bb814);
            border-color: #82aaff26;
            border: 3px;
            border-radius: 0;
            children: [element-icon, element-text ];
    }

    element-icon {
            size: calc(((100% - 8em) / 7 ));
            horizontal-align: 0.5;
            vertical-align: 0.5;
    }

    element-text {
            horizontal-align: 0.5;
            vertical-align: 0.5;
            padding: 0.2em;
    }

    element selected {
            background-image: linear-gradient(#828bb840, #828bb840);
            border-color: #82aaff;
            border: 3px;
            border-radius: 0;
    }

    @media ( enabled: env(PREVIEW, false)) {
      icon-current-entry {
        expand:          true;
        size:            80%;
      }
      listview-split {
        children: [listview, icon-current-entry];
      }
      listview {
      columns: 4;
      }
    }

    @media ( enabled: env(NO_IMAGE, false)) {
      listview {
              columns: 1;
              spacing: 0.4em;
      }
      element {
              children: [ element-text ];
      }
      element-text {
              horizontal-align: 0.0;
      }
    }
  '';
    force = true;
  };

  # NEOVIM RICE
  programs.neovim = {
    enable = true;
    extraLuaConfig = ''
      vim.opt.background = "dark"

      local bg = "#222436"
      local bg_dark = "#1e2030"
      local fg = "#c8d3f5"
      local comment = "#636da6"
      local blue = "#82aaff"
      local cyan = "#86e1fc"
      local green = "#c3e88d"
      local red = "#ff757f"
      local yellow = "#ffc777"
      local purple = "#fca7ea"

      vim.api.nvim_set_hl(0, "Normal", { bg = bg, fg = fg })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_dark })
      vim.api.nvim_set_hl(0, "Comment", { fg = comment, italic = true })
      vim.api.nvim_set_hl(0, "String", { fg = green })
      vim.api.nvim_set_hl(0, "Function", { fg = blue })
      vim.api.nvim_set_hl(0, "Keyword", { fg = purple, italic = true })
      vim.api.nvim_set_hl(0, "Identifier", { fg = blue })
      vim.api.nvim_set_hl(0, "Constant", { fg = cyan })
      vim.api.nvim_set_hl(0, "Statement", { fg = purple })
      vim.api.nvim_set_hl(0, "PreProc", { fg = yellow })
      vim.api.nvim_set_hl(0, "Type", { fg = cyan })
      vim.api.nvim_set_hl(0, "Special", { fg = yellow })
      vim.api.nvim_set_hl(0, "Error", { fg = red })
      vim.api.nvim_set_hl(0, "Todo", { bg = yellow, fg = bg, bold = true })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_dark, fg = fg })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#3b4261" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = bg_dark, fg = fg })
      vim.api.nvim_set_hl(0, "LineNr", { fg = comment })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2f334d" })
    '';
  };

  # KITTY RICE
  home.file = {
        ".config/kitty/kitty.conf".text = ''
  include themes/tokyo-night-moon.conf

  font_family JetBrains Mono
  font_size 12.0
  background_opacity 1

  confirm_exit no
  confirm_os_window_close 0
  '';

        ".config/kitty/themes/tokyo-night-moon.conf".text = ''
  # Tokyo Night Moon
  foreground        #c8d3f5
  background        #222436

  selection_background #3654a7
  selection_foreground #c8d3f5
  cursor              #c8d3f5
  cursor_text_color   #222436
  url_color           #4fd6be

  color0  #1b1d2b
  color1  #ff757f
  color2  #c3e88d
  color3  #ffc777
  color4  #82aaff
  color5  #c099ff
  color6  #86e1fc
  color7  #828bb8

  color8  #444a73
  color9  #ff757f
  color10 #c3e88d
  color11 #ffc777
  color12 #82aaff
  color13 #c099ff
  color14 #86e1fc
  color15 #c8d3f5

  active_tab_background   #82aaff
  active_tab_foreground   #1e2030
  inactive_tab_background #2f334d
  inactive_tab_foreground #545c7e
  '';
  };
  home.file.".config/kitty/kitty.conf".force = true;

  # TERMINAL PROMPT RICE
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        $os$directory$git_branch$git_status$nodejs$rust$golang$php$java$julia$ocaml$zig$lua$python$ruby$dart$c$time
        $character
      '';

      os = {
        disabled = false;
        format = "[ $symbol ](fg:#090c0c bg:#636da6)";
        symbols = {
          NixOS = " ";
        };
      };

      directory = {
        style = "fg:#c8d3f5 bg:#82aaff";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "fg:#82aaff bg:#394b70";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "fg:#82aaff bg:#394b70";
        format = "[($all_status$ahead_behind )]($style)";
      };

      nodejs = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      golang = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      php = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      java = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      julia = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      ocaml = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      zig = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      lua = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      python = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      ruby = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      dart = {
        symbol = "";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      c = {
        symbol = "󰬊";
        style = "fg:#82aaff bg:#222436";
        format = "[ $symbol ($version) ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "fg:#828bb8 bg:#1e2030";
        format = "[  $time ]($style)";
      };
    };
  };

  home.stateVersion = "25.11";
}
