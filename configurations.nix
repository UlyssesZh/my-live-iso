# sudo mount /dev/disk/by-label/nixos /mnt
# sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
# sudo swapon /dev/disk/by-label/swap
# sudo nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=my-os.nix --option substituters https://mirrors.ustc.edu.cn/nix-channels/store --store /mnt
{ pkgs, modulesPath, lib, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
    "${modulesPath}/installer/cd-dvd/latest-kernel.nix"
  ];

  isoImage.configurationName = "Normal";

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ rime ];
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    tree
    tmux

    wechat
    qq
    discord
    zoom-us
  ];

  users.users.nixos = {
    extraGroups = [ "adbusers" "networkmanager" "docker" "vboxusers" "input" "disk" "camera" ];
  };

  programs.steam.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  boot.kernelModules = [ "snd-aloop" ];

  specialisation.china = {
    inheritParentConfig = true;
    configuration = { config, ... }: {
      isoImage.showConfiguration = true;
      isoImage.configurationName = lib.mkForce "China GFW";

      programs.clash-verge = {
        enable = true;
        autoStart = true;
        serviceMode = true;
        tunMode = true;
      };

      nix.settings.substituters = lib.mkForce [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
    };
  };
}
