# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

{config, pkgs, ...}:

{
 users.extraUsers.rotsor = {
   home = "/home/rotsor";
   createHome = true;
   useDefaultShell = true;
   description = "Arseniy Alekseyev";
   group = "users";
   uid = 1000;
 };
# users.defaultUserShell = "/run/current-system/sw/bin/bash";
 boot.supportedFilesystems = [ "zfs" ];
 boot.kernelModules = [ "acpi-call" "tp_smapi" ];
 boot.extraModulePackages= [ pkgs.linuxPackages.acpi_call  pkgs.linuxPackages.tp_smapi ];
  require = [
    # Include the configuration for part of your system which have been
    # detected automatically.
    ./hardware-configuration.nix
  ]; # 
 # boot.kernelPackages = pkgs.linuxPackages_3_7; # pkgs.linuxPackagesFor (pkgs.linux_3_1.override { extraConfig="DRM_RADEON_KMS y"; }) pkgs.linuxPackages;
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];
  boot.initrd.kernelModules = [
    # Specify all kernel modules that are necessary for mounting the root
    # file system.
    #
    "ext4" "ata_piix" "fuse" "kvm-amd" "tun" "vitrio" "kvm-intel" "hplip" "iwldvm" ];
  time.timeZone = "Europe/London";
  boot.loader.grub = {
    # Use grub 2 as boot loader.
    enable = true;
    version = 2;

    # Define on which hard drive you want to install Grub.
    device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_1TB_S1D9NSAF607839L";
    configurationName = "nixos-chronos";
  };

  networking = {
    hostId="34589711";
    hostName = "nixos-chronos"; # Define your hostname.
    interfaceMonitor.enable = false; # Watch for plugged cable.
    wireless = {
      enable = true;
      driver = "nl80211";
      interfaces = [ "wlp4s0" ];
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
  # Add file system entries for each partition that you want to see mounted
  # at boot time.  You can add filesystems which are not mounted at boot by
  # adding the noauto option.
  fileSystems = [
    # Mount the root file system
    #
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
      device = "192.168.2.5:/Boorg";
      fsType = "nfs";
      options = "vers=5";
    }

    # Copy & Paste & Uncomment & Modify to add any other file system.
    #
    # { mountPoint = "/data"; # where you want to mount the device
    #   device = "/dev/sdb"; # the device or the label of the device
    #   # label = "data";
    #   fsType = "ext3";      # the type of the partition.
    #   options = "data=journal";
    # }
  ];

  swapDevices = [
    # List swap partitions that are mounted at boot time.
    
    # { }
  ];

   # Select internationalisation properties.
   i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "uk";
     defaultLocale = "en_GB.UTF-8";
   };

  # List services that you want to enable:

  # Add an OpenSSH daemon.
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
  hardware.pulseaudio.enable = false;

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;
  environment.systemPackages = [ pkgs.fuse ];
  nix.useChroot = true;
  nix.maxJobs = 4;
  services.tor = {
    client.enable = true;
    client.privoxy.enable = true;
  };
#  hardware.usb_modeswitch.enable = true;
  services.postfix = {
    enable = true;
    domain = "rotsor.home.kg";
  };
}

