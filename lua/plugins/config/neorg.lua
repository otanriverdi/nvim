return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  cmd = "Neorg",
  init = function()
    local mappings = {
      n = {
        ["<leader>nt"] = {
          "<cmd> Neorg journal today<CR>",
          "neorg todays journal",
        },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.export"] = {}, -- Loads default behaviour
        ["core.norg.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.norg.concealer"] = {
          config = {
            folds = false,
          },
        }, -- Adds pretty icons to your documents
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/org/notes",
              acc = "~/org/acc",
            },
            default_workspace = "notes",
          },
        },
        ["core.norg.journal"] = {
          config = {
            workspace = "notes",
          },
        },
        ["core.integrations.telescope"] = {},
      },
    })
    local neorg_callbacks = require("neorg.callbacks")

    neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
      keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
          { "<leader>o", "core.integrations.telescope.find_linkable" },
        },
      }, {
        silent = true,
        noremap = true,
      })
    end)
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neorg/neorg-telescope",
    "nvim-telescope/telescope.nvim",
  },
}
