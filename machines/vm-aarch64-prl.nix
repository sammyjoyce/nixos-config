{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  prl-tools = pkgs.callPackage ../pkgs/parallels-tools {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  imports = [
    # Parallels is qemu under the covers. This brings in important kernel
    # modules to get a lot of the stuff working.
    (modulesPath + "/profiles/qemu-guest.nix")

    ../modules/parallels-guest.nix
    ./vm-shared.nix
  ];

  # The official parallels guest support does not work currently.
  # https://github.com/NixOS/nixpkgs/pull/153665
  disabledModules = [ "virtualisation/parallels-guest.nix" ];
  hardware.parallels = {
    enable = true;
    package = (config.boot.kernelPackages.callPackage ../pkgs/parallels-tools/default.nix { 
      pkgs = pkgs;
    });
  };

  # Interface is this on my M1
  networking.interfaces.enp0s5.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;


  boot = {
    kernelPackages = pkgs.linuxPackages_6_12; # Explicitly set for Parallels compatibility
    extraModulePackages = [ prl-tools ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "prl_fs" "prl_fs_freeze" "prl_tg" ];
    kernelParams = [
      "root=/dev/sda2"
      "xhci_hcd.quirks=0x40"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];

  environment.systemPackages = [
    prl-tools
  ];
}
