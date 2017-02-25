{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ../shared-configuration.nix
      ./desktop-hardware.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "rotsor-desktop";

  environment.systemPackages = with pkgs; [ ];

  services.openssh.enable = true;

  services.xserver = {
#    videoDrivers = [ "nvidia" ];
    enable = true;
#    displayManager.kdm.enable = true;
#    desktopManager.kde4.enable = true;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  boot.blacklistedKernelModules = [ ]; #"nouveau" ];

}
