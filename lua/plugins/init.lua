-- Load all plugins
local present, packer = pcall(require, "packer")

if present then
  -- load packer init options
  local init_options = require("plugins.configs.others").packer_init()
  packer.init(init_options)

  packer.startup(function(use)
    -- Helper scripts bunch of plugins use
    use { "nvim-lua/plenary.nvim", module = "plenary" }

    -- Decreases load time
    use "lewis6991/impatient.nvim"

    -- Package manager itself
    use {
      "wbthomason/packer.nvim",
      cmd = require("core.lazy_load").packer_cmds,
      config = function()
        require "plugins"
      end,
    }

    -- Devicons bunch of plugins use
    use {
      "kyazdani42/nvim-web-devicons",
      module = "nvim-web-devicons",
      config = function()
        require("plugins.configs.others").devicons()
      end,
    }

    -- Colorscheme
    use {
      "folke/tokyonight.nvim",
      config = function()
        require "plugins.configs.tokyonight"
      end,
    }

    -- Statusline
    use {
      "nvim-lualine/lualine.nvim",
      config = function()
        require "plugins.configs.lualine"
      end,
    }

    -- Indentation guides
    use {
      "lukas-reineke/indent-blankline.nvim",
      opt = true,
      setup = function()
        require("core.lazy_load").on_file_open "indent-blankline.nvim"
        require("core.utils").load_mappings "blankline"
      end,
      config = function()
        require("plugins.configs.others").blankline()
      end,
    }

    -- Displays colors on color codes
    use {
      "NvChad/nvim-colorizer.lua",
      opt = true,
      setup = function()
        require("core.lazy_load").on_file_open "nvim-colorizer.lua"
      end,
      config = function()
        require("plugins.configs.others").colorizer()
      end,
    }

    -- Syntax highlighting
    use {
      "nvim-treesitter/nvim-treesitter",
      module = "nvim-treesitter",
      setup = function()
        require("core.lazy_load").on_file_open "nvim-treesitter"
      end,
      cmd = require("core.lazy_load").treesitter_cmds,
      run = ":TSUpdate",
      config = function()
        require "plugins.configs.treesitter"
      end,
    }

    use {
      "nvim-treesitter/nvim-treesitter-context",
      after = "nvim-treesitter",
    }

    -- Git status signs on buffers
    use {
      "lewis6991/gitsigns.nvim",
      ft = "gitcommit",
      setup = function()
        require("core.lazy_load").gitsigns()
      end,
      config = function()
        require("plugins.configs.others").gitsigns()
      end,
    }

    -- LSP or diagnostics tools installer
    use {
      "williamboman/mason.nvim",
      cmd = require("core.lazy_load").mason_cmds,
      config = function()
        require "plugins.configs.mason"
      end,
    }

    -- Configures LSPs
    use {
      "neovim/nvim-lspconfig",
      opt = true,
      setup = function()
        require("core.lazy_load").on_file_open "nvim-lspconfig"
      end,
      config = function()
        require "plugins.configs.lspconfig"
      end,
    }

    -- Preconfigured snippets. Lazy loads in first insert
    use {
      "rafamadriz/friendly-snippets",
      module = { "cmp", "cmp_nvim_lsp" },
      event = "InsertEnter",
    }

    -- CMP. It's loaded after friendly-snippets for lazy loading
    use {
      "hrsh7th/nvim-cmp",
      after = "friendly-snippets",
      config = function()
        require "plugins.configs.cmp"
      end,
    }

    -- Snippet engine
    use {
      "L3MON4D3/LuaSnip",
      wants = "friendly-snippets",
      after = "nvim-cmp",
      config = function()
        require("plugins.configs.others").luasnip()
      end,
    }

    -- CMP extensions
    use { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" }
    use { "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" }
    use { "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" }
    use { "hrsh7th/cmp-nvim-lsp-signature-help", after = "cmp-nvim-lsp" }
    use { "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" }
    use { "hrsh7th/cmp-path", after = "cmp-buffer" }

    -- Code formatting, diagnostics, linting etc
    use {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
        require "plugins.configs.null-ls"
      end,
    }

    -- Auto close brackets
    use {
      "windwp/nvim-autopairs",
      after = "nvim-cmp",
      config = function()
        require("plugins.configs.others").autopairs()
      end,
    }

    -- Auto comment
    use {
      "numToStr/Comment.nvim",
      module = "Comment",
      keys = { "gc", "gb" },
      config = function()
        require("plugins.configs.others").comment()
      end,
      setup = function()
        require("core.utils").load_mappings "comment"
      end,
    }

    -- File tree
    use {
      "kyazdani42/nvim-tree.lua",
      ft = "alpha",
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      config = function()
        require "plugins.configs.nvimtree"
      end,
      setup = function()
        require("core.utils").load_mappings "nvimtree"
      end,
    }

    -- Fuzzy finder
    use {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      config = function()
        require "plugins.configs.telescope"
      end,
      setup = function()
        require("core.utils").load_mappings "telescope"
      end,
    }

    -- Auto close JSX tags
    use {
      "windwp/nvim-ts-autotag",
      opt = true,
      setup = function()
        require("core.lazy_load").on_file_open "nvim-ts-autotag"
      end,
    }

    -- Add and travel to file marks
    use {
      "ThePrimeagen/harpoon",
      setup = function()
        require("core.utils").load_mappings "harpoon"
      end,
    }

    -- Detect and set indentation
    use {
      "nmac427/guess-indent.nvim",
      opt = true,
      setup = function()
        require("core.lazy_load").on_file_open "guess-indent.nvim"
      end,
      config = function()
        require("plugins.configs.others").guessindent()
      end,
    }

    -- Git diff and merge tool
    use {
      "sindrets/diffview.nvim",
      requires = "nvim-lua/plenary.nvim",
      cmd = require("core.lazy_load").diffview_cmds,
      config = function()
        require("plugins.configs.others").diffview()
      end,
      setup = function()
        require("core.utils").load_mappings "diffview"
      end,
    }

    -- Welcome screen
    use {
      "goolord/alpha-nvim",
      requires = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("alpha").setup(require("alpha.themes.startify").config)
      end,
    }

    -- DAP setup
    use {
      "mfussenegger/nvim-dap",
      cmd = require("core.lazy_load").dap_cmds,
      config = function()
        require("plugins.configs.dap").dap()
      end,
      setup = function()
        require("core.utils").load_mappings "dap"
      end,
    }

    -- Telescope helpers for DAP commands
    use { "nvim-telescope/telescope-dap.nvim", after = { "nvim-dap", "telescope.nvim" } }

    -- Virtual text for dap
    use {
      "theHamsta/nvim-dap-virtual-text",
      after = "nvim-dap",
      config = function()
        require("plugins.configs.dap").dap_virtual_text()
      end,
    }

    -- A better UI for DAP
    use {
      "rcarriga/nvim-dap-ui",
      after = "nvim-dap",
      config = function()
        require("plugins.configs.dap").dapui()
      end,
    }
  end)
end
