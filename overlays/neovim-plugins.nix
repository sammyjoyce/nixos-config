final: prev: {
  vimPlugins = prev.vimPlugins // rec {
    nvim-conform = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "nvim-conform";
      version = "7.1.0";
      src = prev.fetchFromGitHub {
        owner = "stevearc";
        repo = "conform.nvim";
        rev = "v7.1.0";
        sha256 = "sha256-j5h55X+R55Z55555555555555555555555555555555555=";
      };
      meta.homepage = "https://github.com/stevearc/conform.nvim";
    };

    nvim-dressing = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "dressing.nvim";
      version = "0.1.0";
      src = prev.fetchFromGitHub {
        owner = "stevearc";
        repo = "dressing.nvim";
        rev = "68454a57d6905944f7fe55077d4c745fe5775d46";
        sha256 = lib.fakeSha256;
      };
      meta.homepage = "https://github.com/stevearc/dressing.nvim";
    };

    nvim-gitsigns = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "gitsigns.nvim";
      version = "0.9.0";
      src = prev.fetchFromGitHub {
        owner = "lewis6991";
        repo = "gitsigns.nvim";
        rev = "v0.9.0";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/lewis6991/gitsigns.nvim";
    };

    nvim-lspconfig = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "nvim-lspconfig";
      version = "2024-01-17";
      src = prev.fetchFromGitHub {
        owner = "neovim";
        repo = "nvim-lspconfig";
        rev = "574770519d97257bdc4755575d45d74075404d8e";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/neovim/nvim-lspconfig";
    };

    nvim-lualine = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "lualine.nvim";
      version = "2.3.2";
      src = prev.fetchFromGitHub {
        owner = "nvim-lualine";
        repo = "lualine.nvim";
        rev = "773c787e5ca37d9c258540889f684a05e2d4b57a";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/nvim-lualine/lualine.nvim";
    };

    nvim-nui = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "nui.nvim";
      version = "2024-01-17";
      src = prev.fetchFromGitHub {
        owner = "MunifTanjim";
        repo = "nui.nvim";
        rev = "94d0c655dd5f755794557994f85f1d4d5f8545b9";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/MunifTanjim/nui.nvim";
    };

    nvim-plenary = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "plenary.nvim";
      version = "2024-01-17";
      src = prev.fetchFromGitHub {
        owner = "nvim-lua";
        repo = "plenary.nvim";
        rev = "1a0d07082b75d7d4d5d2b27ea52cc4d485575566";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
    };

    nvim-telescope = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "telescope.nvim";
      version = "0.1.8";
      src = prev.fetchFromGitHub {
        owner = "nvim-telescope";
        repo = "telescope.nvim";
        rev = "0.1.8";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/nvim-telescope/telescope.nvim";
    };

    nvim-treesitter = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "nvim-treesitter";
      version = "0.9.2";
      src = prev.fetchFromGitHub {
        owner = "nvim-treesitter";
        repo = "nvim-treesitter";
        rev = "v0.9.2";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter";
    };

    nvim-web-devicons = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "nvim-web-devicons";
      version = "2024-01-17";
      src = prev.fetchFromGitHub {
        owner = "nvim-tree";
        repo = "nvim-web-devicons";
        rev = "45d725679d39cc48b347959d65dd44e4447fe995";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/nvim-tree/nvim-web-devicons";
    };

    vim-copilot = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "copilot.vim";
      version = "1.41.0";
      src = prev.fetchFromGitHub {
        owner = "github";
        repo = "copilot.vim";
        rev = "v1.41.0";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/github/copilot.vim";
    };

    vim-misc = prev.vimUtils.buildVimPluginFrom2Nix {
      pname = "vim-misc";
      version = "2024-01-17";
      src = prev.fetchFromGitHub {
        owner = "mitchellh";
        repo = "vim-misc";
        rev = "0553b7cb9429c70477c51eb55d58fe4555b79592";
        sha256 = "sha256-???"; # Replace!
      };
      meta.homepage = "https://github.com/mitchellh/vim-misc";
    };
  };
}
