return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon").setup()
  end,
  init = function()
    local mappings = {
      n = {
        ["<leader>ma"] = { ":lua require('harpoon'):list():add()<CR>", "add file to harpoon" },
        ["<leader>mf"] = {
          ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>",
          "toggle harpoon list",
        },
      },
    }

    for i = 1, 9 do
      mappings.n[string.format("<leader>%s", i)] = {
        string.format(":lua require('harpoon'):list():select(%s)<CR>", i),
        string.format("jump to harpoon file %s", i),
      }
    end

    require("core.utils").load_mappings(mappings)
  end,
}
