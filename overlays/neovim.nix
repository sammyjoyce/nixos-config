final: prev: {
  neovim-custom = final.neovim-nightly.override {
    configure = {
      customRC = ''
        ${builtins.readFile ../users/sammyjoyce/vim-config.nix}
      '';

      packages.myNeovimPackages = with final; {
        start = [
          vimPlugins.vim-cue
          vimPlugins.vim-fish
          vimPlugins.vim-glsl
          vimPlugins.vim-pgsql
          vimPlugins.vim-tla
          vimPlugins.vim-zig
          vimPlugins.pigeon
          vimPlugins.AfterColors
          vimPlugins.vim-nord
          vimPlugins.nvim-comment
          vimPlugins.nvim-conform
          vimPlugins.nvim-dressing
          vimPlugins.nvim-gitsigns
          vimPlugins.nvim-lualine
          vimPlugins.nvim-lspconfig
          vimPlugins.nvim-nui
          vimPlugins.nvim-plenary
          vimPlugins.nvim-telescope
          vimPlugins.nvim-treesitter
          vimPlugins.nvim-treesitter-playground
          vimPlugins.nvim-treesitter-textobjects
          vimPlugins.vim-eunuch
          vimPlugins.vim-markdown
          vimPlugins.vim-nix
          vimPlugins.typescript-vim
          vimPlugins.nvim-treesitter-parsers.elixir
          customVim.vim-copilot
          customVim.vim-misc
        ];
      };
    };
  };
}
