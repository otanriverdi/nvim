return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")

      local options = {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "   ",
          selection_caret = ">  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "bottom_pane",
          layout_config = {
            height = 0.4,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { "node_modules" },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "filename_first" },
          winblend = 0,
          border = false,
          -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = false,
          disable_devicons = false,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            n = { ["q"] = require("telescope.actions").close },
          },
        },

        extensions = {
          file_browser = {
            files = false,
          },
        },

        extensions_list = { "fzf", "file_browser" },
      }

      telescope.setup(options)

      -- load extensions
      pcall(function()
        for _, ext in ipairs(options.extensions_list) do
          telescope.load_extension(ext)
        end
      end)
    end,
    init = function()
      local mappings = {
        n = {
          -- find
          ["<leader>ff"] = { "<cmd> Telescope find_files disable_devicons=true<CR>", "find files" },
          ["<leader>fa"] = {
            "<cmd> Telescope find_files disable_devicons=true no_ignore=true hidden=true file_ignore_patterns=node_modules<CR>",
            "find all",
          },
          ["<leader>fw"] = { "<cmd> Telescope live_grep disable_devicons=true<CR>", "live grep" },
          ["<leader>fb"] = { "<cmd> Telescope buffers disable_devicons=true<CR>", "find buffers" },
          ["<leader>fh"] = { "<cmd> Telescope help_tags disable_devicons=true<CR>", "help page" },
          ["<leader>fo"] = { "<cmd> Telescope oldfiles disable_devicons=true<CR>", "find oldfiles" },
          ["<leader>fk"] = { "<cmd> Telescope keymaps disable_devicons=true<CR>", "show keys" },
          ["<leader>fd"] = { "<cmd> Telescope file_browser disable_devicons=true<CR>", "find directories" },

          -- symbols
          ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols <CR>", "find document symbols" },

          -- LSP stuff
          ["gd"] = {
            "<cmd> Telescope lsp_definitions disable_devicons=true<CR>",
            "lsp definitions",
          },
          ["gr"] = {
            "<cmd> Telescope lsp_references disable_devicons=true<CR>",
            "lsp references",
          },
          ["gi"] = {
            "<cmd> Telescope lsp_implementations disable_devicons=true<CR>",
            "lsp implementation",
          },
          ["<leader>ld"] = {
            "<cmd> Telescope diagnostics disable_devicons=true<CR>",
            "lsp diagnostics",
          },
        },
      }

      require("core.utils").load_mappings(mappings)
    end,
  },
}
