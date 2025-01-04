# Hardware configuration for Parallels
{ config, lib, pkgs, ... }: {
  boot.initrd.availableKernelModules = [     
    "xhci_pci"
    "usbhid"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "prl_fs" "prl_fs_freeze" "prl_tg" ];
  boot.kernelParams = [ "video=Virtual-1:3024x1890@120" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.prl-tools ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # Allow unfree packages for Parallels Tools
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "prl-tools" ];
  hardware.parallels = {
    enable = true;
    package = config.boot.kernelPackages.prl-tools;
  };

    fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
