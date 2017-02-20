{ config, pkgs, lib, ... }:
{
  ## Everything below is generated from nixos-in-place; modify with caution!
  boot.kernelParams = ["boot.shell_on_fail"];
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.storePath = "/nixos/nix/store";
  boot.initrd.supportedFilesystems = [ "ext4" ];
  boot.initrd.postDeviceCommands = ''
    mkdir -p /mnt-root/old-root ;
    mount -t ext4 /dev/mapper/ubuntu--vg-root /mnt-root/old-root ;
  '';
  fileSystems = {
    "/" = {
      device = "/old-root/nixos";
      fsType = "none";
      options = [ "bind" ];
    };
    "/old-root" = {
      device = "/dev/mapper/ubuntu--vg-root";
      fsType = "ext4";
    };
  };

  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "ahci" "usbhid" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ea84c260-8cb6-4b27-81ec-93373d95c132"; }
    ];
}
