return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup()
        end,
      },
      "windwp/nvim-ts-autotag",
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSEnable", "TSDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      local t = require("nvim-treesitter.configs")

      local options = {
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = { "markdown" },
        },

        indent = {
          enable = true,
        },

        ensure_installed = {
          "vim",
          "lua",
          "html",
          "css",
          "scss",
          "sql",
          "javascript",
          "json",
          "typescript",
          "tsx",
          "go",
          "rust",
          "markdown",
          "python",
        },

        autotag = {
          enable = true,
        },
      }

      t.setup(options)
    end,
  },
}
