# Hardware configuration for Parallels
{ config, lib, pkgs, ... }: {
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "sr_mod"
    ];
    initrd.kernelModules = [];
    kernelModules = ["prl_fs" "prl_fs_freeze" "prl_tg"];
    kernelParams = ["video=Virtual-1:2304x1296@60"];
    extraModulePackages = [config.boot.kernelPackages.prl-tools];
  };

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
