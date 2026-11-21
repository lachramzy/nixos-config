{ pkgsUnstable, ... }:

  let
    lib = pkgsUnstable.lib;

    # FFMPEG ENCODER PLUGIN
    ffmpegPluginVersion = "1.4.0";
    ffmpegPluginArchive = pkgsUnstable.fetchzip {
      url = "https://github.com/EdvinNilsson/ffmpeg_encoder_plugin/releases/download/v${ffmpegPluginVersion}/ffmpeg_encoder_plugin.dvcp.bundle.zip";
      hash = "sha256-LEnMA6A0yMOEg3wS+1WIu4yX2CdW+gonmun0Y8eSPxE=";
      stripRoot = false;
    };
    ioPluginBundles = [
      "${ffmpegPluginArchive}/ffmpeg_encoder_plugin.dvcp.bundle"
    ];
    originalDavinci =
      pkgsUnstable.davinci-resolve-studio.davinci;
    davinciWithPlugins = originalDavinci.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        mkdir -p "$out/IOPlugins"
        ${lib.concatMapStringsSep "\n" (bundle: ''
          cp -a "${bundle}" "$out/IOPlugins/"
        '') ioPluginBundles}
        chmod 755 \
          "$out/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/ffmpeg_encoder_plugin.dvcp"
        test -x "$out/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/ffmpeg_encoder_plugin.dvcp"
      '';
    });
    replaceDavinciPath = value:
      lib.replaceStrings
        [ "${originalDavinci}" ]
        [ "${davinciWithPlugins}" ]
        value;
    davinciStudio = pkgsUnstable.callPackage
      "${pkgsUnstable.path}/pkgs/by-name/da/davinci-resolve/package.nix"
      {
        studioVariant = true;
        buildFHSEnv = args:
          pkgsUnstable.buildFHSEnv (args // {
              targetPkgs = fhsPkgs:
                (map
                  (drv:
                    if (drv.pname or null) == "davinci-resolve-studio"
                    then davinciWithPlugins
                    else drv
                  )
                  (args.targetPkgs fhsPkgs)
                )
                ++ [
                  fhsPkgs.libva
                  fhsPkgs.vulkan-loader
                ];
            runScript = "${pkgsUnstable.bash}/bin/bash ${
              pkgsUnstable.writeText "davinci-wrapper" ''
                export QT_XKB_CONFIG_ROOT="${pkgsUnstable.xkeyboard_config}/share/X11/xkb"
                export QT_PLUGIN_PATH="${davinciWithPlugins}/libs/plugins:$QT_PLUGIN_PATH"
                export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinciWithPlugins}/libs

                if [ $# -gt 0 ]; then
                  exec "$@"
                else
                  exec ${davinciWithPlugins}/bin/resolve
                fi
              ''
            }";
            extraBwrapArgs =
              map replaceDavinciPath (args.extraBwrapArgs or []);
            extraInstallCommands =
              replaceDavinciPath (args.extraInstallCommands or "");
            passthru = (args.passthru or {}) // {
              davinci = davinciWithPlugins;
            };
          });
      };

  in
  {
    environment.systemPackages = [
      davinciStudio
    ];
}
