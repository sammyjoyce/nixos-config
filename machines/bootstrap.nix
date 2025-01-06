nix.package = pkgs.nix;
nix.settings.substituters = [ "https://mitchellh-nixos-config.cachix.org" ];
nix.settings.trusted-public-keys = ["mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="];
services.openssh.enable = true;
services.openssh.settings.PasswordAuthentication = true;
services.openssh.settings.PermitRootLogin = "yes";
users.users.root.initialPassword = "root";
