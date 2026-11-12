{ ... }:

{
  # Hyprland compositor
  programs.hyprland = {
    enable = true;
  };

  # Desktop / Wayland environment
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  xdg.portal = {
    enable = true;
  };

  # Launch Hyprland from the first virtual console
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
        exec start-hyprland
    end
  '';

  # Keep the Home Manager desktop configuration grouped under the rice module.
  # The actual per-user settings remain in home.nix, which is a Home Manager module.
  home-manager.users.lachlan = import ./home.nix;

  # Lock-screen and desktop credential integration
  security.pam.services.hyprlock = {};
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
