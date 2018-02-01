{ config, pkgs, ... }:
{
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };
  time.timeZone = "Europe/London";
  nix.useSandbox = true;
  services.xserver = {
    layout = "gb,ru";
    xkbOptions = "grp:caps_toggle, grp_led:caps";
    synaptics.enable = true;
  };

  users.extraUsers.rotsor = {
     isNormalUser = true;
     uid = 1000;
  };
  environment.systemPackages = with pkgs; [ ntfs3g ];

  # crazily, this is for ssh client to be able to find "xauth" program
  services.openssh.forwardX11 = true;
}
