{ pkgs, inputs, ... }:

{
  # Enable fontconfig
  fonts.fontconfig.enable = true;

  # Install standard developer fonts and Font Awesome
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-mono
  ];

  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.sammyjoyce = {
    isNormalUser = true;
    home = "/home/sam";
    extraGroups = [ "docker" "hyprland" "wheel" ];
    shell = pkgs.fish;
    PasswordAuthentication = false
    hashedPassword = "$6$p5nPhz3G6k$6yCK0m3Oglcj4ZkUXwbjrG403LBZkfNwlhgrQAqOospGJXJZ27dI84CbIYBNsTgsoH650C1EBsbCKesSVPSpB1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXh7t7uaTr9UX91R8oyodhhx5hKDNvGQIhV3JqFVvAc samjoyce@me.com"
    ];
  };

  programs.hyprland.enable = true;

  environment.systemPackages = [
    pkgs.kitty
    pkgs.wl-clipboard
  ];

}
