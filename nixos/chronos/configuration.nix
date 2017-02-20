{config, pkgs, ...}:

{
# users.extraUsers.vm = {
#   password = "vm";
#   shell = "${pkgs.bash}/bin/bash";
#   group = "wheel";
# };
 users.extraUsers.rotsor = {
   home = "/home/rotsor";
   createHome = true;
   useDefaultShell = true;
   description = "Arseniy Alekseyev";
   group = "users";
   uid = 1000;
 };
 security.sudo.configFile = ''
    Defaults env_reset
    ALL ALL = NOPASSWD: /root/brightness
  '';
# users.defaultUserShell = "/run/current-system/sw/bin/bash";
 boot.supportedFilesystems = [ "zfs" ];
# boot.extraModulePackages= [ pkgs.linuxPackages.acpi_call  pkgs.linuxPackages.tp_smapi ];
# boot.kernelModules = [ "acpi-call" "tp_smapi" ];
  require = [
    ./hardware-configuration.nix
  ]; # 
  boot.kernelPackages = pkgs.linuxPackages_3_14; # _3_14; # pkgs.linuxPackagesFor (pkgs.linux_3_1.override { extraConfig="DRM_RADEON_KMS y"; }) pkgs.linuxPackages;

  time.timeZone = "Europe/London";
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_1TB_S1D9NSAF607839L";
    configurationName = "nixos-chronos";
  };

  networking = {
    hostId="34589711";
    hostName = "nixos-chronos2";
    wireless = {
      enable = true;
      driver = "nl80211";
      interfaces = [ "wlp2s0" ];
    };
    useDHCP = true;
    wicd.enable = false;
    nameservers = [ "8.8.8.8" ];
/*    localCommands =
      ''
        ${pkgs.vde2}/bin/vde_switch -tap tap0 -mod 660 -group kvm -daemon
        ip addr add 10.0.3.1/24 dev tap0
        ip link set dev tap0 up
        ${pkgs.procps}/sbin/sysctl -w net.ipv4.ip_forward=1
        ${pkgs.iptables}/sbin/iptables -t nat -A POSTROUTING -s 10.0.3.0/24 -j MASQUERADE
        
        ip addr add 10.0.2.100/24 dev eth0
        ip link set dev eth0 up
        ip route add default via 10.0.2.1
        echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
      ''; */
  };
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  fileSystems = [
    { mountPoint = "/";
      device = "chronos/zfs1";
      fsType = "zfs";
    }
    { mountPoint = "/home";
      device = "chronos/home";
      fsType = "zfs";
    }
    { mountPoint = "/boot";
      device = "/dev/sda2";
      fsType = "ext2";
    }
    { mountPoint = "/Boorg";
      device = "192.168.1.7:/";
      fsType = "nfs";
      options = ["nolock,vers=4"];
    }
  ];

  swapDevices = [
    { device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_1TB_S1D9NSAF607839L-part3"; }
  ];

   # Select internationalisation properties.
   i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "uk";
     defaultLocale = "en_GB.UTF-8";
   };

  services.openssh.enable = true;
  services.udev.extraRules = "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"03f0\", ATTRS{idProduct}==\"7e04\", MODE:=\"0666\"";

  networking.firewall.enable = false;
  services.httpd = {
    enable = true;
    enableUserDir = true;
    adminAddr = "rotsor@gmail.com";
    extraModules = [ { name = "php5"; path = "${pkgs.php}/modules/libphp5.so"; } ];
  };

  # Add CUPS to print documents.
  # services.printing.enable = true;

  # Add XServer (default if you have used a graphical iso)
  services.xserver = {
    # videoDrivers = ["ati_unfree"];
/*    config = ''
        Section "InputClass"
          Identifier "Razer  Razer Abyssus"
	  Driver "evdev"
	  Option "Device" "/dev/input/by-id/usb-Razer_Razer_Abyssus-event-mouse"
	  Option "AccelerationProfile" "2"
	  Option "ConstantDeceleration" "4"
        EndSection
    ''; */
    enable = true;
    layout = "gb,ru";
    xkbOptions = "grp:caps_toggle, grp_led:caps";
    desktopManager.kde4.enable = false;
    synaptics.enable = true;
  };
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;
  environment.systemPackages = [ pkgs.fuse ];
  nix.useChroot = true;
  nix.maxJobs = 4;
  services.tor = {
    enable = true;
    client.enable = true;
    client.privoxy.enable = true;
  };
#  hardware.usb_modeswitch.enable = true;
  services.postfix = {
    enable = true;
    domain = "rotsor.home.kg";
  };

  nixpkgs.config.packageOverrides = pkgs: rec {
    mesa_noglu = pkgs.callPackage (<nixpkgs/pkgs/development/libraries/mesa>) {
      grsecEnabled = true;
      llvmPackages = pkgs.llvmPackages_36;
      enableTextureFloats = true;
    };
  };  
}

