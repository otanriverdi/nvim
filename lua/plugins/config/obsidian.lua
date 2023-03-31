return {
  "epwalsh/obsidian.nvim",
  cmd = { "ObsidianSearch", "ObsidianToday", "ObsidianNew" },
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("obsidian").setup({
      dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/otrv",
      completion = {
        nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
      },
    })
  end,
  init = function()
    local mappings = {
      n = {
        ["<leader>of"] = {
          "<cmd> ObsidianSearch<CR>",
          "obsidian search",
        },
        ["<leader>ot"] = {
          "<cmd> ObsidianToday<CR>",
          "obsidian today",
        },
        ["<leader>on"] = {
          "<cmd> ObsidianNew<CR>",
          "obsidian new",
        },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}
