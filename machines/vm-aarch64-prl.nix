# Hardware configuration.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    # Parallels is qemu under the covers. This brings in important kernel
    # modules to get a lot of the stuff working.
    (modulesPath + "/profiles/qemu-guest.nix")
    ./vm-shared.nix
    ../hardware/parallels.nix
  ];

  nixpkgs.overlays = [
    (import ../overlays/prl-tools.nix)
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  boot.kernelParams = [
    # "root=/dev/sda2"
    "xhci_hcd.quirks=0x40"
    # "video=Virtual-1:3024x1890@120"
  ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
}
