{ inputs, pkgs, ... }:

{
  # COMPOSITOR
  programs.hyprland = {
    enable = true;
    # Use the existing local HDR-patched Hyprland flake rather than the
    # stable nixpkgs package; keep its matching portal package in sync.
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  xdg.portal = {
    enable = true;
  };
  programs.fish.loginShellInit = ''
    if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
        exec start-hyprland
    end
  '';
  home-manager.users.lachlan = import ./home.nix;
  security.pam.services.hyprlock = {};
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
