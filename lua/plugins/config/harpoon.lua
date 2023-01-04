return {
  "ThePrimeagen/harpoon",
  init = function()
    local mappings = {
      n = {
        ["<leader>ma"] = { ":lua require('harpoon.mark').add_file()<CR>", "add file to harpoon" },
        ["<leader>mr"] = { ":lua require('harpoon.mark').rm_file()<CR>", "add file to harpoon" },
        ["<leader>mf"] = { ":lua require('harpoon.ui').toggle_quick_menu()<CR>", "toggle harpoon menu" },
        ["<TAB>"] = { ":lua require('harpoon.ui').nav_next()<CR>", "jump to next harpoon file" },
        ["<S-Tab>"] = { ":lua require('harpoon.ui').nav_prev()<CR>", "jump to next harpoon file" },
      },
    }

    for i = 1, 9 do
      mappings.n[string.format("<leader>%s", i)] =
        { string.format(":lua require('harpoon.ui').nav_file(%s)<CR>", i), string.format("jump to harpoon file %s", i) }
    end

    require("core.utils").load_mappings(mappings)
  end,
}
