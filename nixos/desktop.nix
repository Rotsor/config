{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ./shared-configuration.nix
      ./desktop-hardware.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_testing;

  networking.hostName = "rotsor-desktop";

  environment.systemPackages = with pkgs; [ ];

  services.openssh.enable = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    enable = true;
    desktopManager.kde4.enable = false;
    services.xserver.displayManager.kdm.enable = true;
    services.xserver.desktopManager.kde4.enable = true;
  };

  boot.blacklistedKernelModules = [ ]; #"nouveau" ];

}
