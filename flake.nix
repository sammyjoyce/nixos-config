{
  description = "NixOS systems and tools by sammyjoyce";

  inputs = {
    # Pin our primary nixpkgs repository
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # System management
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # UI components
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    # Development tools
    jujutsu.url = "github:martinvonz/jj";
    zig.url = "github:mitchellh/zig-overlay";
    ghostty.url = "github:ghostty-org/ghostty";
    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim and plugins
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Additional sources from old sources.json
    tree-sitter-proto.url = "github:mitchellh/tree-sitter-proto";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix {
        inherit inputs;
      };
      # Define pkgs here for each supported system
      allSystems = [ "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.all ];
            config.allowUnfree = true;
          };
        });
    in
    {
    # Define overlays globally for all systems
    overlays = rec {
      # Make all overlays available under the "all" attribute
      all = final: prev: {
        jujutsu = inputs.jujutsu.overlays.default final prev;
        zig = inputs.zig.overlays.default final prev;
        prl-tools = (import ./overlays/prl-tools.nix) final prev;
        vim = (import ./users/sammyjoyce/vim.nix { inherit inputs; }) final prev;
        neovim-plugins = (import ./overlays/neovim-plugins.nix) final prev;
        neovim = (import ./overlays/neovim.nix) final prev;
        go = (import ./overlays/go.nix { inherit (final) lib fetchurl; }) final prev;
      };

      # Also provide each overlay individually
      prl-tools = final: prev: (import ./overlays/prl-tools.nix) final prev;
      neovim = final: prev: (import ./overlays/neovim.nix) final prev;
    };
    nixosConfigurations.vm-aarch64-prl = {
      system = "aarch64-linux";
      config = mkSystem {
        name = "vm-aarch64-prl";
        user = "sam";

        environment.systemPackages = [
          inputs.ghostty.packages.aarch64-linux.default
        ];

        nix = import ./nix/settings.nix;
      };
    };

    darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
      system = "aarch64-darwin";
      user   = "sammyjoyce";
      darwin = rec { inherit (self.overlays) all; };
    };
    devShells = forAllSystems ({ pkgs }: {
      zig-dev = pkgs.mkShell {
        # Required for building Ghostty from source
        buildInputs = [
          inputs.zig.packages.${pkgs.system}.latest
          pkgs.pkg-config
          pkgs.gtk4
          pkgs.libadwaita
          pkgs.git
        ];
      };

      go-dev = pkgs.mkShell {
        buildInputs = [
          pkgs.go
          pkgs.gopls
          pkgs.delve
          pkgs.gotools
        ];
      };

      # Add a devShell for the current system
      default = pkgs.mkShell {
        packages = [
          inputs.nix-direnv.packages.${pkgs.system}.default
        ];

        # Set up direnv integration
        shellHook = ''
          eval "$(direnv hook bash)"
        '';
      };
    });
  };
}
