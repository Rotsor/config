{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ../shared-configuration.nix
      ./desktop-hardware.nix
    ];
users.users.root.openssh.authorizedKeys.keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSXFREZ9X0FCNy40cMgEdYvd3eW0HuIs4M36jDNPBXTRp0v8p5yS2POgnKHsPb7jsWTJefylC6C3tyMyW8U21IegpnTK2pK/vjJyhfQh6ZzLFb0qMFfLH4QfIbtfSc1ZM3nvoHftwBm/RsmA/F+U5u/ammhM1NOqsSNaWPmaEPfmxpV6J7ByLOD3BRFKi7PcDi6QycrohDd9Tqm13R/hNS9B+c/PgQFrPH7x36dB2nINb44eny+CdzxajyigAEfmpayeKVI/2V24b1J+KkpGwBUWh30u4kPIAbN0g+0WJYXefeiDkR1NvwqYW2Yj1flVLxDNVtfTSbpaz+uRhU26UX rotsor@mosk"
];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "rotsor-desktop";

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

#  virtualisation.virtualbox.host.enable = true;
#  virtualisation.virtualbox.host.headless = true;

  environment.enableDebugInfo = true;

  system.stateVersion = "18.03";

#  systemd.services.great-service = {
#    description = "test service";
#    path = [ pkgs.bash pkgs.coreutils pkgs.openssh pkgs.autossh ];
#    script =
#      ''
#        exec 2>> ~/my-service.log
#        exec >&2
#        while true; do
#          autossh -M 20000 -R 9999:localhost:22 -N rotsor@51.15.171.16 || echo exited with $?
#          sleep 20
#        done
#        '';
#     wantedBy = [ "default.target"];
#  };
  
#  systemd.services.periodic-reboot = {
#    description = "periodic-reboot";
#    path = [ pkgs.bash pkgs.systemd pkgs.coreutils ];
#    script =
#      ''
#        set -euo pipefail
#        sleep 100000
#        reboot
#        '';
#     wantedBy = [ "default.target"];
#  };
}
