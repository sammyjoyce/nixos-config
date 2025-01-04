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
    ./hardware/parallels.nix
  ];

  nixpkgs.overlays = [
    (import ../overlays/prl-tools.nix)
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  fileSystems."/host" = {
    device = "prl_fs";
    fsType = "prl_fs";
    options = [
      "rw"
      "noatime"
      "share"
      "dmode=775"
      "fmode=664"
      "uid=1000"
      "gid=100"
      "umask=002"
    ];
  };
}
